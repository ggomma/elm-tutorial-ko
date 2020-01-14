# Ch 14

## 설명

1. model에 값을 간단하게 할당하는 방법

    앞선 예제에서 우리는 초기값을 할당할 때 다음과 같은 방법을 사용하였습니다.
    ```elm
    -- Model
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
    ```

    초기값을 할당하는 부분을 조금 더 간단하게 작성하면 다음과 같습니다.
    ```elm
    -- Init
    init : () -> ( Model, Cmd Msg )
    init _ =
      ( Model "" [ "ABC", "DEF" ] Nothing
      , Cmd.none
      )
    ```
    `Model`을 정의할 때 항목의 순서를 `text`, `todos`, `editing`으로 정의하였으므로 위 코드에서 `text`는 `""`, `todos`는 `[ "ABC", "DEF" ]`, `editing`은 `Nothing`을 할당받게 됩니다.

    이때 유의할 점은 `Model` 이후에 주입해주는 값의 순서를 처음 `Model`을 정의하며 지정한 항목들의 순서와 동일하게 해줘야 한다는 것입니다. 즉, `Model "" [ "ABC", "DEF" ] Nothing`은 제대로 동작하지만, `Model [ "ABC", "DEF" ] "" Nothing`은 에러를 발생합니다.


## 참고

  * []()