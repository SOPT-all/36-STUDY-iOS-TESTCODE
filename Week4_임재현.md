## 1. TDD란? (Test-Driven-Development)

TDD 는 테스트 주도 개발이란 뜻으로,기존에 코드를 작성하고 테스트코드를 작성하던 방식과 다르게,

실패하는 테스트코드를 먼저 작성하고, 최소한의 통과로 개선하고, 리팩토링 하는 사이클로 진행된다.

TDD 는 테스트만을 위한 기술이 아닌,  소프트웨어 설계 방법론에 가깝다고 한다.

> TDD의 아이러니 중 하나는 테스트 기술이 아니라는 점이다. TDD는 분석 기술이며, 설계 기술이기도 하다. - 켄트 벡
> 

## 2. TDD 사이클: Red - Green - Refactor


TDD 는 3단계 사이클로 진행된다고 한다.

### 1. Red

아직 구현되지 않은 기능에 대해 **테스트부터 먼저 작성**

실패되도록 테스트를 구성하고,코드를 테스트를 통과하기위해 최소한으로 개선한다.

```swift
import XCTest
@testable import YourApp

final class CalculatorTests: XCTestCase {
    func testAddition() {
        let calculator = Calculator()
        let result = calculator.add(2, 3)
        XCTAssertEqual(result, 5)
    }
}
```

위의 계산기 예제에서, 해당 테스트코드는 100% 실패할 것이다. 

Calculator 객체를 선언해주지 않았기 때문이다.

### 2. Green

테스트를 통과하는 최소한의 코드 작성

```swift
final class Calculator {
    func add(_ a: Int, _ b: Int) -> Int {
        return 4
    }
}
```

위의 Red 에서는 Calculator 객체와, add 함수를 선언해주지 않아서 실패했다면, 그것을 통과하기 위한 최소조건, 즉 객체와 함수를 생성하고 테스트를 통과시켜준다.

### 3. Refactor

코드 정리 및 개선 작업

```swift
final class Calculator {
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
}
```

위에서 최소한의 테스트를 통과하기위해 일단 add 함수를 만들어 주었지만, 어떤 값을 파라미터로 받아도 4를 리턴하는 함수이다.

이를 개선하기 위해 진짜 add 의 역할을 할수 있는 함수로 개선해준다.

## 3. TDD의 필요성과 장점

### 1. 설계품질 향상

코드를 먼저 작성하고, 테스트코드를 작성하는것이 아닌 테스트를 먼저 생각하므로, 의존성 분리, SRP 등 객체지향 설계 원칙을 따르게 된다.

### 2. 디버깅 시간 단축

테스트 케이스가 구체적 단위로 존재하고, 테스트를 먼저 설계하기 때문에, 버그가 어디서 생겼는지 파악하는게 걸리는 시간이 단축된다.

### 3. 빠른 피드백

마찬가지로 바로바로 테스트를 진행하기 때문에 기능이 깨졌는지 바로 확인이 가능하다.

### 4.리팩토링 두려움 감소

테스트가 있으니 **UI 이외의 로직을 마음 놓고 수정**할 수 있다.

### 5.명세 기반 개발

테스트가 기능명세 역할을 하므로 , 협업자와 커뮤니케이션에도 유리하다.

## 결론

- TDD는 **단순한 테스트 기법이 아니라, 견고한 아키텍처와 유연한 코드의 기반**이 된다.
- **빠른 유지보수**, **신뢰성 있는 코드**, **좋은 설계**를 얻고 싶다면 TDD를 적용해야 한다.

## 2. 비동기 테스트 - XCTestExpectation

비동기 로직 (ex: 네트워크 통신, 비동기 콜백 등)을 테스트할 때 사용된다.

```swift
func testAsyncOperation() {
    let expectation = expectation(description: "Async Call")

    someAsyncFunction {
        // 비동기 콜백 도착
        XCTAssert(true)
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 5.0)
}

```

1. expectation(description:) → XCTestExpectation 객체 생성

 Async Call 이 발생하길 기대(expect) 하고 있다고 선언하는 단계이며, 보통 테스트 이름 또는 기다리는 이벤트 이름으로 작성한다고 한다.

2. fulfill() → 기대한 일이 실제로 발생했을때 호출한다.

만약 호출되지 않으면 아래 wait() 이 타임아웃 까지 기다린다

3. wait(for: , timeout:)  → 기대되는 동작이 실행될때까지 기다리는 객체

해당 timeout 시간까지 fulfill()이 실행되지 않으면 테스트 실패로 처리

```swift
func fetchUserData(completion: @escaping (String) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
        completion("사용자 데이터")
    }
}

// 위의 함수에 대한 테스트 코드 예시 
func testFetchUserData() {
    let expectation = expectation(description: "User data fetch")
    
    fetchUserData { result in
        XCTAssertEqual(result, "사용자 데이터")
        expectation.fulfill()
    }
    
    wait(for: [expectation], timeout: 3.0) // 3초 안에 fulfill 안 되면 실패
}

```

위의 함수에서 현재 시간으로부터 2초 뒤에 사용자 데이터 completion이 호출되는 로직을 작성했다고 가정하면, 그 안에 fulfill 이 되야 성공을 하는 것이므로, timeout을 3초로 설정해줘서 테스트를 작성한 것이다.
