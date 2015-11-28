import Graphics.Element exposing (..)
import Mouse
import Window
import Keyboard
import Time

main =
  Signal.map show Mouse.position
--  Signal.map show (Time.every Time.second)
--  Signal.map show Keyboard.arrows
--  Signal.map show Window.dimensions
--  Signal.map show Keyboard.enter
--  Signal.map show (Keyboard.isDown 32)

