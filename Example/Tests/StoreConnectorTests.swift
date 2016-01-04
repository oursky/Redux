//
//  UIViewControllerReduxTests.swift
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func connectRedux(store: ReduxStore, keys: [String]) {
        connect(store, keys: keys, delegate: self)
    }
    
    func disconnectRedux(store: ReduxStore) {
        disconnect(store)
    }
    
    func storeDidUpdateState(lastState: ReduxAppState) {
        let lastCountState = lastState.get("count") as! CounterState
        
        countLabelText = store.getCountState().count
        listData = store.getListState().list
        
        if (lastCountState.count != store.getCountState().count) {
            countChangeCount++
        }
    }

}



class UIViewControllerReduxTests: XCTestCase {
    
    var vc: MockViewController?
    var store: ReduxStore?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        store = Store.configureStore()
        vc = MockViewController(store: store!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPositivePartialConnect() {
        vc?.connectRedux(store!, keys: [ "count" ])
        
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Decrement))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        
        XCTAssert(vc?.countLabelText == 1)
        XCTAssert(vc?.countChangeCount == 3)
        XCTAssert((vc?.listData)! == [String]())
    }
    
    func testNegativePartialConnect() {
        vc?.connectRedux(store!, keys: [ "count" ])
        
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("hi")))
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        
        XCTAssert(vc?.countLabelText == 0)
        XCTAssert(vc?.countChangeCount == 0)
        XCTAssert((vc?.listData)! == [String]())
    }
    
    func testAnotherNegativePartialConnect() {
        vc?.connectRedux(store!, keys: [ "list" ])
        
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        
        XCTAssert(vc?.countLabelText == 0)
        XCTAssert(vc?.countChangeCount == 0)
        XCTAssert((vc?.listData)! == [ "wah" ])
    }
    
    func testCombineConnect() {
        vc?.connectRedux(store!, keys: [ "list", "count" ])
        
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        
        XCTAssert(vc?.countLabelText == 1)
        XCTAssert(vc?.countChangeCount == 1)
        XCTAssert((vc?.listData)! == [ "wah" ])
    }
    
    func testDisconnect() {
        
        vc?.connectRedux(store!, keys: [ "list", "count" ])
        
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        
        XCTAssert(vc?.countLabelText == 1)
        XCTAssert(vc?.countChangeCount == 1)
        XCTAssert((vc?.listData)! == [ "wah" ])
        
        vc?.disconnect(store!)
        
        store?.dispatch(action: ReduxAction(payload: ListAction.Append("wah")))
        store?.dispatch(action: ReduxAction(payload: CounterAction.Increment))
        
        XCTAssert(vc?.countLabelText == 1)
        XCTAssert(vc?.countChangeCount == 1)
        XCTAssert((vc?.listData)! == [ "wah" ])
    }
    
}
