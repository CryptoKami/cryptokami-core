module Cryptokami.Wallet.API.V1.Handlers.Settings where

import           Universum

import           Cryptokami.Wallet.API.V1.Migration
import qualified Cryptokami.Wallet.API.V1.Settings as Settings
import           Cryptokami.Wallet.API.V1.Types as V1
import qualified Data.Text as T
import           Paths_cryptokami_sl_wallet_new (version)

import           Pos.Update.Configuration (curSoftwareVersion)
import           Pos.Util.CompileInfo (compileInfo, ctiGitRevision)
import           Pos.Wallet.WalletMode (MonadBlockchainInfo, blockchainSlotDuration)
import           Servant

-- | All the @Servant@ handlers for settings-specific operations.
handlers :: ( HasConfigurations
            , HasCompileInfo
            )
         => ServerT Settings.API MonadV1
handlers = getSettings

-- Returns the @static@ settings for this wallet node,
-- like the slot duration or the current 'SoftwareVersion'.
getSettings :: (HasConfigurations, HasCompileInfo, MonadBlockchainInfo m)
            => m NodeSettings
getSettings = NodeSettings <$> (V1.mkSlotDuration . fromIntegral <$> blockchainSlotDuration)
                           <*> pure curSoftwareVersion
                           <*> pure version
                           <*> pure (T.replace "\n" mempty $ ctiGitRevision compileInfo)
