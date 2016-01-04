//
//  StoreTests.swift
//  SwiftRedux
//
//  Created by Steven Chan on 30/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Redux


class StoreTests: XCTestCase {

    var store: ReduxStore?

    override func setUp() {
        super.setUp()
        store = Store.configureStore()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetState() {
        XCTAssert(store?.getCountState() == CounterState(count: 0))
        XCTAssert(store?.getListState() == ListState(list: [String]()))
    }

    func testDispatch() {
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("hi")))

        XCTAssert(store?.getCountState()!.count == 1)
        XCTAssert((store?.getListState()!.list)! == [ "hi" ])
        XCTAssert((store?.getListState()!.list)! != [ "bye" ])
    }

    func testDispatchWithinDispatch() {
        expectFatalError {
            self.store?.dispatch(
                action: ReduxAction(
                    payload: CounterAction.DispatchWithinDispatch(self.store!)
                )
            )
        }
    }

    func testSubcribe() {
        let expectation = self.expectationWithDescription("subscribed action")

        var result: [[String]] = [[String]]()

        func render() {
            result.append((store?.getListState()!.list)!)

            if result.count == 2 {
                XCTAssert(result == [ [ "Now" ], [ "Now", "You see me" ] ])
                expectation.fulfill()
            }
        }

        let unsubscribe = store?.subscribe(listener: render)

        store?.dispatch(
            action: ReduxAction(payload: ListAction.Append("Now"))
        )
        store?.dispatch(
            action: ReduxAction(payload: ListAction.Append("You see me"))
        )

        unsubscribe!()

        store?.dispatch(
            action: ReduxAction(payload: ListAction.Append("Now you don't"))
        )

        self.waitForExpectationsWithTimeout(0.5) { (error) -> Void in
            XCTAssert(result.count == 2)
        }
    }

}
