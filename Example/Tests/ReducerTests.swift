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

        counterInitialState = CounterState(count: 0)
        listInitialState = ListState(list: [String]())
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSingleReducer() {
        var nextState: Any = counterInitialState!
        nextState = counterReducer(
            nextState,
            action: ReduxAction(payload: CounterAction.increment)
        )
        nextState = counterReducer(
            nextState,
            action: ReduxAction(payload: CounterAction.decrement)
        )
        nextState = counterReducer(
            nextState,
            action: ReduxAction(payload: CounterAction.increment)
        )

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

        nextState = reducer(
            nextState,
            ReduxAction(payload: CounterAction.increment)
        )

        var counterState: CounterState =
            (nextState as! CombineState).get("count") as! CounterState
        var listState: ListState =
            (nextState as! CombineState).get("list") as! ListState

        XCTAssert(counterState.count == 1)
        XCTAssert(listState.list == [String]())

        nextState = reducer(
            nextState,
            ReduxAction(payload: CounterAction.decrement)
        )
        nextState = reducer(
            nextState,
            ReduxAction(payload: ListAction.append("Hi"))
        )
        nextState = reducer(
            nextState,
            ReduxAction(payload: ListAction.append("Bye"))
        )

        counterState =
            (nextState as! CombineState).get("count") as! CounterState
        listState =
            (nextState as! CombineState).get("list") as! ListState

        let oldListState = listState

        XCTAssert(counterState.count == 0)
        XCTAssert(listState.list == [ "Hi", "Bye" ])
        XCTAssert(listState.list != [ "Hi", "Bye", "Oh what?" ])

        nextState = reducer(
            nextState,
            ReduxAction(payload: ListAction.remove)
        )
        nextState = reducer(
            nextState,
            ReduxAction(payload: ListAction.remove)
        )

        counterState =
            (nextState as! CombineState).get("count") as! CounterState
        listState =
            (nextState as! CombineState).get("list") as! ListState

        XCTAssert(counterState.count == 0)
        XCTAssert(listState.list == [String]())

        XCTAssert(oldListState.list == [ "Hi", "Bye" ])
    }

}
