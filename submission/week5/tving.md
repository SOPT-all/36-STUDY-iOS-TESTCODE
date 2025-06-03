## 🚨 주요 코드 리뷰 포인트
### 여러분은 어떻게 구현하셨나요?
- 심화과제 : “김가현PD의 인생작 TOP5” 에서 이미지가 좌우로 이동하면 우측의 동그라미 점들도 해당 index 만큼 이동

<br>

## 📄 작업 내용
- 기존 Tving 앱 메인 화면을 SwiftUI로 재구성
- "김가현의 인생작 Top5"에 페이징 적용
- 메뉴 선택에 따른 뷰 이동 구현

|    구현 내용    |   GIF   |    구현 내용    |   GIF   |
| :-------------: | :----------: | :-------------: | :----------: |
| 메인 화면 | <img src = "https://github.com/user-attachments/assets/03bfcf52-e10e-40ac-b317-3d47beb8a304" width ="250"> | 페이징 구현 | <img src = "https://github.com/user-attachments/assets/93c60fb8-3bcb-4a2a-b63b-fb9cb9e8816c" width ="250"> |
| 메뉴 선택에 따른 뷰 이동 | <img src = "https://github.com/user-attachments/assets/055947b9-2968-4408-8851-e6187dda9703" width ="250"> |  |  |

<br>

## 💻 주요 코드 설명
### 페이징 구현

- PageControl 구현 : 페이지 수와 현재 페이지를 표시하는 PageControl을 구현했습니다

<details>
<summary>PageControl</summary>

```swift
struct PageControl: View {
    
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfPages, id: \.self) { pagingIndex in
                
                let isCurrentPage = currentPage == pagingIndex
                let height = 4.0
                let width = height
                
                Circle()
                    .fill(isCurrentPage ? .cGray2 : .white)
                    .frame(width: width, height: height)
            }
        }
        .animation(.linear, value: currentPage)
    }
}
```
</details>

- 뷰 적용 : 인덱스를 계산해서 페이징을 적용하였는데요, 저는 맨 끝 이미지로 이동하면 페이징이 제대로 안 되는 문제가 발생하더라고요. 다른 분들은 페이징을 어떻게 해결 및 구현하셨는지 궁금합니다!

<details>
<summary>NewMasterPiecesView</summary>

```swift
GeometryReader { scrollViewGeo in
  ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 10) {
            ForEach(pieces.indices, id: \.self) { index in
                GeometryReader { itemGeo in
                    let itemCenter = itemGeo.frame(in: .global).midX
                    let scrollCenter = scrollViewGeo.frame(in: .global).midX
                    let distance = abs(scrollCenter - itemCenter)
                    
                    Color.clear
                        .onChange(of: distance) {
                            if distance < 85 {
                                selection = index
                            }
                        }
                }
                .frame(width: 160, height: 90)
                .background(
                    Image(pieces[index].image)
                        .resizable()
                        .cornerRadius(3)
                )
            }
        }
        .padding(.leading, 10)
    }
}
.frame(height: 90)
}
```
</details>

### 메뉴 선택에 따른 뷰 이동 구현

- @Binding과 @State를 활용해서 몇 번 인덱스의 메뉴를 선택했는지 파악하고, switch문에서 인덱스에 해당하는 뷰로 이동하도록 설계했습니다.

<details>
<summary>NewMenuView</summary>

```swift
import SwiftUI

struct NewMenuView: View {
    let menus = ["홈", "드라마", "예능", "영화", "스포츠", "뉴스"]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(menus.indices, id: \.self) { index in
                makeMenu(menus[index], isSelected: index == selectedIndex)
                    .onTapGesture {
                        selectedIndex = index
                        //self.font = .customSemiBold(ofSize: 17)
                    }
            }
        }
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
        .background(.black)
    }
    
    private func makeMenu(_ title: String, isSelected: Bool) -> some View {
        return Text(title)
            .foregroundStyle(.white)
            .font(isSelected ? .customBlack(ofSize: 17) : .customSemiBold(ofSize: 17))
    }
}

```
</details>

<details>
<summary>NewMenuView</summary>

```swift
import SwiftUI

struct ContentView: View {
    @State var selectedMenuIndex: Int = 0
    
    var body: some View {
        VStack {
            NewHeaderView()
            NewMenuView(selectedIndex: $selectedMenuIndex)
            
            switch selectedMenuIndex {
            case 0:
                HomeView()
            case 1:
                DramaView()
            case 2:
                EntertainmentView()
            case 3:
                MovieView()
            case 4:
                SportView()
            case 5:
                NewsView()
            default:
                Text("Other")
            }
            
        }
        .background(.black)
    }
}

```
</details>
