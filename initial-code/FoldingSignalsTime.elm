import Graphics.Element exposing (..)
import Keyboard
import Mouse
import Window
import Time

ticks : Signal Int
ticks = Signal.foldp (\_ acc -> acc + 1 ) 0 (Time.every 1000)

main : Signal Element
main =
  Signal.map show ticks
