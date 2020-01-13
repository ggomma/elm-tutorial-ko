module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (Html, button, div, form, input, span, text)
import Html.Attributes exposing (autofocus, class, placeholder, value)
import Html.Events exposing (onClick, onInput, onSubmit)


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
  | RemoveTodo Int

type alias Model =
  { text : String
  , todos : List String
  }


-- Update
update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateText newText ->
      { model | text = newText }
    AddTodo ->
      { model | text = "", todos = model.todos ++ [ model.text ] }
    RemoveTodo index ->
      let
        beforeTodos =
          List.take index model.todos
        afterTodos =
          List.drop (index + 1) model.todos
        newTodos =
          beforeTodos ++ afterTodos
      in
      { model | todos = newTodos }


-- View
view : Model -> Html Msg
view model =
  div [ class "col-12 col-sm-6 offset-sm-3" ]
    [ form [ class "row", onSubmit AddTodo ]
        [ div [ class "col-9" ]
            [ input
                [ onInput UpdateText
                , value model.text
                , autofocus True
                , class "form-control"
                , placeholder "Enter a todo"
                ]
                []
            ]
        , div [ class "col-3" ]
            [ button [ class "btn btn-primary form-control"]
                [ text "+" ]
            ]
        ]
    , div [] (List.indexedMap viewTodo model.todos)
    ]


-- Functions
viewTodo : Int -> String -> Html Msg
viewTodo index todo =
  div [ class "cart" ]
    [ div [ class "card-block" ]
        [ text todo
        , button [ onClick (RemoveTodo index), class "float-right" ]
            [ text "X" ]
        ]
    ]