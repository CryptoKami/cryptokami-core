module Cryptokami.Wallet.API.V1.Info where

import           Cryptokami.Wallet.API.V1.Types

import           Servant

type API =
         "node-info" :> Summary "Retrieves the dynamic information for this node."
                     :> Get '[JSON] NodeInfo
