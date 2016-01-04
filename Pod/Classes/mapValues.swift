//
//  mapValues.swift
//  Redux.swift
//
//  Created by Mark Wise on 11/4/15.
//  Copyright © 2015 InstaJams. All rights reserved.
//

import Foundation

public func mapValues(obj: [String: Any], fn: (value: Any, key: String) -> Any) -> [String: Any] {
    var result = [String: Any]();

    for (key, value) in obj {
        result[key] = fn(value: value, key: key);
    }
    return result;
}
