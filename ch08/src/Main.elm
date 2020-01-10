module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


-- Main
main : Program () Model Msg
main = sandbox
  {
    init = [0, 0],
    view = view,
    update = update
  }


-- Model
type Msg
  = Increment Int
  | Decrement Int
  | Remove Int
  | AddCount

type alias Model = List Int


-- View
view : Model -> Html Msg
view model = 
  div
    [class "text-center"]
    [
      div
        [class "mb-2"]
        [
          button
            [class "btn btn-primary", onClick AddCount]
            [text "Add Count"]
        ],
      div [] (List.indexedMap viewCount model)
    ]


-- Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment index ->
      List.indexedMap
        (
          \i count ->
            if i == index then
              count + 1
            else
              count
        )
        model

    Decrement index ->
      List.indexedMap
        (
          \i count ->
            if i == index then
              count - 1
            else
              count
         )
         model

    Remove index ->
      let
        before = List.take index model
        after = List.drop (index + 1) model
      in
        before ++ after

    AddCount ->
      model ++ [0]


-- Functions
viewCount : Int -> Int -> Html Msg
viewCount index count =
  div
    [class "mb-2"]
    [
      text (String.fromInt count),
      button
        [class "btn btn-primary ml-2", onClick (Increment index)]
        [text "+"],
      button
        [class "btn btn-primary ml-2", onClick (Decrement index)]
        [text "-"],
      button
        [class "btn btn-primary ml-2", onClick (Remove index)]
        [text "X"]
    ]
