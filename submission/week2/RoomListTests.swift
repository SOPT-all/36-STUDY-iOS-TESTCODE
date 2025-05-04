import XCTest
@testable import TestCodeStudy

final class RoomListTests: XCTestCase {

    func testIsAppropriateNumberOfParticipant() {
        // given
        let item = RoomListItem.testRoomListItem
        
        // when
        let result = item.isOverCapacity(capacity: 10)
        
        // then
        XCTAssert(result, "적정 수의 인원입니다")
    }

    func testIsSameTitle() {
        // given
        let item = RoomListItem.testRoomListItem
        
        // when
        let result = item.isSameTitle(title: "테스트타이틀")
        
        // then
        XCTAssertTrue(result, "같은 타이틀입니다")
    }
    
    func testIsNotAvailableDate() {
        // given
        let item = RoomListItem.testRoomListItem
        
        // when
        let result = item.isAvailableDate(date: "2023.01.07")
        
        // then
        XCTAssertFalse(result, "기간에서 벗어난 날짜입니다")
    }
}
