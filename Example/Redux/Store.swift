//
//  Store.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright (c) 2016 Oursky Limited. All rights reserved.
//

import Redux

class Store: StoreType {

    static func configureStore() -> ReduxStore {

        let initialState = AppState(
            todoList: TodoListState(list: [TodoListItem]())
        )

        let reducers: [String: Reducer] = [
            kAppStateKeyTodoList: todoListReducer,
        ]

        return createStore(
            combineReducers(reducers),
            initialState: initialState
        )
    }

}
