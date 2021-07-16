//
//  types.swift
//  Redux.swift
//
//  Created by Mark Wise on 11/6/15.
//  Copyright © 2015 InstaJams. All rights reserved.
//

import Foundation

public typealias ActionCreator = (_ args: Any...) -> ReduxAction
public typealias ActionType = String
public typealias ReduxAppState = KeyValueEqutable
public typealias DispatchFunction = (_ action: ReduxAction) -> Void
public typealias FunctionWithArgs = (_ args: Any...) -> Void
public typealias Listener = () -> Void
public typealias Reducer = (_ previousState: Any, _ action: ReduxAction) -> Any
public typealias ReduxState = AnyEquatable

public protocol AnyEquatable {
    func equals(_ otherObject: AnyEquatable) -> Bool
}

public extension AnyEquatable where Self: Equatable {
    // otherObject could also be 'Any'
    func equals(_ otherObject: AnyEquatable) -> Bool {
        if let otherAsSelf = otherObject as? Self {
            return otherAsSelf == self
        }
        return false
    }
}

public protocol KeyValueEqutable {
    func get(_ key: String) -> AnyEquatable?
    mutating func set(_ key: String, value: AnyEquatable)
}

public enum ActionTypes: ReduxActionType {
    case `init`
}

public protocol ReduxActionType {}

public struct ReduxAction {
    public var payload: ReduxActionType

    public init(payload: ReduxActionType) {
        self.payload = payload
    }
}

open class ReduxStore {
    public let dispatch: DispatchFunction
    public let getState: () -> ReduxState
    public let replaceReducer: (_ nextReducer: @escaping Reducer) -> Void
    public let subscribe: (_ listener: @escaping Listener) -> () -> Void

    public init(
        dispatch: @escaping DispatchFunction,
        getState: @escaping () -> ReduxState,
        replaceReducer: @escaping (_ nextReducer: @escaping Reducer) -> Void,
        subscribe: @escaping (_ listener: @escaping Listener) -> () -> Void
    ) {
        self.dispatch = dispatch
        self.getState = getState
        self.replaceReducer = replaceReducer
        self.subscribe = subscribe
    }
}


public extension ReduxStore {
    func getAppState() -> ReduxAppState? {
        return getState() as? ReduxAppState
    }
}


public enum ReduxSwiftError: Error {
    case reducerDispatchError
}
