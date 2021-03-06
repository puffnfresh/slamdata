module Utils.KeyCombo
  ( KeyCombo()
  , meta
  , alt
  , shift
  , letter
  , combo
  ) where

import Data.Array (nub, sort, snoc)
import Data.Char (Char(), fromCharCode)
import Data.Foldable (foldl)
import Data.String (fromChar, joinWith)

data KeyCombo
  = Meta
  | Alt
  | Shift
  | Letter Char
  | Combo [KeyCombo]

meta :: KeyCombo
meta = Meta

alt :: KeyCombo
alt = Alt

shift :: KeyCombo
shift = Shift

letter :: Char -> KeyCombo
letter = Letter

combo :: [KeyCombo] -> KeyCombo
combo ks = Combo $ sort $ nub $ foldl snoc [] ks

instance eqKeyCombo :: Eq KeyCombo where
  (==) Meta Meta = true
  (==) Alt Alt = true
  (==) Shift Shift = true
  (==) (Letter x) (Letter y) = x == y
  (==) (Combo xs) (Combo ys) = xs == ys
  (==) _ _ = false
  (/=) x y = not (x == y)

instance ordKeyCombo :: Ord KeyCombo where
  compare Meta Meta = EQ
  compare Meta _ = LT
  compare Alt Alt = EQ
  compare Alt _ = EQ
  compare Shift Shift = EQ
  compare Shift _ = LT
  compare (Letter x) (Letter y) = compare x y
  compare (Letter _) _ = LT
  compare (Combo xs) (Combo ys) = compare xs ys

instance showKeyCombo :: Show KeyCombo where
  show Meta = "Meta"
  show Alt = "Alt"
  show Shift = "Shift"
  show (Letter l) = "Letter (" ++ show l ++ ")"
  show (Combo ks) = "Combo " ++ show ks

instance semigroupKeyCombo :: Semigroup KeyCombo where
  (<>) (Combo xs) (Combo ys) = Combo $ sort $ nub $ xs ++ ys
  (<>) (Combo xs) y = Combo $ sort $ nub $ xs ++ [y]
  (<>) x (Combo ys) = Combo $ sort $ nub $ [x] ++ ys
  (<>) x y | x == y = x
           | otherwise = Combo $ sort [x, y]

printKeyComboWin :: KeyCombo -> String
printKeyComboWin Meta = "Ctrl"
printKeyComboWin Alt = "Alt"
printKeyComboWin Shift = "Shift"
printKeyComboWin (Letter c) = fromChar c
printKeyComboWin (Combo ks) = joinWith "+" (printKeyComboWin <$> ks)

printKeyComboLinux :: KeyCombo -> String
printKeyComboLinux = printKeyComboWin

printKeyComboMac :: KeyCombo -> String
printKeyComboMac Meta = fromChar $ fromCharCode 8984
printKeyComboMac Alt = fromChar $ fromCharCode 8997
printKeyComboMac Shift = fromChar $ fromCharCode 8679
printKeyComboMac (Letter c) = fromChar c
printKeyComboMac (Combo ks) = joinWith "" (printKeyComboMac <$> ks)
