//
//  ReducerTests.swift
//  SwiftRedux
//
//  Created by Steven Chan on 30/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
@testable import Redux

class ReducerTests: XCTestCase {
    
    var counterInitialState: CounterState?
    var listInitialState: ListState?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        counterInitialState = CounterState(count: 0)
        listInitialState = ListState(list: [String]())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleReducer() {
        var nextState: Any = counterInitialState!
        nextState = counterReducer(nextState, action: ReduxAction(payload: CounterAction.Increment))
        nextState = counterReducer(nextState, action: ReduxAction(payload: CounterAction.Decrement))
        nextState = counterReducer(nextState, action: ReduxAction(payload: CounterAction.Increment))
        
        let counterState: CounterState = nextState as! CounterState
        
        XCTAssert(counterState != counterInitialState)
        XCTAssert(counterState.count == 1)
        XCTAssert(counterInitialState!.count == 0)
    }
    
    func testCombineReducer() {
        
        let reducers: [String: Reducer] = [
            "count": counterReducer,
            "list": listReducer
        ]
        
        let reducer: Reducer = combineReducers(reducers)
        
        let initialState = CombineState(
            count: CounterState(count: 0),
            list: ListState(list: [String]())
        )
        
        var nextState: Any = initialState
        
        nextState = reducer(previousState: nextState, action: ReduxAction(payload: CounterAction.Increment))
        
        var counterState: CounterState = (nextState as! CombineState).get("count") as! CounterState
        var listState: ListState = (nextState as! CombineState).get("list") as! ListState
        
        XCTAssert(counterState.count == 1)
        XCTAssert(listState.list == [String]())
        
        nextState = reducer(previousState: nextState, action: ReduxAction(payload: CounterAction.Decrement))
        nextState = reducer(previousState: nextState, action: ReduxAction(payload: ListAction.Append("Hi")))
        nextState = reducer(previousState: nextState, action: ReduxAction(payload: ListAction.Append("Bye")))
        
        counterState = (nextState as! CombineState).get("count") as! CounterState
        listState = (nextState as! CombineState).get("list") as! ListState
        
        let oldListState = listState
        
        XCTAssert(counterState.count == 0)
        XCTAssert(listState.list == [ "Hi", "Bye" ])
        XCTAssert(listState.list != [ "Hi", "Bye", "Oh what?" ])
        
        nextState = reducer(previousState: nextState, action: ReduxAction(payload: ListAction.Remove))
        nextState = reducer(previousState: nextState, action: ReduxAction(payload: ListAction.Remove))
        
        counterState = (nextState as! CombineState).get("count") as! CounterState
        listState = (nextState as! CombineState).get("list") as! ListState
        
        XCTAssert(counterState.count == 0)
        XCTAssert(listState.list == [String]())
        
        XCTAssert(oldListState.list == [ "Hi", "Bye" ])
    }
    
}
