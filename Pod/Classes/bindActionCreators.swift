//
//  bindActionCreators.swift
//  Redux.swift
//
//  Created by Mark Wise on 11/4/15.
//  Copyright © 2015 InstaJams. All rights reserved.
//

import Foundation

private func bindActionCreator(actionCreator: ActionCreator, dispatch: DispatchFunction) -> FunctionWithArgs {
    func myFunc(args: Any...) -> Void {
        dispatch(action: actionCreator(args: args))
    }

    return myFunc;
}

public func bindActionCreators(actionCreators: [String: ActionCreator], dispatch: DispatchFunction) -> [String: FunctionWithArgs] {
    var result = [String: FunctionWithArgs]();

    for (key, actionCreator) in actionCreators {
        result[key] = bindActionCreator(actionCreator, dispatch: dispatch);
    }
    return result;
}
