{- | This is a temporary module to help migration @V0@ datatypes into @V1@ datatypes.
-}
module Cryptokami.Wallet.API.V1.Migration (
      module Exports
    -- * Configuration re-exports
    , HasCompileInfo
    , HasConfigurations
    , HasConfiguration
    , HasSscConfiguration
    , HasUpdateConfiguration
    , HasNodeConfiguration
    ) where

import           Cryptokami.Wallet.API.V1.Migration.Monads as Exports
import           Cryptokami.Wallet.API.V1.Migration.Types as Exports

import           Pos.Configuration (HasNodeConfiguration)
import           Pos.Core.Configuration (HasConfiguration)
import           Pos.Launcher.Configuration (HasConfigurations)
import           Pos.Ssc (HasSscConfiguration)
import           Pos.Update.Configuration (HasUpdateConfiguration)
import           Pos.Util.CompileInfo (HasCompileInfo)
