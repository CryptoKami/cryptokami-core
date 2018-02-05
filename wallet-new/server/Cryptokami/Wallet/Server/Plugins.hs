{- | A collection of plugins used by this edge node.
     A @Plugin@ is essentially a set of actions which will be run in
     a particular monad, at some point in time.
-}
{-# LANGUAGE TupleSections #-}
module Cryptokami.Wallet.Server.Plugins (
      Plugin
    , acidCleanupWorker
    , conversation
    , walletBackend
    , resubmitterPlugin
    , notifierPlugin
    ) where

import           Universum

import           Cryptokami.Wallet.API as API
import           Cryptokami.Wallet.Server as API
import           Cryptokami.Wallet.Server.CLI (RunMode, WalletBackendParams (..), isDebugMode,
                                            walletAcidInterval, walletDbOptions)

import           Formatting (build, sformat, (%))
import           Network.Wai (Application, Middleware)
import           Network.Wai.Middleware.Cors (cors, corsMethods, corsRequestHeaders,
                                              simpleCorsResourcePolicy, simpleMethods)
import           Network.Wai.Middleware.RequestLogger (logStdoutDev)
import           Pos.Diffusion.Types (Diffusion (..))
import           Pos.Wallet.Web (cleanupAcidStatePeriodically)
import           Pos.Wallet.Web.Pending.Worker (startPendingTxsResubmitter)
import qualified Pos.Wallet.Web.Server.Runner as V0
import           Pos.Wallet.Web.Sockets (getWalletWebSockets, upgradeApplicationWS)
import           Servant (serve)
import           System.Wlog (logInfo, modifyLoggerName)

import           Pos.Communication (OutSpecs)
import           Pos.Communication.Util (ActionSpec (..))
import           Pos.Context (HasNodeContext)

import           Pos.Configuration (walletProductionApi, walletTxCreationDisabled)
import           Pos.Launcher.Configuration (HasConfigurations)
import           Pos.Util.CompileInfo (HasCompileInfo)
import           Pos.Wallet.Web.Mode (WalletWebMode)
import           Pos.Wallet.Web.Server.Launcher (walletServeImpl, walletServerOuts)
import           Pos.Web (serveWeb)
import           Pos.WorkMode (WorkMode)
import           Pos.Worker.Types (worker, WorkerSpec)

-- A @Plugin@ running in the monad @m@.
type Plugin m = ([WorkerSpec m], OutSpecs)

-- | A @Plugin@ to periodically compact & snapshot the acid-state database.
acidCleanupWorker :: HasConfigurations
                  => WalletBackendParams
                  -> Plugin WalletWebMode
acidCleanupWorker WalletBackendParams{..} =
    first one $ worker mempty $ const $
    modifyLoggerName (const "acidcleanup") $
    cleanupAcidStatePeriodically (walletAcidInterval walletDbOptions)

-- | The @Plugin@ which defines part of the conversation protocol for this node.
conversation :: (HasConfigurations, HasCompileInfo) => WalletBackendParams -> Plugin WalletWebMode
conversation wArgs = (, mempty) $ map (\act -> ActionSpec $ \__diffusion -> act) (pluginsMonitoringApi wArgs)
  where
    pluginsMonitoringApi :: (WorkMode ctx m , HasNodeContext ctx , HasConfigurations, HasCompileInfo)
                         => WalletBackendParams
                         -> [m ()]
    pluginsMonitoringApi WalletBackendParams {..}
        | enableMonitoringApi = [serveWeb monitoringApiPort walletTLSParams]
        | otherwise = []

-- | A @Plugin@ to start the wallet backend API.
walletBackend :: (HasConfigurations, HasCompileInfo)
              => WalletBackendParams
              -> Plugin WalletWebMode
walletBackend WalletBackendParams {..} =
    first one $ worker walletServerOuts $ \diffusion -> do
      logInfo $ sformat ("Production mode for API: "%build)
        walletProductionApi
      logInfo $ sformat ("Transaction submission disabled: "%build)
        walletTxCreationDisabled

      walletServeImpl
        (getApplication diffusion)
        walletAddress
        -- Disable TLS if in debug mode.
        (if (isDebugMode walletRunMode) then Nothing else walletTLSParams)
  where
    -- Gets the Wai `Application` to run.
    getApplication :: Diffusion WalletWebMode -> WalletWebMode Application
    getApplication diffusion = do
      logInfo "Wallet Web API has STARTED!"
      wsConn <- getWalletWebSockets
      ctx <- V0.walletWebModeContext
      let app = upgradeApplicationWS wsConn $ serve API.walletAPI (API.walletServer (V0.convertHandler ctx) diffusion)
      return $ withMiddleware walletRunMode app

-- | A @Plugin@ to resubmit pending transactions.
resubmitterPlugin :: (HasConfigurations, HasCompileInfo) => Plugin WalletWebMode
resubmitterPlugin = ([ActionSpec $ \diffusion -> startPendingTxsResubmitter (sendTx diffusion)], mempty)

-- | A @Plugin@ to notify frontend via websockets.
notifierPlugin :: (HasConfigurations, HasCompileInfo) => Plugin WalletWebMode
notifierPlugin = ([ActionSpec $ \_ -> V0.notifierPlugin], mempty)

-- | "Attaches" the middleware to this 'Application', if any.
-- When running in debug mode, chances are we want to at least allow CORS to test the API
-- with a Swagger editor, locally.
withMiddleware :: RunMode -> Application -> Application
withMiddleware wrm app
  | isDebugMode wrm = logStdoutDev . corsMiddleware $ app
  | otherwise = app

corsMiddleware :: Middleware
corsMiddleware = cors (const $ Just policy)
    where
      policy = simpleCorsResourcePolicy
        { corsRequestHeaders = ["Content-Type"]
        , corsMethods = "PUT" : simpleMethods
        }
