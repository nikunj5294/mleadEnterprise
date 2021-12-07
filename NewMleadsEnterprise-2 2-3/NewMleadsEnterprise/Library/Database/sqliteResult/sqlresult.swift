//
//  SQLiteResult.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 06/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation

class SQLiteResult: NSObject {
    var errorCode = ""
    var columnNames: [AnyHashable] = []
    var columnTypes: [AnyHashable] = []
    var rows: [AnyHashable] = []
    var lastInsertedId = 0
    
    class func create() -> SQLiteResult? {
        let res = SQLiteResult()
        res.errorCode = "Uninitialized result"
        res.columnNames = [AnyHashable](repeating: 0, count: 10)
        res.columnTypes = [AnyHashable](repeating: 0, count: 10)
        res.rows = [AnyHashable](repeating: 0, count: 10)
        res.lastInsertedId = 0
        return res
    }
}
