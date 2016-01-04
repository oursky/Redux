//
//  StoreConnectorTests.swift
//  SwiftRedux
//
//  Created by Steven Chan on 30/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Redux
import UIKit

class MockViewController: UIViewController, StoreDelegate {

    var countLabelText: Int = 0
    var listData: [String] = [String]()

    var countChangeCount: Int = 0

    let store: ReduxStore
    init(store: ReduxStore) {
        self.store = store
        super.init(nibName: "", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        Swift.fatalError("init(coder:) has not been implemented")
    }

    func connectRedux(store: ReduxStore, keys: [String]) {
        connect(store, keys: keys, delegate: self)
    }

    func disconnectRedux(store: ReduxStore) {
        disconnect(store)
    }

    func storeDidUpdateState(lastState: ReduxAppState) {
        let lastCountState = lastState.get("count") as! CounterState

        countLabelText = store.getCountState()!.count
        listData = store.getListState()!.list

        if lastCountState.count != store.getCountState()!.count {
            countChangeCount++
        }
    }

}



class StoreConnectorTests: XCTestCase {

    var viewController: MockViewController?
    var store: ReduxStore?

    override func setUp() {
        super.setUp()
        store = Store.configureStore()
        viewController = MockViewController(store: store!)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPositivePartialConnect() {
        viewController?.connectRedux(store!, keys: [ "count" ])

        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Decrement))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 3)
        XCTAssert((viewController?.listData)! == [String]())
    }

    func testNegativePartialConnect() {
        viewController?.connectRedux(store!, keys: [ "count" ])

        store?.dispatch(action: ReduxAction(payload: ListAction.Append("hi")))
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))

        XCTAssert(viewController?.countLabelText == 0)
        XCTAssert(viewController?.countChangeCount == 0)
        XCTAssert((viewController?.listData)! == [String]())
    }

    func testAnotherNegativePartialConnect() {
        viewController?.connectRedux(store!, keys: [ "list" ])

        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))

        XCTAssert(viewController?.countLabelText == 0)
        XCTAssert(viewController?.countChangeCount == 0)
        XCTAssert((viewController?.listData)! == [ "wah" ])
    }

    func testCombineConnect() {
        viewController?.connectRedux(store!, keys: [ "list", "count" ])

        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 1)
        XCTAssert((viewController?.listData)! == [ "wah" ])
    }

    func testDisconnect() {

        viewController?.connectRedux(store!, keys: [ "list", "count" ])

        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 1)
        XCTAssert((viewController?.listData)! == [ "wah" ])

        viewController?.disconnect(store!)

        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 1)
        XCTAssert((viewController?.listData)! == [ "wah" ])
    }

}
