# 3주차

<aside>
👨‍💻

테스트 가능한 코드 구조란?

- 의존성 주입(DI)
- 테스트 더블(Mocks, Stubs)
</aside>

# 테스트 가능한 코드 구조란?

여러 구조를 설계하고 고민하면서 많이 알려져있는 구조에 대해 공부하면서 항상 빠지지 않고 등장하는 부분이 있다

바로 “테스하기 용이한 구조” 라는 것이다.

대표적인 MVVM만 보더라도 비즈니스로직을 명확하게 분리함으로써 테스트에 용이한구조라고 많이 알려져있다 

그럼 어떤 특징을 가져야지, 테스트가 용이해지는지 살펴보자

# DI

<aside>
💡

의존성 주입은 **객체가 필요로 하는 의존 객체를 직접 생성하지 않고, 외부에서 주입받는 디자인 패턴**입니다.

즉, 객체 내부에서 다른 객체를 `new` 하거나 `init()`으로 직접 생성하는 대신, 생성된 객체를 외부에서 넘겨주는 방식입니다.

</aside>

DI에 자세히 알아보기전에 의존성이라는 개념부터 알아보면, 

### 의존성이란?

> 어떤 객체 A가 객체 B의 기능 또는 자원에 의존(필요)하고 있을 때, A는 B에 "의존한다"고 말합니다.
> 

저희가 했던 과제중에서 네비게이션이나 다른 객체의 값을 불러오기 위해서 

```swift
final class HomeViewController: BaseUIViewController {
    private let homeService = HomeService() 
}
```

이런식의 코드를 사용했잖아요. 이때 homeviewcontroller는 homeservie에 의존한다 라고 할수 있어요.

homeVC는 homeservice가 있어야지만 원하는 구현을 해낼수 있기 때문이죠. 

이렇게 객체간의 필요에 의해 상호 작용할때 의존성을 바탕으로 협력을 합니다.

책 오브젝트에서는 이런 이야기를 해줍니다

> 의존성은 변경에 의한 영향의 전파 가능성을 암시한다
> 

의존성은 객체간의 협력을 위한 징검다리 역할을 해주지만 때로는 변경의 대한 피해의 여파의 범위로도 해석할수 있습니다.

많은 의존성은 객체를 유연하지 못하게 만들어줍니다. ⇒ 테스트를 위한 유연한 설계가 힘들어지는것이지요.

테스트 상황은 이 객체를 어떤 환경에서, 어떤 조건으로, 무엇을 검증하려는가?"를 말합니다.

**즉 얼마나 쉽게 객체로 들어오는 input을 변경하고, ouput을 쉽게 검증할수 있는가? 가 테스트가 유용한 구조에서의 핵심입니다.** 

그래서 testable한 코드를 만들기 위해 이 의존성을 잘 관리하는게 중요합니다 .

