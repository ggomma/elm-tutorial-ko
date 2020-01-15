# Ch 17

## 실행
  
  *ch15와 동일*

## 설명

1. 커스텀 타입

    ```elm
    type Filter
      = All
      | Incomplete
      | Completed
    ```
    커스텀 타입은 이해하기 조금 어려울 수 있지만 잘 익혀두면 굉장히 유용하게 사용할 수 있습니다. 예제에서 커스텀 타입을 적용한 `Filter`의 경우 `All`, `Incomplete`, 혹은 `Completed` 값을 가질 수 있습니다. 이때 위 3가지 값은 `String`도 아니고, `Int`도 아닌 새로운 타입이라고 생각하면 됩니다. 임시로 쓸 새로운 타입을 만들어 낸 것이죠.

    이를 이용하는 코드를 살펴봅시다.
    ```elm
    viewFilters : Filter -> Html Msg
    viewFilters filter =
      div []
        [ viewFilter All (filter == All) "All"
        , viewFilter Incomplete (filter == Incomplete) "Incomplete"
        , viewFilter Completed (filter == Completed) "Completed"
        ]
    ```
    위 코드에서 `filter` 값을 비교할 때에 `(filter == All)`과 같은 식으로 비교합니다. `(filter == "All")`이 아님에 유의하면 됩니다. 말 그대로 `All`이라는 새로운 타입이 생성된 것이죠.

2. `<|` 기능

    ```elm
    -- View
    view : Model -> Html Msg
    view model =
      
        ...
        
        , div [] <|
            List.indexedMap
              (viewTodo model.editing)
              -- We now filter the todos based on the current filter
              (filterTodos model.filter model.todos)
        ]
    ```
    `<|` 기능은 쉽게 말하자면 *'오른쪽에 있는 연산을 완료한 후 왼쪽으로 던져준다'* 라고 할 수 있습니다. 위 코드는 `List.indexedMap ...` 함수를 실행하고 나온 결과값을 왼쪽에 붙여줍니다. 예를들어 `List.indexedMap ...`의 결과값이 `[ text "hello world" ]`라고 한다면 위 코드는 다음과 동일한 결과를 만들어냅니다.

    ```elm
    -- Before
    div [] <|
      List.indexedMap
        (viewTodo model.editing)
        (filterTodos model.filter model.todos)
    
    -- After
    div [] [ text "hello world" ]
    ```

    `<|`와 방향이 반대인 `|>`도 있습니다. `|>`는 왼쪽의 연산을 오른쪽 연산의 마지막에 넣어준다는 의미인데, 다음과 같이 작동합니다.
    ```elm
    -- Normal
    add 5 (multiply 10 5)
    
    -- With |>
    multiply 10 5
      |> add 5
    ```
    이 두가지를 잘 활용하면 깔끔한 코드를 작성할 수 있습니다.

3. 예제에서 구현한 filter 기능

    ```elm
    filterTodos : Filter -> List Todo -> List Todo
    filterTodos filter todos =
      case filter of
        All ->
          todos

        Incomplete ->
          List.filter (\t -> not t.completed) todos

        Completed ->
          List.filter (\t -> t.completed) todos
    ```
    예제에서 구현한 필터 기능을 설명하면 다음과 같습니다.

    1. `Filter`와 `List Todo`를 인자로 받는다.
    2. 만약 입력받은 `Filter`의 타입이 `All`이라면 압력받은 `List Todo`를 그대로 반환한다.
    3. 만약 입력받은 `Filter`의 타입이 `Incomplete`라면 입력받은 `List Todo`에서 `completed`항목이 `False`인 것들만 모아 반환한다.
    4. 만약 입력받은 `Filter`의 타입이 `Completed`라면 입력받은 `List Todo`에서 `completed`항목이 `True`인 것들만 모아 반환한다.

## 참고

  * [custom types](https://guide.elm-lang.org/types/custom_types.html)
  * [<|란 무엇인가](https://elm-lang.org/docs/syntax#operators)
  * [<| 와 |> 에 대한 설명과 예제](https://elmprogramming.com/function.html#backward-function-application)