module Cryptokami.Wallet.API.V1.Settings where

import           Cryptokami.Wallet.API.Response (ValidJSON, WalletResponse)
import           Cryptokami.Wallet.API.V1.Types

import           Servant

type API =
         "node-settings" :> Summary "Retrieves the static settings for this node."
                         :> Get '[ValidJSON] (WalletResponse NodeSettings)
