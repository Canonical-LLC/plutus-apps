{-# LANGUAGE Rank2Types #-}
module Wallet.Emulator.Generators(
      runTrace
    , runTraceOn
    ) where

import           Hedgehog

import           Control.Monad.Freer
import           Ledger.Generators   (GeneratorModel, Mockchain (Mockchain), genMockchain')
import           Wallet.Emulator     as Emulator


-- | Run an emulator trace on a mockchain.
runTrace ::
    Mockchain
    -> Eff EmulatorEffs a
    -> (Either AssertionError a, EmulatorState)
runTrace (Mockchain ch _) = Emulator.runTraceTxPool ch

-- | Run an emulator trace on a mockchain generated by the model.
runTraceOn :: MonadGen m
    => GeneratorModel
    -> Eff EmulatorEffs a
    -> m (Either AssertionError a, EmulatorState)
runTraceOn gm t = flip runTrace t <$> genMockchain' gm