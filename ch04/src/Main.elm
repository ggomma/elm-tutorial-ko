module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


-- Main
main = sandbox
  {
    init = 0,
    view = view,
    update = update
  }


-- Model
type Msg = Increment

type alias Model = Int


-- View
view : Model -> Html Msg
view model =
  div [class "text-center"]
    [
      div [] [ text (String.fromInt model)],
      button
        [class "btn btn-primary", onClick Increment]
        [text "+"]
    ]


-- Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1
