port module Main exposing (main)

import Browser exposing (Document, UrlRequest, application)
import Browser.Navigation exposing (Key)
import Html exposing (..)
import Html.Attributes exposing (autofocus, checked, class, href, placeholder, style, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Random
import Url exposing (Url)


-- Main
main : Program Flags Model Msg
main = application
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  , onUrlRequest = LinkClicked
  , onUrlChange = ChangeUrl
  }


-- Model
type Msg
  = UpdateText String
  | GenerateTodoId
  | AddTodo Int
  | RemoveTodo Int
  | Edit Int String
  | EditSave Int String
  | ToggleTodo Int
  | SetFilter Filter
  | LinkClicked UrlRequest
  | ChangeUrl Url

type alias TodoEdit =
  { id : Int
  , text : String
  }

type alias Todo =
  { id : Int
  , text : String
  , completed : Bool
  }
  
type alias Flags =
  { todos : List Todo }

type Filter
  = All
  | Incomplete
  | Completed

type alias Model =
  { text : String
  , todos : List Todo
  , editing : Maybe TodoEdit
  , filter : Filter
  , navigationKey : Key
  }


-- Init
init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url navigationKey =
  ( { text = ""
    , todos = flags.todos
    , editing = Nothing
    , filter = urlToFilter url
    , navigationKey = navigationKey
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
    UpdateText newText ->
      ( { model | text = newText }, Cmd.none )

    GenerateTodoId ->
      ( model
      , Random.generate AddTodo (Random.int Random.minInt Random.maxInt)
      )

    AddTodo todoId ->
      let
        newTodos =
          model.todos ++ [ Todo todoId model.text False ]
      in
      ( { model | text = "", todos = newTodos }
      , saveTodos newTodos
      )

    RemoveTodo todoId ->
      let
        newTodos =
          List.filter (\todo -> todo.id /= todoId) model.todos
      in
      ( { model | todos = newTodos }
      , saveTodos newTodos
      )

    Edit todoId todoText ->
      ( { model | editing = Just { id = todoId, text = todoText } }
      , Cmd.none
      )

    EditSave todoId todoText ->
      let
        newTodos =
          List.map
            (\todo ->
                if todo.id == todoId then
                  { todo | text = todoText }
                else
                  todo
            )
            model.todos
      in
      ( { model | editing = Nothing, todos = newTodos }
      , saveTodos newTodos
      )
    
    ToggleTodo todoId ->
      let
        newTodos =
          List.map
            (\todo ->
                if todo.id == todoId then
                  { todo | completed = not todo.completed }
                else
                  todo
            )
            model.todos
      in
      ( { model | todos = newTodos }, saveTodos newTodos )

    SetFilter filter ->
        ( { model | filter = filter }, Cmd.none )

    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model
          , Browser.Navigation.pushUrl model.navigationKey (Url.toString url)
          )

        Browser.External url ->
          ( model, Browser.Navigation.load url )

    ChangeUrl url ->
      ( { model | filter = urlToFilter url }, Cmd.none )

port saveTodos : List Todo -> Cmd msg


-- View
view : Model -> Document Msg
view model =
  { title = "Navigation TODOs"
  , body = [ viewBody model ]
  }

viewBody : Model -> Html Msg
viewBody model =
  div [ class "col-12 col-sm-6 offset-sm-3" ]
    [ form [ class "row", onSubmit GenerateTodoId ]
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
                [ class "btn btn-primary form-control" ]
                [ text "+" ]
            ]
        ]
    , viewFilters model.filter
    , div [] <|
        List.map
          (viewTodo model.editing)
          (filterTodos model.filter model.todos)
    ]

filterTodos : Filter -> List Todo -> List Todo
filterTodos filter todos =
  case filter of
    All ->
      todos

    Incomplete ->
      List.filter (\t -> not t.completed) todos

    Completed ->
      List.filter (\t -> t.completed) todos

viewFilters : Filter -> Html Msg
viewFilters filter =
  div []
    [ viewFilter All (filter == All) "All"
    , viewFilter Incomplete (filter == Incomplete) "Incomplete"
    , viewFilter Completed (filter == Completed) "Completed"
    ]

viewFilter : Filter -> Bool -> String -> Html Msg
viewFilter filter isFilter filterText =
  if isFilter then
    span [ class "mr-3" ] [ text filterText ]
  else
    a
      [ class "text-primary mr-3"
      , href ("#" ++ String.toLower filterText)
      , onClick (SetFilter filter)
      , style "cursor" "pointer"
      ]
      [ text filterText ]

viewTodo : Maybe TodoEdit -> Todo -> Html Msg
viewTodo editing todo =
  case editing of
    Just todoEdit ->
      if todoEdit.id == todo.id then
        viewEditTodo todoEdit
      else
        viewNormalTodo todo

    Nothing ->
      viewNormalTodo todo

viewEditTodo : TodoEdit -> Html Msg
viewEditTodo todoEdit =
  div [ class "card" ]
    [ div [ class "card-block" ]
        [ form [ onSubmit (EditSave todoEdit.id todoEdit.text) ]
            [ input
                [ onInput (Edit todoEdit.id)
                , class "form-control"
                , value todoEdit.text
                ]
                []
            ]
        ]
    ]

viewNormalTodo : Todo -> Html Msg
viewNormalTodo todo =
  div [ class "card" ]
    [ div [ class "card-block" ]
        [ input
            [ onClick (ToggleTodo todo.id)
            , type_ "checkbox"
            , checked todo.completed
            , class "mr-3"
            ]
            []
        , span
            [ onDoubleClick (Edit todo.id todo.text)
            , style
                "text-decoration"
                (if todo.completed then
                    "line-through"
                  else
                    "none"
                )
            ]
            [ text todo.text ]
        , span
            [ onClick (RemoveTodo todo.id)
            , class "float-right"
            ]
            [ text "x" ]
        ]
    ]


-- Functions
urlToFilter : Url -> Filter
urlToFilter url =
  case url.fragment of
    Nothing ->
      All

    Just hash ->
      case String.toLower hash of
        "incomplete" ->
          Incomplete
        
        "completed" ->
          Completed
        
        _ ->
          All