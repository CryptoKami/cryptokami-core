module Pos.System.Metrics.Constants (
      cryptokamiNamespace
    , withCryptokamiNamespace
                                        ) where

import           Universum

cryptokamiNamespace :: Text
cryptokamiNamespace = "cryptokami"

withCryptokamiNamespace :: Text -> Text
withCryptokamiNamespace label = cryptokamiNamespace <> "." <> label
