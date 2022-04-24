import XCTest
@testable import DebouncedOnChange

final class DelayedTaskTest: XCTestCase {
    func testTaskExecutesAfterDelay() throws {
        let positiveExpectation = expectation(description: "Delayed task finished in time")
        let negativeExpectation = expectation(description: "Delayed task finished too early")
        negativeExpectation.isInverted = true

        Task.delayed(seconds: 0.2) {
            positiveExpectation.fulfill()
            negativeExpectation.fulfill()
        }

        wait(for: [negativeExpectation], timeout: 0.1)
        wait(for: [positiveExpectation], timeout: 0.15)
    }
}
