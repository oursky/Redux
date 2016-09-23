//
//  createStore.swift
//  Redux.swift
//
//  Created by Mark Wise on 11/4/15.
//  Copyright © 2015 InstaJams. All rights reserved.
//

import Foundation

public func createStore(
    _ reducer: @escaping Reducer,
    initialState: AnyEquatable
) -> ReduxStore {
    var currentReducer = reducer
    var currentState = initialState
    var listeners = [UUID: Listener]()
    var isDispatching = false

    func getState() -> ReduxState {
        return currentState
    }

    func subscribe(_ listener: @escaping Listener) -> () -> Void {
        let uuid = UUID()
        listeners[uuid] = listener
        var isSubscribed = true

        func unsubscribe() {
            if !isSubscribed {
                return
            }

            isSubscribed = false
            _ = listeners.removeValue(forKey: uuid)
        }
        return unsubscribe
    }

    
    func dispatch(_ action: ReduxAction) -> ReduxAction {
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
            currentState,
            action
        )
        if let ns = nextState as? AnyEquatable {
            currentState = ns
        }

        for listener in listeners.values {
            listener()
        }

        return action
    }

    func replaceReducer(_ nextReducer: @escaping Reducer) -> Void {
        currentReducer = nextReducer

        dispatch(ReduxAction(payload: ActionTypes.init as! ReduxActionType))
    }

    dispatch(ReduxAction(payload: ActionTypes.init as! ReduxActionType))

    return ReduxStore(
        dispatch: dispatch,
        getState: getState,
        replaceReducer: replaceReducer,
        subscribe: subscribe
    )
}