[chapter 8: 의존성 관리하기](https://www.notion.so/chapter-8-02c712290b8d485889d714135ec9b013?pvs=21) 

의존성에 대해 자세히 정리해놓은 과거 스터디 자료 첨부드립니다!

의존성을 잘 관리하는 방법중 의존성을 약하게? 만들어주는 기법인 DI가 등장하게 됩니다.

## 왜 의존성 주입이 필요한가?

---

```swift
final class LoginViewModel {
    private let authService = AuthService() 
}
```

- `LoginViewModel`은 항상 실제 `AuthService`만 사용합니다.
- 테스트할 때 `MockAuthService` 같은 대체 객체를 사용할 수 없습니다.
- `AuthService`의 변경이 `LoginViewModel`에도 영향을 줍니다 이 경우를 강한 결합이라고 합니다.

---

### DI 방식 (좋은 예):

```swift
final class LoginViewModel {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}
```

- 외부에서 어떤 `AuthServiceProtocol` 구현체든 주입 가능합니다.
- `MockAuthService`, `StubAuthService`, `FakeAuthService` 등 다양한 테스트 구현체를 넣을 수 있습니다.
- 코드가 더 유연하고 테스트가 쉬워집니다. ⇒ 경우에 따라 다른 service를 넣고 테스트가 가능해지겠죠?

## Swift에서 의존성 주입 방법 3가지

swift에서 주로 사용하는 의존성 주입방법에 대해 조사했습니다

---

### 1. **생성자 주입(Constructor Injection)**

- 가장 일반적이고 강력한 방식
- 의존성이 없으면 객체를 만들 수 없도록 강제함

```swift
protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws
}

final class AuthService: AuthServiceProtocol {
    func login(email: String, password: String) async throws {
    }
}

final class LoginViewModel {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}
```

```swift
// 사용
let viewModel = LoginViewModel(authService: AuthService())
```

> 테스트 시에는 MockAuthService()를 넘겨주면 됩니다.
> 

---

### 2. **프로퍼티 주입(Property Injection)**

- 객체 생성 후 프로퍼티로 의존성을 주입

```swift
final class LoginViewModel {
    var authService: AuthServiceProtocol! // 주입 전에는 nil
}
```

```swift
let viewModel = LoginViewModel()
viewModel.authService = AuthService()
```

- 유연하지만, 초기화 시점에 의존성이 없을 수 있어 **안정성이 낮습니다**.
- 런타임 에러 가능성 존재 (`nil` 접근 등)

---

### 3. **메서드 주입(Method Injection)**

- 메서드를 호출할 때 의존성을 전달

```swift
final class LoginViewModel {
    func login(email: String, password: String, authService: AuthServiceProtocol) {
        Task {
            try await authService.login(email: email, password: password)
        }
    }
}
```

- 테스트 대상이 되는 메서드 하나에 국한해서 의존성 주입을 적용할 수 있습니다.
- 유연하지만, **반복적이고 일관성 유지가 어렵습니다.**

전 이방법으로 의존성을 관리했어요. 다른 프로젝트에서 VM을 주입해주는 상황에서 DIFactory를 만들어서 의존성 주입 함수를 관리했어요.

```swift
import SoomsilNetwork

final class SearchDIContainer {

    let baseAPIClient: BaseAPIClient

    init(
        baseAPIClient: BaseAPIClient
    ) {
        self.baseAPIClient = baseAPIClient
    }

    private lazy var searchUseCase =
    DefaultSearchUseCase(
        searchRepository: makeSearchRepository()
    )

    // MARK: - ViewModel

    func makeSearchResultListViewModel(controllable: SearchResultListControllable?,
                                       searchResult: SearchResultDTO, searchText: String) -> SearchResultListViewModel {
        return SearchResultListViewModel(controllable: controllable,
                                         searchResult: searchResult,
                                         searchUseCase: searchUseCase,
                                         searchText: searchText)
    }

    func makeSearchDafultViewModel(controllable: SearchDefaultViewControllable?) -> SearchDefaultViewModel {
        return SearchDefaultViewModel(searchUseCase: searchUseCase, controllable: controllable)
    }

    func makeSearchEmptyViewModel(controllable: SearchEmptyViewControllable?,
                                  searchText: String) -> SearchEmptyViewModel {
        return SearchEmptyViewModel(controllable: controllable, searchText: searchText)
    }

    func makeSearchErrorViewModel(controllable: SearchErrorViewControllable?,
                                  searchText: String) -> SearchErrorViewModel {
        return SearchErrorViewModel(controllable: controllable, searchText: searchText)
    }

    // MARK: - Repository
    func makeSearchRepository() -> SearchRepository {
        return DefaultSearchRepository(apiClient: baseAPIClient)
    }

    // MARK: - UseCase
    func makeSearchUseCase() -> SearchUseCase {
        return searchUseCase
    }
}
```

이렇게 주입이 필요한 객체들읠 생성하는 함수들을 모아놓는 객체를 두고 

![스크린샷 2025-05-11 오후 3.41.50.png](3%E1%84%8C%E1%85%AE%E1%84%8E%E1%85%A1%201f0f1d8047c180138128d81f783f508b/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2025-05-11_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.41.50.png)

이런식으로 생성과 함께 주입해줬습니다. 

해당 코드는 coordinator를 사용한 방식의 예입니다!

## DI를 제대로 쓰려면?

---

### 1. **Protocol 기반 설계**

- 의존성 주입의 핵심은 인터페이스(=프로토콜)를 기준으로 코딩하는 것입니다.

```swift
protocol Storage {
    func save(_ data: Data)
    func load() -> Data?
}
```

- 이렇게 추상화해두면,
    - 실제 앱에선 `UserDefaultsStorage` 사용
    - 테스트에선 `MockStorage` 사용 가능

---

### 2. **DI Container (조립기)**

애플리케이션 전체 규모가 커질수록 **의존성 생성을 한 곳에서 관리**하는 DI Container가 유용합니다.

```swift
final class AppDIContainer {
    func makeLoginViewModel() -> LoginViewModel {
        let authService = AuthService()
        return LoginViewModel(authService: authService)
    }
}
```

> 이는 Swinject 등의 DI 라이브러리 없이도 수동 DI로 구현할 수 있는 좋은 방법입니다.
> 

---

## 테스트에서 DI가 주는 이점

```swift
final class MockAuthService: AuthServiceProtocol {
    var loginCalled = false
    func login(email: String, password: String) async throws {
        loginCalled = true
    }
}

```

```swift
func testLoginCalled() async {
    let mockService = MockAuthService()
    let viewModel = LoginViewModel(authService: mockService)

    await viewModel.login(email: "test@test.com", password: "1234")

    XCTAssertTrue(mockService.loginCalled)
}

```

> 테스트를 할 때도 실제 네트워크 요청 없이, 내부 로직만 검증할 수 있게 해줍니다.
>
