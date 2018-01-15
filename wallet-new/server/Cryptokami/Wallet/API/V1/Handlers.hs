{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PolyKinds             #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE TypeFamilies          #-}
module Cryptokami.Wallet.API.V1.Handlers where

import           Universum


import qualified Cryptokami.Wallet.API.V1 as V1
import qualified Cryptokami.Wallet.API.V1.Handlers.Addresses as Addresses
import qualified Cryptokami.Wallet.API.V1.Handlers.Info as Info
import qualified Cryptokami.Wallet.API.V1.Handlers.Settings as Settings
import qualified Cryptokami.Wallet.API.V1.Handlers.Transactions as Transactions
import qualified Cryptokami.Wallet.API.V1.Handlers.Updates as Updates
import qualified Cryptokami.Wallet.API.V1.Handlers.Wallets as Wallets
import qualified Cryptokami.Wallet.API.V1.Info as Info
import qualified Cryptokami.Wallet.API.V1.Settings as Settings
import qualified Cryptokami.Wallet.API.V1.Wallets as Wallets

import           Cryptokami.Wallet.API.V1.Migration

import           Servant

-- | Until we depend from V0 logic to implement the each 'Handler' we
-- still need the natural transformation here.
handlers :: ( HasConfigurations
            , HasCompileInfo
            )
            => (forall a. MonadV1 a -> Handler a)
            -> Server V1.API
handlers naturalTransformation = Addresses.handlers
                            :<|> hoistServer (Proxy @Wallets.API) naturalTransformation Wallets.handlers
                            :<|> Transactions.handlers
                            :<|> Updates.handlers
                            :<|> hoistServer (Proxy @Settings.API) naturalTransformation Settings.handlers
                            :<|> hoistServer (Proxy @Info.API) naturalTransformation Info.handlers
