//
//  types.swift
//  Redux.swift
//
//  Created by Mark Wise on 11/6/15.
//  Copyright © 2015 InstaJams. All rights reserved.
//

import Foundation

public typealias ActionCreator = (args: Any...) -> ReduxAction;
public typealias ActionType = String
public typealias ReduxAppState = KeyValueEqutable
public typealias DispatchFunction = (action: ReduxAction) -> ReduxAction;
public typealias FunctionWithArgs = (args: Any...) -> Void;
public typealias Listener = () -> Void;
public typealias Reducer = (previousState: Any, action: ReduxAction) -> Any;
public typealias ReduxState = AnyEquatable;

public protocol AnyEquatable {
    func equals(otherObject: AnyEquatable) -> Bool
}

public extension AnyEquatable where Self: Equatable {
    // otherObject could also be 'Any'
    func equals(otherObject: AnyEquatable) -> Bool {
        if let otherAsSelf = otherObject as? Self {
            return otherAsSelf == self
        }
        return false
    }
}

public protocol KeyValueEqutable {
    func get(key: String) -> AnyEquatable?
    mutating func set(key: String, value: AnyEquatable)
}

public enum ActionTypes : ReduxActionType {
    case Init
}

public protocol ReduxActionType {}

public struct ReduxAction {
    public var payload: ReduxActionType

    public init(payload: ReduxActionType) {
        self.payload = payload;
    }
}

public class ReduxStore {
    public let dispatch: DispatchFunction
    public let getState: () -> ReduxState
    public let replaceReducer: (nextReducer: Reducer) -> Void
    public let subscribe: (listener: Listener) -> () -> Void

    public init(dispatch: DispatchFunction, getState: () -> ReduxState, replaceReducer: (nextReducer: Reducer) -> Void, subscribe: (listener: Listener) -> () -> Void) {
        self.dispatch = dispatch
        self.getState = getState
        self.replaceReducer = replaceReducer
        self.subscribe = subscribe
    }
}


public extension ReduxStore {
    
    func getAppState() -> ReduxAppState {
        return getState() as! ReduxAppState
    }
    
}


public enum ReduxSwiftError: ErrorType {
    case ReducerDispatchError
}
