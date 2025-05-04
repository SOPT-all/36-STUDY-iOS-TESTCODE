테스트코드 - 해당 코드가 의도하는대로, 오류없이 잘 동작하는지 확인하기위한 코드

## GWT 패턴이란?(Given - When - Then)

Given(준비) 

주어진 이란 뜻으로 테스트를 위한 초기상황 또는 변수,객체 등을 설정하는 부분

→ 테스트 환경을 준비하는 단계 

When(언제?) 

실제로 테스트 하려는 기능, 메서드 등의 테스트를 실행하는 단계

Then(그래서?) 

실행을 검증하는 단계로 예상결과가 실제와 일치하는지 확인하는 단계  


 ### Almofire Test Code 예시

```
func testDownloadRequestWithProgress() {
        
        //Given
        let randomBytes = 1 * 1024 * 1024
        let urlString = "https://httpbin.org/bytes/\(randomBytes)"
        
        let expectation = self.expectation(description: "Bytes download progress should be reported: \(urlString)")
        
        var progressValues: [Double] = []
        var response:DownloadResponse<URL?>?
        
        //When
        AF.download(urlString)
            .downloadProgress { progress in
                progressValues.append(progress.fractionCompleted)
            }
            .response { resp in
                response = resp
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        //Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.fileURL)
        XCTAssertNil(response?.resumeData)
        XCTAssertNil(response?.error)
    }

```


Given - https 통신이 잘 되는지 확인하기 위한 url 주소, bytes 값, Values 등을 선언해줌

When - [AF.download](http://AF.download) 로 위에서 선언해준 주소, bytes 값 등을 이용하여 테스트를 위한 동작을 실행시켜준다.

Then - XCTAssert 함수들을 이용하여 위에 when 이 실행될때 값들이 예상대로 잘 나왔는지 확인해준다.

위의 함수에서는 XCTAssertNotNil - nil 이 아니면 통과(true) 로 request 값이 nil 인지 아니면 잘 들어오는지 검사하기위해 사용해줌


## AAA - Assignment,Act,Assert)

Assignment (준비)

테스트 코드 실행전 필요한 객체, 함수 등 생성

Act (실행)

테스트 코드 실행

ASSERT (단언 )

실행한 코드 동작 확인, 반환값 검사

GWT - AAA 는 용어만 다르고 개념은 똑같은 것 같음! 

## Test Assertions / Boolen Assertions

소프트웨어 테스트에서 특정조건이 참인지 거짓인지 검증하는 구문 

미리 참일지 거짓일지 확정하고, 해당 값이 나오는지 확인해서 검증을 진행한다.

간단한 예시로 5 + 3 의 결과값이 8이 잘 나오는지 대한 테스트를 진행해본다고 가정해보자.



```
func testAddition() {
    // Given
    let a = 5
    let b = 3
    
    // When
    let result = a + b
    
    // Then
    XCTAssertEqual(result, 8, "5 + 3 should equal 8")
}
```
여기서 처음 5 + 3 은 8이 나온다!! 라고 가정을 하고, 검증을 통해서 진짜 8 이 나오면 통과, 만약 그렇지 않으면 테스트가 실패한다.

```
func testAdditionIsTrueStatement() {
    // Given
    let a = 5
    let b = 3
    
    // When
    let statement = (a + b == 8)
    
    // Then
    XCTAssertTrue(statement, "The statement '5 + 3 = 8' should be true")
}
```


관점을 달리해서 5 + 3 = 8 인 수식 자체가 true 인지를 검증하는 코드를 작성할 수 도 있다.
위의 testAddition 코드는 5 + 3 의 결과값이 뭐지? 에 대한 값에 대한 검증을 진행하고,
아래의 testAdditionIsTrueStatement 코드는 5 + 3 = 8 의 수식이 참인가에 대한 검증을 진행한 코드인것이다.
이처럼 테스트는 하나의 구문에 대해서도 개발자의 의도, 테스트를 하는 부분, 다양한 상황에 대한 시나리오에 따라 수많은 테스트 케이스를 만들고, 실행해 볼 수 있다.
앱에서는 다양한 변수와 상황이 발생할 수도 있다. 이러한 다양한 상황을 고려하고 그에 대한 대비를 하는것은 개발자의 역량이라고 할 수 있다.

그리고 모든 상황에서 한번씩 테스트가 진행될 수 있도록 분기 커버리지가 필요하다.
if - else 구문에서 만약 테스트케이스가 모두 if 문에만 해당되는 상황이라면, else 조건이 실행되었을때 제대로 분기를 타는지, 분기를 탔을때 해당 함수가 제대로 작동하는지 검증이 되지 않은 채 출시될 수 있다!!


```
func processValue(_ value: Int) -> String {
    if value > 0 {
        return "Positive"
    } else {
        return "Zero or Negative"
    }
}

```

값이 0보다 크면 Positive , 작으면 Zero or Negative 라는 함수가 제대로 동작하는지 검증하기 위해서는 

1. Value 가 0 보다 큰 값을 넣어서 잘 작동하는가?
2. 작은 값을 넣어서 잘 작동하는가 
3. 0 일 경우에는 어떻게 작동하는가? → 경계값 테스트  가 필요할 것이다.

```
func testProcessValuePositive() {
    //Given
    let number = 5

    //When
    let result = processValue(number)

    //Then
    XCTAssertEqual(result, "Positive")
}

func testProcessValueNegative() {
    //Given
    let number = -3

    //When
    let result = processValue(number)

    //Then
    XCTAssertEqual(result, "Zero or Negative")
}

func testProcessValueZero() {
    //Given
    let number = 0

    //When
    let result = processValue(number)

    //Then
    XCTAssertEqual(result, "Zero or Negative")
}
```

이렇게 3가지를 할 수 있지만, 경우에 따라서는 모든 구문이 한번씩 무조건 실행되도록 설계를 할수도 있고, 여러가지 방법으로 테스트를 할 수 있다.

## xcode 에서 자주 사용되는 assertion 함수들 

| 함수 | 설명 |
| --- | --- |
| XCTAssertEqual | 두값 같은지 확인 |
| XCTAssertNotEqual | 두값 다른지 확인 |
| XCTAssertTrue | 표현식 true 인지 확인 |
| XCTAssertFalse | 표현식 false 인지 확인 |
| XCTAssertNil | 값이 nil 인지 확인 |
| XCTAssertNotNil | 값이 nil이 아닌지 확인 |
| XCTAssertGreaterThan | 첫번째 값 > 두번째값 인지 확인 |
| XCTAssertGreaterThanOrEqual | 첫번재값 >= 두번째값 인지 확인  |
| XCTAssertThrowsError | 에러 발생시키는지 확인 |
| XCTAssertNoThrow | 에러 발생시키지 않는지 확인 |



