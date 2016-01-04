//
//  StoreConnector.swift
//  Pods
//
//  Created by Steven Chan on 30/12/15.
//
//

import UIKit

public protocol StoreDelegate {
    
    func storeDidUpdateState(lastState: ReduxAppState)

}

public class StoreConnector {
    
    typealias Disconnect = () -> Void
    
    var connections: [Int: Disconnect] = [Int: Disconnect]()
    
    func connect(store: ReduxStore, keys: [String], delegate: StoreDelegate) {
        let address: Int = unsafeBitCast(store, Int.self)
        
        var lastState: ReduxAppState?
        if let storeState = store.getState() as? ReduxAppState {
            lastState = storeState
        }
        
        connections[address] = store.subscribe {
            if let storeState = store.getState() as? ReduxAppState {
                
                let k: [String] = keys.filter {
                    if let storeValue = storeState.get($0),
                        let lastValue = lastState?.get($0) {
                            return !storeValue.equals(lastValue)
                    }
                    return false
                }
                
                if k.count > 0 && lastState != nil {
                    delegate.storeDidUpdateState(lastState!)
                }
                
                lastState = storeState
            }
        }
    }
    
    func disconnect(store: ReduxStore) {
        let address: Int = unsafeBitCast(store, Int.self)
        connections[address]!()
        connections.removeValueForKey(address)
    }
    
}

public extension UIViewController {
    
    private struct AssociatedKeys {
        static var connector: StoreConnector?
    }
    
    var __connector: StoreConnector? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.connector) as? StoreConnector
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.connector, newValue as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func connect(store: ReduxStore, keys: [String], delegate: StoreDelegate) {
        if __connector == nil {
            __connector = StoreConnector()
        }
        
        __connector?.connect(store, keys: keys, delegate: delegate)
    }
    
    func disconnect(store: ReduxStore) {
        __connector?.disconnect(store)
    }
    
}
