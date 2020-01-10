# Ch 01

## 설명

1. 모듈 정의

    ```elm
    module Main exposing (main)
    ```
    이 모듈(파일)의 이름은 `Main`이고 이 모듈에 있는 `main`을 외부로 export 한다는 의미입니다.
  

2. 모듈 import

    ```elm
    import Html exposing (text)
    ```
    `Html` 모듈 내에 있는 text를 import 한다는 의미입니다.


3. 화면에 표시
   
    ```elm
    main =
      text "Hello, World"
    ```
    위 코드는 아래 Html을 화면에 출력합니다.
    ```html
    <html>
        <body>
            Hello, World
        </body>
    </html>
    ```


## 추가로 알아야 할 내용
