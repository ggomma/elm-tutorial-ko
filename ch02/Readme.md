# Ch 02

## 설명

1. 메인 함수 정의

    ```elm
    main : Html msg
    main =
      text "Hello, World!?"
    ```
    `Html msg`는 HTML을 구성하는 핵심 단위입니다. 여기에서 `msg`는 elm의 [*type inference*](https://guide.elm-lang.org/types/)가 적용된 부분입니다. 그럼 위 코드는 다음과 같이 읽을 수 있습니다.

    `main : Html msg` 인데 `main = text "Hello, World!?"`라고 하였으므로 elm은 이를 `main : Html String` 으로 인식하게 됩니다.

    `Html msg`의 구성은 [여기](https://github.com/elm/html/blob/97f28cb847d816a6684bca3eba21e7dbd705ec4c/src/Html.elm#L99)에서 확인할 수 있습니다.


## 참고

  * [Html 패키지](https://package.elm-lang.org/packages/elm/html/latest/)
  * [Html msg에서 msg는 무엇인가 : stackoverflow](https://stackoverflow.com/a/41635045)
  * [Html Msg와 Html msg의 차이](https://discourse.elm-lang.org/t/html-msg-vs-html-msg/2758)
