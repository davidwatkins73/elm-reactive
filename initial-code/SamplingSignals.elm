import Graphics.Element exposing (..)
import Mouse
import Time
import Window


type VerticalHalf
  = TOP 
  | BOTTOM

  
type HorizontalHalf
  = LEFT
  | RIGHT

  
type Corner 
  = TOP_LEFT
  | TOP_RIGHT
  | BOTTOM_LEFT
  | BOTTOM_RIGHT
  

toCorner : VerticalHalf -> HorizontalHalf-> Corner
toCorner v h =
  case (v, h) of
    (TOP, LEFT) -> TOP_LEFT
    (TOP, RIGHT) -> TOP_RIGHT
    (BOTTOM, LEFT) -> BOTTOM_LEFT
    (BOTTOM, RIGHT) -> BOTTOM_RIGHT


view : (Int, Int) -> (Int, Int) -> Element
view (w, h) (x, y) =
  let 
    vHalf = if (y > h // 2) then BOTTOM else TOP
    hHalf = if (x > w // 2) then RIGHT else LEFT 
    corner = toCorner vHalf hHalf
  in 
    show corner
    
    
clicks : Signal (Int, Int)
clicks =
  Signal.sampleOn Mouse.clicks Mouse.position


main : Signal Element
main =
  Signal.map2 view Window.dimensions clicks

