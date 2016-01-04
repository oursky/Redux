//
//  TodoListItem.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Redux

struct TodoListItem: AnyEquatable, Equatable {
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
            "content": content,
            "createdAt": createdAt!
        ]
    }
}

func ==(lhs: TodoListItem, rhs: TodoListItem) -> Bool {
    return lhs.content == rhs.content && lhs.createdAt === rhs.createdAt && lhs.createdAt!.isEqualToDate(rhs.createdAt!)
}
