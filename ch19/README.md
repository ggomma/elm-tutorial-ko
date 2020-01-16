# Ch 19

## 실행
  
  *ch15와 동일*

## 설명

1. `Browser.Document`

    ```elm
    import Browser exposing (Document, UrlRequest, application)
    ```
    `Browser.Document`는 `Browser.element`에 `<title>`, `<body>`를 조작할 수 있는 기능을 추가한 함수입니다. 이 함수는 다음과 같이 사용합니다.

    ```elm
    
    -- type alias Document msg =
    --   { title : String
    --   , body : List (Html msg)
    --   }


    -- View
    view : Model -> Document Msg
    view model =
      { title = "Navigation TODOs"
      , body = [ viewBody model ]
      }
      ```

2. `Browser.UrlRequest`

    ```elm
    import Browser exposing (Document, UrlRequest, application)
    ```

    `Browser.UrlRequest`는 다음과 같이 정의되어 있습니다.
    ```elm
    type UrlRequest
      = Internal Url
      | External String
    ```

    Internal은 동일한 도메인 내에서 이동하는 경우를 의미하고 External은 전혀 다른 도메인으로 이동하는 경우를 의미합니다. 보다 자세한 내용은 [여기](https://package.elm-lang.org/packages/elm/browser/latest/Browser#UrlRequest)를 참고하면 됩니다.

3. `Browser.application`

    ```elm
    application :
      { init : flags -> Url -> Key -> ( model, Cmd msg )
      , view : model -> Document msg
      , update : msg -> model -> ( model, Cmd msg )
      , subscriptions : model -> Sub msg
      , onUrlRequest : UrlRequest -> msg
      , onUrlChange : Url -> msg
      }
      -> Program flags model msg
    ```

    이번 예제에서는 이전에 사용한 `Browser.element`가 아닌 `Browser.application`을 사용합니다. `Browser.application`는 기본적으로 Url에 관련된 기능을 수행하며 몇가지 독특한 차이점이 있습니다.

    1. `init`은 2개의 인자를 추가로 입력받습니다.

        * `Url` : 브라우저에 입력된 현재 url
        * `Key` : 내비게이션 키

    2. 만약 유저가 페이지 내에서 링크를 클릭하는 경우 바로 새로운 Html 페이지를 로드하지 않고, `onUrlRequest`가 이 변화를 중간에 가로채게 됩니다. `onUrlRequest`는 새로운 메시지를 만들고 이를 `update` 함수로 전달합니다. `onUrlRequest`에 대한 보다 자세한 내용은 [여기](https://package.elm-lang.org/packages/elm/browser/latest/Browser#UrlRequest)를 참고하면 됩니다.

    3. 만약 Url이 변경되면 새로운 Url이 `onUrlChange`로 전달됩니다. 그리고 메시지를 `update` 함수로 전달하고 어떤 페이지를 보여줄 지 결정할 수 있습니다.

4. `Browser.Navigation`

    `Browser.Navigation`은 브라우저 url을 다룰 수 있게 해줍니다. 그리고 `Browser.application`을 사용할 때에는 거의 필수처럼 사용합니다.

    `Browser.Navigation`에서 가장 중요한 함수는 `pushUrl`으로 이 함수는 페이지를 새로 로드하지 않은 채로 브라우저 url을 변경하는 작업(클라이언트 사이드 렌더링)을 수행합니다.

    이중 `Browser.Navigation.Key`는 url을 변경하는 4가지 함수(`pushUrl`, `replaceUrl`, `back`, `forward`)를 사용하기 위해 필요한 타입입니다.

    이번 예제에서는 `Browser.Navigation.Key`를 `Model`에 저장하여 사용합니다.
    ```elm
    import Browser.Navigation exposing (Key)

    -- Model
    ...

    type alias Model =
      { text : String
      , todos : List Todo
      , editing : Maybe TodoEdit
      , filter : Filter
      , navigationKey : Key
      }
    ```

5. `Url`

    ```elm
    type alias Url =
      { protocol : Protocol
      , host : String
      , port_ : Maybe Int
      , path : String
      , query : Maybe String
      , fragment : Maybe String
      }
    ```

    `url` 패키지는 새로운 url을 만들거나 기존 url을 파싱해서 사용할 때 사용합니다.

6. init

    `Browser.application`으로 생성한 `main`함수의 `init` 함수는 `url`과 `key`를 입력받습니다.
    
    `url`은 서비스가 초기화될 때 elm 런타임에 의해 자동으로 주입됩니다. 예제에서는 입력받은 url을 이용해 필요한 filter 값을 추출합니다.
    
    `key`는 브라우저에서 원하는 페이지를 로드할 때 사용합니다.

7. urlToFilter 함수

    ```elm
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
    ```

    이 함수는 `Url` 타입을 입력받아 `Filter` 타입을 반환합니다. 우리가 눈여겨 봐야 할 부분은 `hash(string)`를 분기처리하는 곳입니다.
    
    `_ ->` 는 모든 값을 다 만족시키는 패턴입니다. 그래서 `hash`가 "incomplete"이거나 "completed"이라면 `Incomplete`와 `Completed` 타입을 반환합니다. 하지만 그 외의 경우에는 `All` 타입을 반환합니다.




## 참고

  * [Browser.Document](https://package.elm-lang.org/packages/elm/browser/latest/Browser#document)
  * [Browser.UrlRequest](https://package.elm-lang.org/packages/elm/browser/latest/Browser#UrlRequest)
  * [Browser.Element에서 url을 관리할 수 있나요?](https://github.com/elm/browser/blob/1.0.2/notes/navigation-in-elements.md)
  * [Browser.Navigation](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Navigation)
  * [url 패키지](https://package.elm-lang.org/packages/elm/url/latest/)
  * [case 사용법 + `_`(언더스코어)](https://elmprogramming.com/case-expression.html)