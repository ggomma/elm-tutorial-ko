# Ch 18

## 실행
  
  *ch15와 동일*

## 설명

1. Random 라이브러리

    일단 Random 라이브러리를 설치해봅시다.
    ```console
    > elm install elm/random
    ```

    위 명령어를 실행하면 `elm.json` 파일에 `elm/random` 디펜던시가 추가됩니다.
    ```json
    "dependencies": {
        "direct": {
            ...
            "elm/random": "1.0.0"
        }
    },
    ```
    
    그리고 코드에서 사용하기 위해 `import`를 해주면 됩니다.
    ```elm
    import Random
    ```

    우리가 사용할 `Random` 라이브러리의 기능은 `int`와 `generate` 입니다.

    `Random.int`는 주어진 범위 내에서 32 bit 크기의 정수를 반환하는 함수입니다. 최대값(`Random.maxInt`)은 2,147,483,647(2^31 - 1)이고, 최소값은 (`Random.minInt`)은 -2,147,483,648(-2^31) 입니다. 사용법은 다음과 같습니다.
    ```elm
    int : Int -> Int -> Generator Int
    ```

    만약 우리가 3 ~ 5 사이의 임의의 값을 만들어내고 싶다면 다음과 같이 사용하면 됩니다.
    ```elm
    -- 3 ~ 5 사이의 값
    Random.int 3 5
    ```

    여기서 중요한 것은 `Random.int`를 통해 얻은 결과값이 우리가 확인할 수 있는 숫자가 아닌 랜덤 숫자를 생성할 수 있는 `Generator Int`라는 것입니다. 생성한 `Generator Int`를 바탕으로 랜덤 숫자를 생성하기 위해서는 `generate` 혹은 `step` 함수를 이용해야 합니다. 이번 예제에서는 `generate` 함수를 이용하였습니다.
    
    ```elm
    -- generate
    generate : (a -> msg) -> Generator a -> Cmd msg
    ```
    `Random.generate`는 `Generator`를 인자로 받아 이를 실행할 수 있는 커멘드를 반환합니다.

    예제에서는 다음과 같이 사용하고 있습니다.
    ```elm
    -- Model
    type Msg
      = ...
      | AddTodo Int
      ...
    
    -- Update
    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
      case msg of
        ...
        GenerateTodoId ->
          ( model
          , Random.generate AddTodo (Random.int Random.minInt Random.maxInt)
          )
    ```

2. List.filter

    `List.filter`는 입력받은 리스트에서 특정 조건을 만족하는 요소들을 뽑아 리스트를 재구성하는 역할을 수행합니다. 
    ```elm

    -- filter : (a -> Bool) -> List a -> List a
    
    isEven : Int -> Bool
    isEven number = modBy 2 number == 0


    filter isEven [1, 2, 3, 4, 5, 6]
    -- [2, 4, 6]
    ```

3. /=

    `/=` 연산자는 javascript에서 `!=` 와 동일한 기능을 수행합니다.
    ```elm
    3 /= 5
    -- True

    3 /= 3
    -- False
    ```

## 참고

  * [random 라이브러리](https://package.elm-lang.org/packages/elm/random/latest/)
  * [Random.int](https://package.elm-lang.org/packages/elm/random/latest/Random#int)
  * [Random.generate](https://package.elm-lang.org/packages/elm/random/latest/Random#generate)
  * [Random.step](https://package.elm-lang.org/packages/elm/random/latest/Random#step)
  * [List.filter](https://package.elm-lang.org/packages/elm/core/latest/List#filter)