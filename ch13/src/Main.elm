module Main exposing (main)

import Browser exposing (element)
import Html exposing (..)
import Html.Attributes exposing (autofocus, class, placeholder, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)


-- Main
main : Program () Model Msg
main = element
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
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


-- Init
init : () -> ( Model, Cmd Msg )
init _ =
  ( { text = ""
    , todos = ["ABC", "DEF"]
    , editing = Nothing
    }
  , Cmd.none
  )


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- Update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateText new Text ->
      ( { model | text = newText }, Cmd.none )

    AddTodo ->
      ( { model | text = "", todos = model.todos ++ [ model.text ] }
      , Cmd.none
      )

    RemoveTodo index ->
      let
        beforeTodos =
          List.take index model.todos
        afterTodos =
          List.drop (index + 1) model.todos
        newTodos =
          beforeTodos ++ afterTodos
      in
      ( { model | editing = Just { index = index, text = todoText } }
      , Cmd.none
      )

    Edit index todoText ->
      ( { model | editing = Just { index = index, text = todoText } }
      , Cmd.none
      )

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
      ( { model | editing = Nothing, todos = newTodos }
      , Cmd.none
      )


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
            [ button
                [ clas "btn btn-primary form-control" ]
                [ text "+" ]
            ]
        ]
    , div [] (List.indexedMap (viewTodo model.editing) model.todos)
    ]

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

viewEditTodo : Int -> TodoEdit -> Html Msg
viewEditTodo index todoEdit =
  div [ class "card" ]
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

viewNormalTodo : Int -> String -> Html Msg
viewNormalTodo index todo =
  div [ class "card" ]
    [ div [ class "card-block" ]
        [ span
            [ onDoubleClick (Edit index todo) ]
            [ text todo ]
        , span
            [ onClick (RemoveTodo index)
            , class "float-right"
            ]
            [ text "x" ]
        ] 
    ]
