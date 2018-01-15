module Cryptokami.Wallet.API.V1.Handlers.Transactions where

import           Universum

import qualified Cryptokami.Wallet.API.V1.Transactions as Transactions
import           Cryptokami.Wallet.API.V1.Types

import           Servant
import           Test.QuickCheck (arbitrary, generate)

handlers :: Server Transactions.API
handlers =   newTransaction
        :<|> allTransactions
        :<|> estimateFees

newTransaction :: Payment -> Handler Transaction
newTransaction _ = liftIO $ generate arbitrary

allTransactions :: PaginationParams -> Handler (OneOf [Transaction] (ExtendedResponse [Transaction]))
allTransactions _ = liftIO $ generate arbitrary

estimateFees :: Payment -> Handler EstimatedFees
estimateFees _ = liftIO $ generate arbitrary
