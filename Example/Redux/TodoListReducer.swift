//
//  TodoListReducer.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright (c) 2016 Oursky Limited. All rights reserved.
//

import Redux


struct TodoListState: AnyEquatable, Equatable {
    var list: [TodoListItem]
}

func == (lhs: TodoListState, rhs: TodoListState) -> Bool {
    return lhs.list == rhs.list
}


func todoListReducer(_ previousState: Any, action: ReduxAction) -> Any {
    var state = previousState as! TodoListState

    print("action: ", action)

    switch action.payload {
    case TodoListAction.loadSuccess(let list):
        state.list = list
        break

    case TodoListAction.add(let token, let content):
        state.list.append(
            TodoListItem(
                content: content,
                token: token as NSString
            )
        )
        break
    case TodoListAction.addSuccess(let token, let createdAt):
        state.list = state.list.map {
            item in
            item.token as String == token ?
                TodoListItem(content: item.content, createdAt: createdAt) :
            item
        }
        break
    case TodoListAction.addFail(let token):
        state.list = state.list.filter {
            item in item.token as String != token
        }
        break

    default:
        break
    }
    return state
}
