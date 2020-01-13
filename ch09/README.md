# Ch 09

## 설명

1. Record 업데이트

    ```elm
    -- Update
    update : Msg -> Model -> Model
    update msg model =
      case msg of
        UpdateText newText ->
          { model | text = newText }
    ```

    `Record`를 업데이트 할 때에는 다음과 같이 `|` 를 사용한다. 그리고 이 업데이트는 항상 새로운 `Record`를 만들어낸다(immutable).
    ```elm
    origin : { x : Float, y : Float }
    origin =
      {
        x = 0,
        y = 0
      }

    { origin | y = 5 }
    -- { x = 0, y = 5 }
    ```

2. `onInput`

    ```elm
    -- Model
    type Msg
      = UpdateText String
    
    -- View
    view : Model -> Html Msg
    view model =
      div
        [ class "text-center" ]
        [ input [ onInput UpdateText, value model.text ] []
        , div [] [ text model.text ]
        ]
    ```

    공식 문서에서 `onInput`을 찾아보면 다음의 명세를 볼 수 있습니다.
    ```elm
    onInput : (String -> msg) -> Attribute msg
    ```

    즉, onInput은 하나의 인자를 받는 함수로서, 인자는 `(String -> msg)`형식이어야 합니다. 우리가 위에서 선언한 `UpdateText`는 `String`을 인자로 받아 `Msg`를 리턴하는 함수이므로 다음과 같이 나타낼 수 있습니다.
    ```elm
    UpdateText : String -> Msg
    ```


## 참고

  * [Updating Records](https://elm-lang.org/docs/records#updating-records)
  * [onInput](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput)