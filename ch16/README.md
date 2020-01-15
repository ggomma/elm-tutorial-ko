# Ch 16

## 실행
  
  *ch15와 동일*

## 설명

1. Todo type

    ```elm
    type alias Todo =
      { text : String
      , completed : Bool
      }
    ```
    이번 예제에서는 기존에 `String`으로 사용했던 ToDo를 따로 type을 만들어 사용하도록 하겠습니다. Todo type은 `text`와 `completed` 두 항목을 가지고 있습니다. 이에 맞춰 코드 상에서도 Todo type을 이용하도록 변경하였습니다. 이에 대한 부분은 코드를 작성하시며 확인해보면 됩니다.

2. style 적용 방법

    ```elm
    style : String -> String -> Attribute msg

    -- Example
    greeting : Node msg
    greeting =
      div
        [ style "background-color" "red"
        , style "height" "90px"
        , style "width" "100%"
        ]
        [ text "Hello!"
        ]
    ```
    [공식 문서](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#style)를 보면 위와 같이 `style`을 사용하는 방법이 잘 설명되어 있습니다. 기본적으로 `style` 뒤에 key, value를 연속으로 입력해주는 방식으로 스타일링을 합니다. 예제에서는 다음과 같이 사용하고 있습니다.

    ```elm
    viewNormalTodo : Int -> Todo -> Html Msg
    viewNormalTodo index todo =

            ... 

            , span
                [ onDoubleClick (Edit index todo.text)
                , style
                    "text-decoration"
                    (if todo.completed then
                        "line-through"
                      else
                        "none"
                    )
                ]
                [ text todo.text ]
            
            ...
    ```
    입력받은 `todo.completed`가 `True`라면 `style "text-decoration" "line-through"`으로, `False`라면 `style "text-decoration" "none"`이 적용될 것입니다.

3. not

    ```elm
    -- Update
    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        
        ... 

        ToggleTodo index ->
          let
            newTodos =
              List.indexedMap
                (\i todo ->
                    if i == index then
                      { todo | completed = not todo.completed }
                    else
                      todo
                )
                model.todos
          in
          ( { model | todos = newTodos }, saveTodos newTodos )
    ```
    위 코드에서 다음 부분에 `not`이 사용된 것을 확인할 수 있습니다.
    ```elm
    { todo | completed = not todo.completed }
    ```

    `not`은 기본적으로 `Boolean` 타입 앞에서 값을 뒤집는 역할을 합니다. 에를들면 다음과 같습니다.
    ```elm
    > not True
    -- False
    ```

4. elm 코드를 사용하는 html

    elm을 컴파일한 결과물을 사용하기 위해 `html` 코드에서 javascript로 적절한 코드를 짜야 합니다. 이에 대한 코드는 `index.html` 에서 확인할 수 있으며, 내용은 다음과 같습니다.

    ```html
    <script>
      var isTodos = function(todos) {
        return Array.isArray(todos) && todos.every(function(todo) {
          return (
            !!todo &&
            typeof todo.text === 'string' &&
            typeof todo.completed === 'boolean'
          );
        });
      };
      
      var todosDefault = function(todos) {
        return isTodos(todos) ? todos : [];
      };
      
      var app = Elm.Main.init({
        node: document.getElementById('root'),
        flags: { todos: todosDefault(JSON.parse(localStorage.todos || '[]')) }
      });
      
      app.ports.saveTodos.subscribe(function(todos) {
        localStorage.todos = JSON.stringify(todos);
      });
    </script>
    ```

## 참고

  * [인라인 스타일링을 위한 Html.Attributes의 style](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#style)
  * [elm 에서 boolean 다루기](https://elmprogramming.com/boolean.html)