module Spaceship where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)
import Color exposing (..)

import Keyboard
import Window
import Time


-- MODEL

type Action 
  = NoOp 
  | Left 
  | Right 
  | Fire Bool
  | Tick


type alias Model =
  { position: Int,
    powerLevel: Int,
    isFiring: Bool
  }


initialShip : Model
initialShip =
  { position = 0,
    powerLevel = 10,
    isFiring = False
  }


-- UPDATE

update : Action -> Model -> Model
update action model = 
  case action of
    NoOp -> 
      model 
    Left -> 
      { model | position = model.position - 1 }
    Right -> 
      { model | position = model.position + 1 }
    Fire firing ->
      let
        newPowerLevel = 
          if (firing) 
            then 
              if model.powerLevel > 0 
                then model.powerLevel - 1 
                else model.powerLevel
            else 
              model.powerLevel
      in
        { model 
        | isFiring = firing
        , powerLevel = newPowerLevel
        }
    Tick ->
      let 
        newPowerLevel = 
          if (model.powerLevel < 10) 
            then model.powerLevel + 1 
            else 10
      in
        { model | powerLevel = newPowerLevel }


-- VIEW

view : (Int, Int) -> Model -> Element
view (w, h) ship =
  let
    (w', h') = (toFloat w, toFloat h)
  in
    collage w h
      [ drawGame w' h',
        drawShip h' ship,
        toForm (show ship)
      ]


drawGame : Float -> Float -> Form
drawGame w h =
  rect w h
    |> filled gray


drawShip : Float -> Model -> Form
drawShip gameHeight ship =
  let
    shipColor =
      if ship.isFiring then red else blue
  in
    ngon 5 30
      |> filled shipColor
      |> rotate (degrees 90)
      |> move ((toFloat ship.position), (50 - gameHeight / 2))
      |> alpha ((toFloat ship.powerLevel) / 10)


-- SIGNALS 

fire : Signal Action
fire = 
  let 
    firing = Signal.map Fire Keyboard.space
    fps = Time.fps 30
  in 
    Signal.sampleOn fps firing


ticks : Signal Action
ticks = Signal.sampleOn (Time.every 400) (Signal.constant Tick)


direction : Signal Action
direction =  
  let 
    keys = Signal.sampleOn (Time.fps 60) Keyboard.arrows
    toAction d = 
      case d.x of
        1  -> Right
        (-1) -> Left
        _  -> NoOp
  in 
    Signal.map toAction keys


actions : Signal Action
actions = Signal.mergeMany [ direction, fire, ticks ]


model : Signal Model
model = Signal.foldp update initialShip actions


main : Signal Element
main =
  Signal.map2 view Window.dimensions model
