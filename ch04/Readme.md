# Ch 04

## 설명

1. sandbox

    ```elm
    import Browser exposing (sandbox)
    ```

    `Browser` 모듈 안에 있는 `sandbox`는 static Html에서 벗어나 interactive application을 만들 수 있게 해줍니다. 

2. Main

    ```elm
    main = sandbox
      {
        init = 0,
        view = view,
        update = update
      }
    ```

    `sandbox`는 `init`, `view`, `update` 세 개의 인자를 받습니다. 그리고 위 코드에서 입력해주는 값들은 초기 값으로 사용됩니다. 만약 `onClick`처럼 어떤 이벤트가 발생한다면 `message`와 현재 시점의 `model`이 `update`함수로 전달됩니다. `update`함수는 전달받은 인자들을 바탕으로 새로운 `model`생성하고, 만약 기존 `model`과 새로운 `model`이 다르다면 `view` 함수가 새로운 `model`을 전달받아 새로운 Html을 반환하게 됩니다.
    
    `sandbox`함수의 명세를 살펴보면 다음과 같습니다.
    ```elm
    sandbox :
      {
        init : model,
        view : model -> Html msg,
        update : msg -> model -> model
      }
      -> Program () model msg
    ```

1. type

    ```elm
    type Msg = Increment    
    ```

    `Msg`라고 부르는 새로운 `type`을 정의하였으며, 이 `Msg`는 `Increment`라는 값만 가질 수 있습니다.

2. type alias

    ```elm
    type alias Model = Int
    ```

    `Model`이라고 부르는 `type alias`를 정의하였습니다. `type alias`는 새로운 `type`을 정의하는 것이 아니고, 단지 코드를 간결하게 만들기 위해 사용합니다.

3. View

    ```elm
    view : Model -> Html Msg
    view model =
      div [class "text-center"]
        [
          div [] [ text (String.fromInt model)],
          button
            [class "btn btn-primary", onClick Increment]
            [text "+"]
        ]
    ```

    `view` 함수는 `model state`를 인자로 받고 화면에 표시되는 Html를 만들어주는 함수입니다.

    여기서 사용한 `view` 함수는 `Model (Int)`을 인자로 받아 `Html Msg (Html Increment)`를 반환합니다. 이 함수는 `model`이 업데이트 될 때마다 호출되어 새로운 내용을 화면에 보여줍니다.

    `button`에 설정된 `onClick` 함수는 사용자가 버튼을 클릭할 때마다 이벤트를 발생시키고 메시지로 `Increment` 를 `update` 함수로 전달합니다. `update` 함수는 전달받은 메시지를 바탕으로 `model`의 상태를 업데이트 합니다.

4. Update

    ```elm
    update : Msg -> Model -> Model
    update msg model =
      case msg of
        Increment ->
          model + 1
    ```

    `update` 함수는 `event`가 발생할 때마다 호출되고, `message`와 현재 상태의 `model`이 인자로 넘어옵니다. 그리고 이 두 인자를 이용해 새로운 `model` 상태를 만들어 `view` 함수로 반환합니다.
 
## 참고

  * [sandbox](https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox)
  * [condition 문법 (case ... of)](https://elm-lang.org/docs/syntax#conditionals)
