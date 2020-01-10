# Ch 08

## 설명

1. `let ... in ...`


    ```elm
    -- Update
    
    ...
    
    Remove index ->
      let
        before = List.take index model
        after = List.drop (index + 1) model
      in
        before ++ after

    ...
    ```

    `let`은 `in` 블록 안에 나오는 함수에서 사용할 수 있는 임시 변수를 만들어주는 역할을 수행합니다. 위 코드에서는 `before`, `after`라는 변수를 만들고 이 변수를 `in` 블록 안에서 `before ++ after` 형태로 사용할 수 있게 하였습니다.

2. `List.take`와 `List.drop`

    ```elm
    -- Update
    
    ...
    
    Remove index ->
      let
        before = List.take index model
        after = List.drop (index + 1) model
      in
        before ++ after

    ...
    ```

    `List.take`는 입력받은 `List`의 `index`까지의 요소들을 `List`로 재구성하는 역할을 수행합니다. 
    ```elm
    List.take 2 [1, 2, 3, 4]
    -- [1, 2]
    ```

    `List.drop`은 입력받은 `List`의 `index`까지의 요소들을 제거하고 나머지 요소들로 `List`를 재구성하는 역할을 수행합니다.
    ```elm
    List.drop 2 [1, 2, 3, 4]
    -- [3, 4]
    ```

## 참고

  * [let ... in ... 문법](https://elm-lang.org/docs/syntax#let-expressions)
  * [List.take](https://package.elm-lang.org/packages/elm/core/latest/List#take)
  * [List.drop](https://package.elm-lang.org/packages/elm/core/latest/List#drop)