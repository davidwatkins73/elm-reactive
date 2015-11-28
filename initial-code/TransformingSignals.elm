import Graphics.Element exposing (..)
import Mouse
import Window
import Keyboard
import Char


chars : Signal Char
chars = 
  Signal.map Char.fromCode Keyboard.presses


isDigit : Signal Bool
isDigit =
  Signal.map Char.isDigit chars
 
 
main : Signal Element
main =
  Signal.map show isDigit
