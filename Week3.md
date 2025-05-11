## 테스트 가능한 구조

소프트웨어를 설계할때 자동화된 테스트를 쉽게 설계하고,실행할 수 있도록 만든 코드구조.

품질,안정성,유지보수성을 높이는데 중요할 역할을 수행

테스트가 가능하려면?

1. 단일책임원칙(SRP)을 잘 따라야한다.

단일책임원칙이란? - 각 클래스나 함수가 하나의 책임만 가지도록 설계

만약 어떤 함수나 객체가 여러개의 책임을 가지고 있게된다면, 테스트를 하기위한 하나의 기능만 분리해서 테스트하기가 어려워진다.

또한 그 객체에 대해서 테스트가 실패했을때 여러 책임을 가지고 있다면, 그 테스트한 기능만의 문제인지 혹은 복합적인 이유때문인지 알아내기 어려워진다.

단일책임원칙을 잘 지킨 코드는 그 객체의 책임이 분명하여, 그 하나의 책임에 대한 테스트코드를 짜기 수월해진다.

2. 의존성 주입(DI) 

의존성 주입 - 객체가 필요한 외부 의존성을 직접 생성하지않고, 외부에서 생성 한 후, 전달을 받는 구조이다.

의존성 주입을 통해 코드의 결합도가 낮아지고 테스트가 용이해진다.

실제 테스트를 진행할때 의존성주입 으로 코드가 작성되어있으면 그 의존성 부분을 MOCK(모의객체)로 대체하여 네트워크,DB등 외부 시스템에 의존하지 않고 테스트를 진행할 수 있게된다.

3. 관심사 분리

UI, 비지니스 로직, 데이터 접근 등 명확하게 분리

관심사를 분리해두지 않으면 마찬가지로, 테스트를 진행하기 어려워진다.

만약 UI와 비지니스 로직이 한군데 엉켜있는 코드에서 UI에 관련된 테스트를 진행하려고 하면, 그때가 되어서 UI만 따로 걷어내서 작업을 해야한다.

설계단계에서 UI 와, 비지니스 로직, 데이터 등을 잘 분리해두면, 해당 부분에 대해서 테스트를 진행할때 수월해진다.

4. 인터페이스 추상화

Protocol 을 통해 의존성 주입이 가능하며, 코드 재사용이 수월해진다. 이는 테스트 코드를 짜는 단계에서 Protocol 을 통해 실제 구현체 대신 Mock 객체를 주입시켜 줌으로써 테스트를 수월하게 해줄 수 있다.

5. **작은 단위로 분리**: 큰 함수나 클래스를 작은 단위로 분해

큰 단위로 이루어저있는 객체나 함수는 당연하게 테스트를 진행하기 어려워질것이다.

이때 세분화를 통해 각 역할과 의도에 맞게 잘 분리해두면, 테스트를 하기 수월해 질 것이다.

## 의존성 주입(DI)

의존성 주입이란 ?

객체가 사용할 객체(의존성)를 **직접 생성하지 않고**, 외부에서 **주입**받는 방식이다.

의존성 주입을 하지 않는 코드

```swift
class Logger {
    func log(_ message: String) {
        print("LOG: \(message)")
    }
}

class UserService {
    private let logger = Logger() // 직접 생성함 (강한 결합)

    func login() {
        logger.log("사용자 로그인 시도")
    }
}

```

위에서 UserService 에서 로그를 출력하는 기능이 필요해서, Logger 라는 객체를 외부에 만들고,

필요한 곳인 UserService 에 직접 객체를 만들어서 사용해주고 있다.

이때 UserService 에서 logger 를 가지고 있으므로 강하게 결합되어 있는 상태이다.

이처럼 강하게 결합되어 있을 경우, 테스트를 위한 분리또한 어려울 뿐 아니라 나중에 코드를 확장시키는데도 어려움이 따른다.

의존성 주입을 한 코드

```swift
class Logger {
    func log(_ message: String) {
        print("LOG: \(message)")
    }
}

class UserService {
    private let logger: Logger

    // 생성자 주입 (Constructor Injection)
    init(logger: Logger) {
        self.logger = logger
    }

    func login() {
        logger.log("사용자 로그인 시도")
    }
}

let logger = Logger()
let userService = UserService(logger: logger)
userService.login()
```

