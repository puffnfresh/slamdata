module Input.File.Rename
  ( RenameInput(..)
  , inputRename
  ) where

import Data.Array (sort, nub, sortBy)
import Data.String (length)
import Model.File.Dialog (Dialog(RenameDialog))
import Model.File.Dialog.Rename
import Model.Resource
import Optic.Core

data RenameInput
  = SetDir Resource
  | AddDirs [Resource]
  | Update (RenameDialogRec -> RenameDialogRec)

inputRename :: RenameInput -> Dialog -> Dialog
inputRename input (RenameDialog d) = RenameDialog $ case input of
  SetDir toSelect -> d # _dir .~ toSelect
                       # _showList .~ false
  AddDirs newDirs -> d # _dirs %~ \oldDirs -> sort $ nub $ (oldDirs <> newDirs)
  Update f -> f d

inputRename _ dialog = dialog
