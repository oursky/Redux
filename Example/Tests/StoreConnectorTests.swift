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

    func connectRedux(_ store: ReduxStore, keys: [String]) {
        connect(store, keys: keys, delegate: self)
    }

    func disconnectRedux(_ store: ReduxStore) {
        disconnect(store)
    }

    func storeDidUpdateState(_ lastState: ReduxAppState) {
        let lastCountState = lastState.get("count") as! CounterState

        countLabelText = store.getCountState()!.count
        listData = store.getListState()!.list

        if lastCountState.count != store.getCountState()!.count {
            countChangeCount += 1
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

        store?.dispatch(ReduxAction(payload: CounterAction.increment))
        store?.dispatch(ReduxAction(payload: CounterAction.decrement))
        store?.dispatch(ReduxAction(payload: CounterAction.increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 3)
        XCTAssert((viewController?.listData)! == [String]())
    }

    func testNegativePartialConnect() {
        viewController?.connectRedux(store!, keys: [ "count" ])

        store?.dispatch(ReduxAction(payload: ListAction.append("hi")))
        store?.dispatch(ReduxAction(payload: ListAction.append("wah")))

        XCTAssert(viewController?.countLabelText == 0)
        XCTAssert(viewController?.countChangeCount == 0)
        XCTAssert((viewController?.listData)! == [String]())
    }

    func testAnotherNegativePartialConnect() {
        viewController?.connectRedux(store!, keys: [ "list" ])

        store?.dispatch(ReduxAction(payload: ListAction.append("wah")))
        store?.dispatch(ReduxAction(payload: CounterAction.increment))

        XCTAssert(viewController?.countLabelText == 0)
        XCTAssert(viewController?.countChangeCount == 0)
        XCTAssert((viewController?.listData)! == [ "wah" ])
    }

    func testCombineConnect() {
        viewController?.connectRedux(store!, keys: [ "list", "count" ])

        store?.dispatch(ReduxAction(payload: ListAction.append("wah")))
        store?.dispatch(ReduxAction(payload: CounterAction.increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 1)
        XCTAssert((viewController?.listData)! == [ "wah" ])
    }

    func testDisconnect() {

        viewController?.connectRedux(store!, keys: [ "list", "count" ])

        store?.dispatch(ReduxAction(payload: ListAction.append("wah")))
        store?.dispatch(ReduxAction(payload: CounterAction.increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 1)
        XCTAssert((viewController?.listData)! == [ "wah" ])

        viewController?.disconnect(store!)

        store?.dispatch(ReduxAction(payload: ListAction.append("wah")))
        store?.dispatch(ReduxAction(payload: CounterAction.increment))

        XCTAssert(viewController?.countLabelText == 1)
        XCTAssert(viewController?.countChangeCount == 1)
        XCTAssert((viewController?.listData)! == [ "wah" ])
    }

}
