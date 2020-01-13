module Main exposing (main)

import Browser exposing (sandbox)
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, placeholder, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)


-- Main
main : Program () Model Msg
main = sandbox
  { init =
      { text = ""
      , todos = ["ABC", "DEF"]
      , editing = Nothing
      }
  , view = view
  , update = update
  }


-- Model
type Msg
  = UpdateText String
  | AddTodo
  | RemoveTodo Int
  | Edit Int String
  | EditSave Int String

type alias TodoEdit =
  { index : Int
  , text : String
  }

type alias Model =
  { text : String
  , todos : List String
  , editing : Maybe TodoEdit
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

    Edit index todoText ->
      { model | editing = Just { index = index, text = todoText } }

    EditSave index todoText ->
      let
        newTodos =
          List.indexedMap
            (\i todo ->
              if i == index then
                todoText
              else
                todo
            )
            model.todos
      in
      { model | editing = Nothing, todos = newTodos }


-- View
view : Model -> Html Msg
view model =
  div [ class "col-12 col-sm-6 offset-sm-3" ]
    [ form [ class "row", onSubmit AddTodo ]
        [ div [ class "col-9"]
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
            [ button [class "btn btn-primary form-control"]
                [ text "+" ]
            ]
        ]
    , div [] (List.indexedMap (viewTodo model.editing) model.todos)
    ]


-- Functions
viewTodo : Maybe TodoEdit -> Int -> String -> Html Msg
viewTodo editing index todo =
  case editing of
    Just todoEdit ->
      if todoEdit.index == index then
        viewEditTodo index todoEdit
      else
        viewNormalTodo index todo
    Nothing ->
      viewNormalTodo index todo

viewNormalTodo : Int -> String -> Html Msg
viewNormalTodo index todo =
  div [ class "card" ]
    [ div [ class "card-block" ]
        [ span [ onDoubleClick (Edit index todo) ]
            [ text todo ]
        , span
            [ onClick (RemoveTodo index)
            , class "float-right"
            ]
            [ text "x" ]
        ]
    ]

viewEditTodo : Int -> TodoEdit -> Html Msg
viewEditTodo index todoEdit =
  div [ clas "card" ]
    [ div [ class "card-block" ]
        [ form [ onSubmit (EditSave todoEdit.index todoEdit.text) ]
            [ input
                [ onInput (Edit index)
                , class "form-control"
                , value todoEdit.text
                ]
                []
            ]
        ]
    ]