이처럼 1. 외부에서 Logger 객체를 먼저 생성한 후, 2. UserService에 init 을 통해서, 생성된 객체를 직접 받는(주입) 을 통해 사용해주는 것이 의존성 주입을 적용한 사례이다.

이는 logger 객체는 외부에서 따로 생성, 필요할 경우 UserService에서 받아서 사용하므로 결합도가 감소하게 되므로, 테스트에도 용이하다.

만약 테스트가 필요할 경우, Logger() 부분을  같은 프로토콜을 채택한 Mock 객체로 대체한 후, 주입만 시켜주면 바로 Mock 에 구현해준 것을 이용해 테스트를 진행 할 수 있는것이다.

```swift
protocol Logging {
    func log(_ message: String)
}

class Logger: Logging {
    func log(_ message: String) {
        print("LOG: \(message)")
    }
}

class MockLogger: Logging {
    var loggedMessages: [String] = []

    func log(_ message: String) {
        loggedMessages.append(message)
    }
}

class UserService {
    private let logger: Logging

    init(logger: Logging) {
        self.logger = logger
    }

    func login() {
        logger.log("사용자 로그인 시도")
    }
}
```

이처럼 같은 프로토콜 타입인 다른 객체로 얼마든지 갈아끼울 수 있는 상태가 되는 것이다.

## 테스트 더블(Mocks, Stubs)

테스트 더블이란 - 테스트 방법론 중 하나로 , 영화에서 위험한 장면을 대신 수행하는 스턴트 더블 에서 차용한 언어라고 한다.

테스트 중인 시스템의 일부분이 완전히 준비되지 않거나,테스트 하기 어려운 상태에서 그 대안으로 사용될 수 있는 가짜 컴포넌트를 의미한다.

![155876237-36a220bd-8e0f-4f1c-b0be-6a4a012fb3d2](https://github.com/user-attachments/assets/ffc73db7-78de-4ec6-9472-f0992f0a5094)


출처: https://velog.io/@carrykim/%ED%85%8C%EC%8A%A4%ED%8A%B8-%EB%8D%94%EB%B8%94Test-Doubles





**상태 검증 (State Verification)**

ㄴ 특정 동작이 실행된 **결과로 인해 객체의 상태가 어떻게 바뀌었는지를 검증**하는 방식

Stub: 테스트 중 호출되면 미리 준비된 응답을 제공

stub은 일반적으로 테스트가 필요로 하는 데이터를 제공하거나 특정 메소드 호출이 예상대로 이루어지는지를 검증하는 데 사용.  테스트가 예측 가능한 방식으로 실행될 수 있도록 특정 상황에서 미리 정의된 응답을 반환

→ Stub을 통해 미리 정해진 데이터를 보내주어 개발자의 의도대로 제대로 동작하는지 확인할때 사용 ( input 을 통한 output 이 예상한 대로 잘 작동하는지)

**행위 검증 (Behavior Verification)**

ㄴ 행위 검증은 시스템의 상태보다는 특정 작업을 수행하는 과정에서 발생하는 행위에 더 관심을 둠

Mock: Mock 객체는 실제 객체를 모방한 객체로, 테스트 환경에서 실제 의존성을 대체하기 위해 사용된다. 이들은 주로 외부 시스템과의 상호작용이나 어떤 서비스의 응답을 모방할 때 유용하게 쓰인다. Mock 객체는 특정 메소드 호출에 대한 기대값을 설정할 수 있게 해주며, 실제 로직을 수행하지 않기 때문에 테스트의 속도를 높이고, 여러 복잡한 시나리오를 단순화하여 테스트할 수 있도록 도와준다

→ 실제 객체는 특정 메서드를 정말 호출했는지, 몇번 호출했는지, 어떤 값을 사용해서 호출했는지 행위에 대해 기록하거나 알 수 없다. 이때 Mock 을 통해 해당 정보를 기록하고 검증할 수 있는 것을 만들고 의존성 주입을 통해 테스트를 진행할때 사용된다.




참고한 블로그:

https://velog.io/@carrykim/%ED%85%8C%EC%8A%A4%ED%8A%B8-%EB%8D%94%EB%B8%94Test-Doubles
https://azderica.github.io/00-test-mock-and-stub/#google_vignette

