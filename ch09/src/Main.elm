module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)



-- Main
main : Program () Model Msg
main = sandbox
  { init = { text = "" }
  , view = view
  , update = update
  }


-- Model
type Msg
  = UpdateText String

type alias Model =
  { text : String }


-- Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateText newText ->
      { model | text = newText }


-- View
view : Model -> Html Msg
view model =
  div
    [ class "text-center" ]
    [ input [ onInput UpdateText, value model.text ] []
    , div [] [ text model.text ]
    ]
