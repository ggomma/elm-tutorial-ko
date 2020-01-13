# Ch 12

## 설명

1. `exposing (..)`

    ```elm
    -- Before
    import Html exposing (Html, button, div, input, text)

    -- After
    import Html exposing (..)
    ```

    `import Html exposing (..)`는 `Html` 모듈이 제공하는 모든 함수를 `import`하겠다는 의미입니다.

2. 초기값

    ```elm
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
    ```

    위 코드는 `Model`의 `todos` 초기값으로 `["ABC", "DEF"]`를 지정한 것입니다.

3. editing 상태

    ```elm
    type alias TodoEdit =
      { index : Int
      , text : String
      }
    ```

    `TodoEdit`은 현재 우리가 작업하고 있는 `todo`에 대한 정보를 가지고 있습니다.

4. `Maybe`

    `Maybe` 타입의 명세는 다음과 같습니다.
    ```elm
    type Maybe a
      = Just a
      | Nothing

    -- Just 3.14 : Maybe Float
    -- Just "hi" : Maybe String
    -- Just True : Maybe Bool
    -- Nothing   : Maybe a
    ```

    우리 코드에서는 `Maybe`를 다음 부분에 사용하고 있습니다.
    ```elm
    type alias Model =
      { text : String
      , todos : List String
      , editing : Maybe TodoEdit
      }
    ```
    
    즉, `Model`의 `editing` 항목은 `Just TodoEdit` 값을 갖거나 `Nothing` 값을 갖게 됩니다. 

    실제 사용하고 있는 부분은 다음과 같습니다.
    ```elm
    update : Msg -> Model -> Model
    update msg model =
      case msg of
        
        ...

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
    ```
    메시지가 `Edit`인 경우 `editing` 필드에는 `Just TodoEdit`이 들어가고, `EditSave`인 경우에는 `Nothing`이 들어가게 됩니다.

    보다 자세한 설명은 [여기](https://guide.elm-lang.org/error_handling/maybe.html)를 참고해주세요. 

5. viewNormalTodo

    ```elm
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
    ```

    `todo` 텍스트가 담겨있는 `span` 태그를 더블클릭하면 `(Edit index todo)` 메시지를 반환하여 그 `index`의 `todo`를 수정할 수 있습니다.

6. viewEditTodo

    ```elm
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
    ```

    `viewEditTodo`는 `viewNormalTodo`에서 특정 `todo`를 클릭하였을 떄 화면에 보여집니다. 


## 참고

  * [Maybe](https://guide.elm-lang.org/error_handling/maybe.**html**)