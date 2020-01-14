# Ch 13

## 설명

1. sandbox & element
   
    Ch 12 까지는 `Browser` 패키지의 `sandbox`를 사용하였지만, 이제부터는 `element`를 사용해봅시다.
    ```elm
    -- Before
    import Browser exposing (sandbox)

    -- After
    import Browser exposing (element)
    ``` 

    `sandbox` 는 파일 외부와 소통할 수 없지만 `element`는 가능합니다. 그래서 다른 `Javascript` 프로젝트에 임베딩하기 쉽습니다. `sandbox`에는 없는, `element`의 특징은 다음과 같습니다.

    1. `Cmd` - Elm에게 런타임에 HTTP 와 같은 커맨드를 명령할 수 있습니다.
    2. `Sub` - 특정 이벤트를 `subscribe` 할 수 있습니다.
    3. `flags` - Elm 프로그램을 시작할 때 JS가 데이터를 주입할 수 있습니다.
    4. `ports` - 클라이언트와 서버를 연결할 수 있습니다.

    넘겨받는 인자들도 약간 다릅니다.
    ```elm
    -- Sandbox
    sandbox :
      { init : model
      , view : model -> Html msg
      , update : msg -> model -> model
      }
      -> Program () model msg

    -- Element
    element :
      { init : flags -> ( model, Cmd msg )
      , view : model -> Html msg
      , update :: msg -> model -> ( model, Cmd msg )
      , subscriptions : model -> Sub msg
      }
      -> Program flags model msg
    ```

2. `subscriptions`

    ```elm
    -- Subscriptions
    subscriptions : Model -> Sub Msg
    subscriptions model =
      Sub.none
    ```

    이번 예제에서는 `subscriptions`을 사용하지 않습니다. `subscriptions`가 `Sub.none`을 반환하는 것은 `subscriptions`을 사용하지 않는다는 의미입니다ㅏ. `subscriptions`에 관련된 사항은 추후 다루도록 하겠습니다.

3. `Commands`와 `Subscriptions`

    일단 쉽게 생각합시다. `Commands`는 특정 함수(기능)을 실행시키는 역할을 수행하고, `Subscriptions`는 실행된 결과를 받는 역할을 수행합니다. 그리고 위에서 언급한 것과 유사하게 `Cmd.none`은 아무 기능도 실행하지 않는다는 의미입니다.

## 참고

  * [Browser 패키지](https://package.elm-lang.org/packages/elm/browser/latest/Browser)