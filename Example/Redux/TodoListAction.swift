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
    case Load
    case LoadSuccess(list: [TodoListItem])
    case LoadFail

    case Add(token: String, content: String)
    case AddSuccess(token: String, createdAt: NSDate)
    case AddFail(token: String)
}


public struct TodoListActionCreators {

    static func load(
        dispatch: DispatchFunction,
        userDefaults: NSUserDefaults
    ) {
        dispatch(
            action: ReduxAction(payload: TodoListAction.Load)
        )

        let list = userDefaults
            .arrayForKey(kTodoListUserDefaultsKey) ?? [AnyObject]()

        let itemList = list.map {
            (item: AnyObject) in
            TodoListItem(dict: (item as! [String: AnyObject]))
        }


        // need some time to load
        delay(1.0) {
            dispatch(
                action: ReduxAction(
                    payload: TodoListAction.LoadSuccess(list: itemList)
                )
            )
        }
    }

    static func add(
        content: String,
        dispatch: DispatchFunction,
        userDefaults: NSUserDefaults
    ) {
        let token = NSUUID().UUIDString
        dispatch(
            action: ReduxAction(
                payload: TodoListAction.Add(token: token, content: content)
            )
        )

        let createdAt = NSDate()
        let newItem = TodoListItem(content: content, createdAt: createdAt)

        var list = userDefaults
            .arrayForKey(kTodoListUserDefaultsKey) ?? [AnyObject]()

        list.append(newItem.toDict())

        userDefaults.setObject(list, forKey: kTodoListUserDefaultsKey)
        userDefaults.synchronize()

        dispatch(
            action: ReduxAction(
                payload: TodoListAction.AddSuccess(
                    token: token,
                    createdAt: createdAt
                )
            )
        )
    }

}


// delay helper
func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(),
        closure
    )
}
