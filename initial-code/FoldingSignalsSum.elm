import Graphics.Element exposing (..)
import Keyboard
import Mouse
import Window
import Time
import String
import Char


parseInt : Char -> Maybe Int
parseInt character =
  case String.toInt (String.fromChar character) of
    Ok value ->
      Just value
    Err error ->
      Nothing


characters : Signal Char
characters =
  Signal.map Char.fromCode Keyboard.presses


integers : Signal Int
integers =
  Signal.filterMap parseInt 0 characters

  
summing : Signal Int
summing =
  Signal.foldp (+) 0 integers


charactersSoFar : Signal (List Char)
charactersSoFar =
  Signal.foldp (::) [] characters
  
  
showBoth : Int -> List Char -> Element
showBoth sum chars = 
  show ((toString sum) ++ " " ++ String.fromList(chars)) 
   

main : Signal Element
main =
  Signal.map2 showBoth summing charactersSoFar
