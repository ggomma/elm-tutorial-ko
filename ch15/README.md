# Ch 15

## 실행

1. elm -> js 코드 컴파일

    ```console
    > cd ch15
    > elm make src/Main.elm --output src/elm.js
    ```

    위 명령어를 수행하면 `Main.elm` 코드가 컴파일되어 `elm.js` 파일이 생성됩니다.

2. `index.html`에서 1) 에서 생성한 `elm.js`를 불러옴 (이미 적용되어 있음)

    ```html
    <html>
    <head>
      <meta charset="utf-8">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.6/css/bootstrap.css">
    </head>
    <body>
      <div id="root"></div>
      <script src="elm.js"></script>
      ...
    </body>
    ```

3. 실행

    ```console
    > elm reactor
    ```
    코드를 실행하고 `index.html` 파일을 선택하면 화면에 작성한 코드가 실행됩니다.


## 설명

1. **index.html**

    ```html
    <html>
    <head>
      <meta charset="utf-8">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.6/css/bootstrap.css">
    </head>
    <body>
      <div id="root"></div>
      <script src="elm.js"></script>
      <script>
        var isArrayOfStrings = function(array) {
          return Array.isArray(array) && array.every(function(element) {
            return typeof element === 'string';
          });
        };
        
        var getTodos = function() {
          var todos = JSON.parse(localStorage.todos || '[]') || [];
          return isArrayOfStrings(todos) ? todos : [];
        };

        var app = Elm.Main.init({
          node: document.getElementById('root'),
          flags: { todos: getTodos() }
        });
        
        app.ports.saveTodos.subscribe(function(todos) {
          localStorage.todos = JSON.stringify(todos);
        });
      </script>
    </body>
    </html>
    ```

    정말 중요한 부분입니다. 어떻게 우리가 작성한 elm 파일을 컴파일해서 사용하는지 하나하나 알아봅시다.

    ```html
    <script src="elm.js"></script>
    ```
    우리가 작성한 Main.elm 코드를 컴파일한 결과물인 `elm.js`을 불러옵니다. js로 컴파일된 elm 코드는 `Elm`으로 접근할 수 있습니다. 즉 우리가 코드에서 `port module Main exposing (main)` 형식으로 내보낸 `main` 함수를 `Elm.Main`으로 접근할 수 있습니다.


    ```js
    var app = Elm.Main.init({
      node: document.getElementById('root'),
      flags: { todos: getTodos() }
    });
    ```
    이 코드를 통해 우리가 작성한 코드에 todos가 입력됩니다. 입력되는 부분은 다음과 같습니다.
    ```elm
    -- Init
    init : Flags -> ( Model, Cmd Msg )
    init flags =
      ( Model "" flags.todos Nothing
      , Cmd.none
      )
    ```

2. `port`

    ```elm
    port module Main exposing (main)
    ```

    `port`는 Elm과 Javascript를 연결해주는 파이프 기능을 수행합니다. 그리고 각각의 `port`는 *elm -> JS* 혹은 *JS -> elm* 의 한 방향으로만 작동합니다. 이번 예제에서는 `model state`를 local storage에 저장하기 위해 `port`를 사용합니다.

3. `Flags`

    ```elm
    -- Main
    main : Program Flags Model Msg
    main = element
      { init = init
      , view = view
      , update = update
      , subscriptions = subscriptions
      }


    -- Model
    type alias Flags =
      { todos : List String }


    -- Init
    init : Flags -> ( Model, Cmd Msg )
    init flags =
      ( Model "" flags.todos Nothing
      , Cmd.none
      )
    ```

    앞선 예제들과 다르게 이번 예제에서는 `flags`를 사용해 서비스가 시작할 때 local storage에서 todos 값을 `flags`를 통해 주입해줄 것이기 때문에 `main : Program Flags Model Msg`로 정의하였습니다. `flags`는 코드가 실행되는 가장 첫 부분에 javascript로 부터 받아온 값을 의미합니다. 그리고 초기값으로 `flags`를 받아 `Model`에 주입해줍니다.

4. Updates

    ```elm
    -- Update
    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
      case msg of
        
        ...

        AddTodo ->
          let
            newTodos =
              model.todos ++ [ model.text ]
          in
          ( { model | text = "", todos = newTodos }
          , saveTodos newTodos
          )

        RemoveTodo index ->
          let
            beforeTodos =
              List.take index model.todos
            afterTodos =
              List.drop (index + 1) model.todos
            newTodos =
              beforeTodos ++ afterTodos
          in
          ( { model | todos = newTodos }
          , saveTodos newTodos
          )

        ...

        EditSave index todoText ->
          let
            newTodos =
              List.indexedMap
                (\i todo ->
                    if i == index then
                      todoText
                    else
                      todo
                )
                model.todos
          in
          ( { model | editing = Nothing, todos = newTodos }
          , saveTodos newTodos
          )
    
    port saveTodos : List String -> Cmd msg
    ```

    이전 예제들과는 다르게 이번에는 `AddTodo`, `RemoveTod`, `EditSave` 메시지의 경우 `Cmd.none`을 반환하지 않고 `saveTodos newTodos` 라는 명령어를 반환합니다.

    `saveTodos`는 `newTodos : List String`를 Javascript 코드의 콜백함수로 전달합니다. 이에 해당하는 Javascript 코드는 다음과 같습니다. (*index.html*)
    ```javascript
    app.ports.saveTodos.subscribe(function(todos) {
      localStorage.todos = JSON.stringify(todos);
    });
    ```

## 참고

  * [html에서 elm을 컴파일한 js를 사용하는 법](https://guide.elm-lang.org/webapps/)
  * [Elm에서 port가 동작하는 방식](https://hackernoon.com/how-elm-ports-work-with-a-picture-just-one-25144ba43cdd)
      ![](https://hackernoon.com/hn-images/1*4QNG3QrtceCWlEtqO1nneQ.png)
  * [ports 공식 문서](https://guide.elm-lang.org/interop/ports.html)