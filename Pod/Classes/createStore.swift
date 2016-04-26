//
//  createStore.swift
//  Redux.swift
//
//  Created by Mark Wise on 11/4/15.
//  Copyright © 2015 InstaJams. All rights reserved.
//

import Foundation

public func createStore(
    reducer: Reducer,
    initialState: AnyEquatable
) -> ReduxStore {
    var currentReducer = reducer
    var currentState = initialState
    var listeners = [NSUUID: Listener]()
    var isDispatching = false

    func getState() -> ReduxState {
        return currentState
    }

    func subscribe(listener: Listener) -> () -> Void {
        let uuid = NSUUID()
        listeners[uuid] = listener
        var isSubscribed = true

        func unsubscribe() {
            if !isSubscribed {
                return
            }

            isSubscribed = false
            _ = listeners.removeValueForKey(uuid)
        }
        return unsubscribe
    }

    func dispatch(action: ReduxAction) -> ReduxAction {
        if isDispatching {
            /*
                Using fatalError you do not need try/catch in every dispatch.
            */
            fatalError("Cannot dispatch in a middle of dispatch")
        }

        defer {
            isDispatching = false
        }

        isDispatching = true
        let nextState = currentReducer(
            previousState: currentState,
            action: action
        )
        if let ns = nextState as? AnyEquatable {
            currentState = ns
        }

        for listener in listeners.values {
            listener()
        }

        return action
    }

    func replaceReducer(nextReducer: Reducer) -> Void {
        currentReducer = nextReducer

        dispatch(ReduxAction(payload: ActionTypes.Init))
    }

    dispatch(ReduxAction(payload: ActionTypes.Init))

    return ReduxStore(
        dispatch: dispatch,
        getState: getState,
        replaceReducer: replaceReducer,
        subscribe: subscribe
    )
}
