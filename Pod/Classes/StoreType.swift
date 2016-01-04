//
//  StoreType.swift
//  Pods
//
//  Created by Steven Chan on 30/12/15.
//
//

public protocol StoreType {
    static var appStore: ReduxStore { get }

    static func configureStore() -> ReduxStore
}

private struct StoreContainer {
    static var store: ReduxStore?
}

public extension StoreType {
    static var appStore: ReduxStore {

        if StoreContainer.store == nil {
            StoreContainer.store = configureStore()
        }

        return StoreContainer.store!
    }
}
