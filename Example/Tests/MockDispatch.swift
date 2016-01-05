//
//  MockDispatch.swift
//  Redux
//
//  Created by Steven Chan on 5/1/16.
//  Copyright © 2016 oursky. All rights reserved.
//

import Redux

class MockDispatch {

    let dispatch: DispatchFunction
    let getDispatchedActions: () -> [ReduxAction]
    let cleanup: () -> ()

    init(
        dispatch: DispatchFunction,
        getDispatchedActions: () -> [ReduxAction],
        cleanup: () -> ()
    ) {
        self.dispatch = dispatch
        self.cleanup = cleanup
        self.getDispatchedActions = getDispatchedActions
    }

}

func createMockDispatch() -> MockDispatch {

    var dispatchedActions = [ReduxAction]()

    func getDispatchedActions() -> [ReduxAction] {
        return dispatchedActions
    }

    func dispatch(action: ReduxAction) -> ReduxAction {
        dispatchedActions.append(action)
        return action
    }

    func cleanup() {
        dispatchedActions.removeAll()
    }

    return MockDispatch(
        dispatch: dispatch,
        getDispatchedActions: getDispatchedActions,
        cleanup: cleanup
    )
}
