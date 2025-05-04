struct RoomListItem {
    let id: Int
    let title: String
    let participatingCount: Int?
    let capacity: Int
    let startDate: String
    let endDate: String
}

extension RoomListItem {
    func isOverCapacity(capacity: Int) -> Bool {
        return self.capacity < capacity
    }
    
    func isSameTitle(title: String) -> Bool {
        return self.title == title
    }
    
    func isAvailableDate(date: String) -> Bool {
        return self.startDate <= date && self.endDate >= date
    }
}

extension RoomListItem: Equatable {
    static let testRoomListItem = RoomListItem(
        id: 1,
        title: "테스트타이틀",
        participatingCount: 5,
        capacity: 5,
        startDate: "2023.01.01",
        endDate: "2023.01.05"
    )
}
