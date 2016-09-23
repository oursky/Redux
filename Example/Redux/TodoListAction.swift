//
//  TodoListAction.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright (c) 2016 Oursky Limited. All rights reserved.
//

import Redux

let kTodoListUserDefaultsKey = "SwiftRedux.example.TodoList"

public enum TodoListAction: ReduxActionType {
    case load
    case loadSuccess(list: [TodoListItem])
    case loadFail

    case add(token: String, content: String)
    case addSuccess(token: String, createdAt: NSDate)
    case addFail(token: String)
}


public struct TodoListActionCreators {

    static func load(
        _ dispatch: @escaping DispatchFunction,
        userDefaults: UserDefaults
    ) {
        dispatch(
            ReduxAction(payload: TodoListAction.load)
        )

        let list = userDefaults
            .array(forKey: kTodoListUserDefaultsKey) ?? [Any]()

        let itemList = list.map {
            (item: Any) in
            TodoListItem(dict: (item as! [String: AnyObject]))
        }


        // need some time to load
        delay(1.0) {
            dispatch(
                ReduxAction(
                    payload: TodoListAction.loadSuccess(list: itemList)
                )
            )
        }
    }

    static func add(
        _ content: String,
        dispatch: DispatchFunction,
        userDefaults: UserDefaults
    ) {
        let token = NSUUID().uuidString
        dispatch(
            ReduxAction(
                payload: TodoListAction.add(token: token, content: content)
            )
        )

        let createdAt = NSDate()
        let newItem = TodoListItem(content: content, createdAt: createdAt)

        var list = userDefaults
            .array(forKey: kTodoListUserDefaultsKey) ?? [AnyObject]()

        list.append(newItem.toDict())

        userDefaults.set(list, forKey: kTodoListUserDefaultsKey)
        userDefaults.synchronize()

        dispatch(
            ReduxAction(
                payload: TodoListAction.addSuccess(
                    token: token,
                    createdAt: createdAt
                )
            )
        )
    }

}


// delay helper
func delay(_ delay: Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
