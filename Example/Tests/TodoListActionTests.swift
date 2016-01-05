//
//  TodoListActionTests.swift
//  Redux
//
//  Created by Steven Chan on 5/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import Redux

class TodoListActionTests: XCTestCase {

    let mockUserDefaults: NSUserDefaults =
        NSUserDefaults(suiteName: "TodoListActionTests")!
    let mockDispatch: MockDispatch = createMockDispatch()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()

        let dict = mockUserDefaults.dictionaryRepresentation()
        for (k, _) in dict {
            mockUserDefaults.removeObjectForKey(k)
        }
        mockDispatch.cleanup()
    }

}
