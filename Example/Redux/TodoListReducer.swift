//
//  TodoListReducer.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Redux


struct TodoListState: AnyEquatable, Equatable {
    var list: [TodoListItem]
}

func ==(lhs: TodoListState, rhs: TodoListState) -> Bool {
    return lhs.list == rhs.list
}


func todoListReducer(previousState: Any, action: ReduxAction) -> Any {
    var state = previousState as! TodoListState
    
    print("action: ", action)
    
    switch action.payload {
    case TodoListAction.LoadSuccess(let list):
        state.list = list
        break
        
    case TodoListAction.Add(let token, let content):
        state.list.append(
            TodoListItem(
                content: content,
                token: token
            )
        )
        break
    case TodoListAction.AddSuccess(let token, let createdAt):
        state.list = state.list.map {
            item in
            item.token == token ?
                TodoListItem(content: item.content, createdAt: createdAt) :
                item
        }
        break
    case TodoListAction.AddFail(let token):
        state.list = state.list.filter {
            item in item.token != token
        }
        break
        
    default:
        break
    }
    return state
}
