# Ch 05

## 설명

1. update

    ```elm
    type Msg
      = Increment
      | Decrement

    update : Msg -> Model -> Model
    update msg model =
      case msg of
        Increment ->
          model + 1
        Decrement ->
          model - 1
    ```

    `Increment`와 `Decrement`가 `Msg` 타입에 해당하며 `update`함수는 각각의 `Msg`에 해당하는 처리 로직을 구현하여 `model`을 업데이트 합니다.
 
## 참고

