module Entries.File where

import App.File (app)
import Control.Monad.Eff (Eff())
import Data.Tuple (Tuple(..))
import Driver.File (outside)
import Driver.ZClipboard (initZClipboard)
import EffectTypes (FileAppEff())
import Halogen (runUIWith)
import Utils (onLoad, mountUI)

main :: Eff (FileAppEff ()) Unit
main = onLoad $ void $ do
  Tuple node driver <- runUIWith app postRender
  mountUI node
  outside driver
  where
  postRender _ node _ = initZClipboard node
