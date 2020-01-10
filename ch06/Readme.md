# Ch 06

## 설명

1. List Int

    ```elm
    type alias Model = List Int
    ```

    `List Int`는 `Int`로 이루어진 `List`를 의미합니다. `[1, 2, 3]`이 해당합니다.


2. `List.indexedMap`

    `List.indexedMap`은 `List.map`에 `List`의 `index`가 추가로 나오는 함수입니다. 다음과 같이 사용할 수 있습니다.

    ```elm
    parser : Int -> Int -> Int
    parser index element =
      index * element

    List.indexedMap parser [1, 2, 3, 4]
    -- [0, 2, 6, 12]
    ```

    본 튜토리얼에서 사용한 `List.indexedMap`은 다음과 같습니다.
    ```elm
    -- View
    view : Model -> Html Msg
    view model =
      div [class "text-center"]
        (List.indexedMap viewCount model)

    -- Functions
    viewCount : Int -> Int -> Html Msg
    viewCount index count =
      div [class "mb-2"]
        [
          text (String.fromInt count),
          button [class "btn btn-primary", onClick (Increment index)] [text "+"]
        ]
    ```

    좀 더 자세히 설명하자면 `model` 초기값은 `[0, 0]`이고, `viewCount` 함수는 첫번째로 `(0, 0)`을 입력받고, 두번째로 `(1, 0)`을 입력받아 처리하게 됩니다.

3. 익명함수

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
    ```

    위 코드에서 `\`로 시작하는 다음 부분은 익명함수입니다.
    ```elm
    \i count ->
      if i == index then
        count + 1
      else
        count
    ```
    
    익명함수는 미리 함수를 선언해서 사용하는 방식으로 대체할 수 있습니다. 이를 이용해 위 코드를 다시 작성해보면 다음과 같습니다.
    ```elm
    counter : Int -> Int -> Int -> Int
    counter index i count =
      if i == index then
        count + 1
      else
        count

    update : Msg -> Model -> Model
    update msg model =
      case msg of
        Increment index ->
          List.indexedMap
            (counter index)
            model
    ```
    

## 참고

  * [List.indexedMap](https://package.elm-lang.org/packages/elm/core/latest/List#indexedMap)
  * [Functions](https://elm-lang.org/docs/syntax#functions)