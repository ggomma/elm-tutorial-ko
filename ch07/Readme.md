# Ch 07

## 설명

1. List Append

    ```elm
    update : Msg -> Model -> Model
    update msg model =
      case msg of
        Increment index ->
          List.indexedMap
            (
              \i count ->
                if i == index then
                  count + 1
                else
                  count
            )
            model
        AddCount ->
          model ++ [0]
    ```

    `List`에 항목을 추가하고자 할 때에는 `++`를 사용합니다. 다음의 예시를 보면 이해가 쉬울 것입니다.
    ```elm
    [1, 2, 3] ++ [2, 4]
    -- [1,2,3,2,4]
    ```

## 참고