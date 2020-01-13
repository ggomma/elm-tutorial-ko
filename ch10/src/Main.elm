module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (autofocus, class, value)
import Html.Events exposing (onClick, onInput)


-- Main
main : Program () Model Msg
main = sandbox
  { init = { text = "", todos = [] }
  , view = view
  , update = update
  }


-- Model
type Msg
  = UpdateText String
  | AddTodo

type alias Model =
  { text: String
  , todos : List String
  }


-- Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateText newText ->
      { model | text = newText }
    AddTodo ->
      { model | text = "", todos = model.todos ++ [model.text] }


-- View
view : Model -> Html Msg
view model =
  div
    [ class "text-center" ]
    [ input [ onInput UpdateText, value model.text, autofocus True ] []
    , button [ onClick AddTodo, class "btn btn-primary" ] [ text "Add Todo" ]
    , div [] (List.map (\todo -> div [] [ text todo ]) model.todos)
    ]
