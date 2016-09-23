//
//  TodoListItem.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright (c) 2016 Oursky Limited. All rights reserved.
//

import Redux

public struct TodoListItem: AnyEquatable, Equatable {
    var content: String
    var createdAt: NSDate?

    var token: NSString

    init(content: String, createdAt: NSDate) {
        self.content = content
        self.createdAt = createdAt
        self.token = ""
    }

    init(content: String, token: NSString) {
        self.content = content
        self.createdAt = nil
        self.token = token
    }

    init(dict: [String: AnyObject]) {
        self.content = dict["content"] as! String
        self.createdAt = dict["createdAt"] as! NSDate?
        self.token = ""
    }

    func toDict() -> [String: AnyObject] {
        return [
            "content": content as AnyObject,
            "createdAt": createdAt!
        ]
    }
}

public func == (lhs: TodoListItem, rhs: TodoListItem) -> Bool {
    return lhs.content == rhs.content &&
        lhs.createdAt === rhs.createdAt &&
        lhs.createdAt!.isEqual(to: rhs.createdAt! as Date)
}
