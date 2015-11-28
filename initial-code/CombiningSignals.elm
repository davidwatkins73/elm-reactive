import Graphics.Element exposing (..)
import Mouse
import Window


view : (Int, Int) -> (Int, Int) -> Element
view (w,h) (x, y) =
  let 
    vert = if (y > h // 2) then "Bottom" else "Top"
    horiz = if (x > w // 2) then "Right" else "Left" 
    side = vert ++ " " ++ horiz
  in 
    show side
    

main : Signal Element
main =
  Signal.map2 view Window.dimensions Mouse.position

