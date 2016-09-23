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
        store?.dispatch(ReduxAction(payload: CounterAction.increment))
        store?.dispatch(ReduxAction(payload: ListAction.append("hi")))

        XCTAssert(store?.getCountState()!.count == 1)
        XCTAssert((store?.getListState()!.list)! == [ "hi" ])
        XCTAssert((store?.getListState()!.list)! != [ "bye" ])
    }

    func testDispatchWithinDispatch() {
        expectFatalError {
            self.store?.dispatch(
                ReduxAction(
                    payload: CounterAction.dispatchWithinDispatch(self.store!)
                )
            )
        }
    }

    func testSubcribe() {
        let expectation = self.expectation(description: "subscribed action")

        var result: [[String]] = [[String]]()

        func render() {
            result.append((store?.getListState()!.list)!)

            if result.count == 2 {
                XCTAssert(result[0] == [ "Now" ])
                XCTAssert(result[1] == [ "Now", "You see me" ])
                expectation.fulfill()
            }
        }

        let unsubscribe = store?.subscribe(render)

        store?.dispatch(
            ReduxAction(payload: ListAction.append("Now"))
        )
        store?.dispatch(
            ReduxAction(payload: ListAction.append("You see me"))
        )

        unsubscribe!()

        store?.dispatch(
            ReduxAction(payload: ListAction.append("Now you don't"))
        )

        self.waitForExpectations(timeout: 0.5) { (error) -> Void in
            XCTAssert(result.count == 2)
        }
    }

}
