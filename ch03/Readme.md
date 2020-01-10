# Ch 03

## 설명

1. Html 요소

    ```elm
    main : Html msg
    main =
      div [class "text-center"] [text "Hello, World!"]
    ```
    Html의 요소들은 모두 2개의 `List`형 인자를 받습니다. 첫 번째 `List` 인자에는 Html 요소의 특성(attributes)를 넣어주고, 두 번째 `List`에는 자식 Html 요소들을 넣어줍니다.


    위 코드는 다음과 같이 사용됩니다.
    ```html
    <div class="text-center">
      Hello, World!
    </div>
    ```
   
## 참고

  * [Html Attributes 패키지](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes)
