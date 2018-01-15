{-# LANGUAGE ExistentialQuantification #-}

-- | Exceptions hierarchy in cryptokami-sl.

module Pos.Exception
       ( CryptokamiException (..)
       , cryptokamiExceptionToException
       , cryptokamiExceptionFromException

       , CryptokamiFatalError (..)
       , reportFatalError
       , assertionFailed
       ) where

import           Control.Exception.Safe (Exception (..))
import qualified Data.Text.Buildable
import           Data.Typeable (cast)
import           Formatting (bprint, stext, (%))
import           Serokell.Util (Color (Red), colorize)
import           System.Wlog (WithLogger, logError)
import qualified Text.Show
import           Universum

-- | Root of exceptions in cryptokami-sl.
data CryptokamiException =
    forall e. (Buildable e, Exception e) =>
              CryptokamiException e
    deriving (Typeable)

instance Show CryptokamiException where
    show (CryptokamiException e) = toString . pretty $ e

instance Exception CryptokamiException

instance Buildable CryptokamiException where
    build (CryptokamiException e) = Data.Text.Buildable.build e

-- | Helper to define sub-exception of CryptokamiException.
cryptokamiExceptionToException :: (Buildable e, Exception e) => e -> SomeException
cryptokamiExceptionToException = toException . CryptokamiException

-- | Helper to define sub-exception of CryptokamiException.
cryptokamiExceptionFromException :: Exception e => SomeException -> Maybe e
cryptokamiExceptionFromException x = do
    CryptokamiException a <- fromException x
    cast a


-- | Error indicating that something really bad happened. Should be
-- used when serious assertions fail (local equivalent of
-- 'panic'). 'panic' is still alright to use, but preferably in pure
-- environment.
data CryptokamiFatalError =
    CryptokamiFatalError !Text
    deriving (Typeable, Show)

instance Buildable CryptokamiFatalError where
    build (CryptokamiFatalError msg) =
        bprint ("Cryptokami fatal error: "%stext) msg

instance Exception CryptokamiFatalError where
    toException = cryptokamiExceptionToException
    fromException = cryptokamiExceptionFromException
    displayException = toString . pretty

-- | Print red message about fatal error and throw exception.
reportFatalError
    :: (WithLogger m, MonadThrow m)
    => Text -> m a
reportFatalError msg = do
    logError $ colorize Red msg
    throwM $ CryptokamiFatalError msg

-- | Report 'CryptokamiFatalError' for failed assertions.
assertionFailed :: (WithLogger m, MonadThrow m) => Text -> m a
assertionFailed msg =
    reportFatalError $ "assertion failed: " <> msg
