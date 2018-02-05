{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase    #-}
module Cryptokami.Wallet.API.Request (
    RequestParams (..)
  -- * Handly re-exports
  , module Cryptokami.Wallet.API.Request.Pagination
  , module Cryptokami.Wallet.API.Request.Filter
  , module Cryptokami.Wallet.API.Request.Sort
  ) where

import           Cryptokami.Wallet.API.Request.Filter
import           Cryptokami.Wallet.API.Request.Pagination (PaginationMetadata (..), PaginationParams)
import           Cryptokami.Wallet.API.Request.Sort

data RequestParams = RequestParams
    { rpPaginationParams :: PaginationParams
    -- ^ The pagination-related parameters
    }
