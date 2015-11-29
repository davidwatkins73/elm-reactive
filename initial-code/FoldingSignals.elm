import Graphics.Element exposing (..)
import Keyboard
import Mouse
import Window

-- MODEL

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


type alias State = 
  { bottomLeft : Int
  , bottomRight : Int
  , topRight : Int
  , topLeft : Int
  }


initialState : State
initialState = { topLeft = 0, topRight = 0,  bottomLeft = 0, bottomRight = 0 }


update : Corner -> State -> State
update corner state =
  case corner of 
    TOP_LEFT -> { state | topLeft = state.topLeft + 1 }
    TOP_RIGHT -> { state | topRight = state.topRight + 1 }
    BOTTOM_LEFT -> { state | bottomLeft = state.bottomLeft + 1 }
    BOTTOM_RIGHT -> { state | bottomRight = state.bottomRight + 1 }
  

toCorner : VerticalHalf -> HorizontalHalf-> Corner
toCorner v h =
  case (v, h) of
    (TOP, LEFT) -> TOP_LEFT
    (TOP, RIGHT) -> TOP_RIGHT
    (BOTTOM, LEFT) -> BOTTOM_LEFT
    (BOTTOM, RIGHT) -> BOTTOM_RIGHT


determineCorner : (Int, Int) -> (Int, Int) -> Corner
determineCorner (w, h) (x, y) =
  let 
    vHalf = if (y > h // 2) then BOTTOM else TOP
    hHalf = if (x > w // 2) then RIGHT else LEFT
  in 
    toCorner vHalf hHalf


-- REACTIVE 

cornerClicks : Signal Corner
cornerClicks =
  let 
    cornerStream = Signal.map2 determineCorner Window.dimensions Mouse.position
  in 
    Signal.sampleOn Mouse.clicks cornerStream
  


cornerClickCount: Signal State
cornerClickCount = Signal.foldp update initialState cornerClicks


main : Signal Element
main =
  Signal.map show cornerClickCount
