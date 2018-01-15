module Cryptokami.Wallet.API.V1 where


import           Servant ((:<|>), (:>))

import           Cryptokami.Wallet.API.Types
import qualified Cryptokami.Wallet.API.V1.Addresses as Addresses
import qualified Cryptokami.Wallet.API.V1.Info as Info
import qualified Cryptokami.Wallet.API.V1.Settings as Settings
import qualified Cryptokami.Wallet.API.V1.Transactions as Transactions
import qualified Cryptokami.Wallet.API.V1.Updates as Updates
import qualified Cryptokami.Wallet.API.V1.Wallets as Wallets

type API =  Tags '["Addresses"]    :> Addresses.API
       :<|> Tags '["Wallets"]      :> Wallets.API
       :<|> Tags '["Transactions"] :> Transactions.API
       :<|> Tags '["Updates"]      :> Updates.API
       :<|> Tags '["Settings"]     :> Settings.API
       :<|> Tags '["Info"]         :> Info.API
