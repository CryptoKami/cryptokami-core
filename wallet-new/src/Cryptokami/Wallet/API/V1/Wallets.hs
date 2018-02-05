module Cryptokami.Wallet.API.V1.Wallets where

import           Cryptokami.Wallet.API.Request
import           Cryptokami.Wallet.API.Response
import           Cryptokami.Wallet.API.Types
import qualified Cryptokami.Wallet.API.V1.Accounts as Accounts
import           Cryptokami.Wallet.API.V1.Parameters
import           Cryptokami.Wallet.API.V1.Types

import           Servant

type API =
         "wallets" :> Summary "Creates a new Wallet."
                   :> ReqBody '[ValidJSON] (New Wallet)
                   :> PostCreated '[ValidJSON] (WalletResponse Wallet)
    :<|> "wallets" :> Summary "Returns all the available wallets."
                   :> WalletRequestParams
                   :> FilterBy '["wallet_id", "balance"] Wallet
                   :> SortBy   '["balance"] Wallet
                   :> Get '[ValidJSON] (WalletResponse [Wallet])
    :<|> "wallets" :> Capture "walletId" WalletId
                   :> ( "password" :> Summary "Updates the password for the given Wallet."
                                   :> ReqBody '[ValidJSON] PasswordUpdate
                                   :> Put '[ValidJSON] (WalletResponse Wallet)
                   :<|> Summary "Deletes the given Wallet and all its accounts."
                        :> DeleteNoContent '[ValidJSON] NoContent
                   :<|> Summary "Returns the Wallet identified by the given walletId."
                        :> Get '[ValidJSON] (WalletResponse Wallet)
                   :<|> Summary "Update the Wallet identified by the given walletId."
                        :> ReqBody '[ValidJSON] (Update Wallet)
                        :> Put '[ValidJSON] (WalletResponse Wallet)
                   -- Nest the Accounts API
                   :<|> Tags '["Accounts"] :> Accounts.API
                   )
