//
//  sqlite.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 06/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation
import SQLite3


/*var isDatabaseOpen = false
let database : sqlite3? = nil

//fileprivate let database :  OpaquePointe?
//let database : SQLite = SQLite()

 
class SQLite {
    
   //var database : sqlite3? = nil
    
    
    class func filename() -> String? {
        return "MLeadAppDb.sqlite"
    }
    
    class func fullFilePath() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory + ("\("/")\(SQLite.filename() ?? "")")
    }
    
    class func initializeDB() -> Bool {
        var success: Bool
        let fileManager = FileManager.default
        success = fileManager.fileExists(atPath: SQLite.fullFilePath() ?? "")
        if success {
            return false
        }
        let error: Error? = nil
        success = fileManager.createFile(atPath: SQLite.fullFilePath() ?? "", contents: nil, attributes: nil)
        
        print("\(error?.localizedDescription ?? "")")
        return true
    }
    
    class func removeDB() -> Bool{
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: SQLite.fullFilePath()!) {
                return true
            }
            return ((try? fileManager.removeItem(atPath: SQLite.fullFilePath() ?? "")) != nil)
        }
    }
    
    
    
    
    class func isOpenDatabase() -> Bool{
        do {
            if sqlite3_open(SQLite.fullFilePath().utf8CString, &database) == SQLITE_OK {
                isDatabaseOpen = true
            } else {
                isDatabaseOpen = false
                print("SQLite Database failed to open")
            }
            return isDatabaseOpen
        }
    }

    class func closeDatabase(){
        do {
            sqlite3_close(database)
            
        }
    }
    
    class func query(_ content: String?) -> SQLiteResult? {
    
        let result = SQLiteResult.create()
        if self.isOpenDatabase() {
            let sqlStatement = content?.cString(using: .utf8)
            var db: OpaquePointer?
            //sqlite3_stmt *compiledStatement = NULL ;
            //var compiledStaz
            let compiledStatement: sqlite3_stmt? = nil
            
            //if (compiledStatement) {  

            if compiledStatement != nil {


                if sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, nil) == SQLITE_OK {
                    let colCount = sqlite3_column_count(compiledStatement)
                    for i in 0..<colCount {
                        if i == 0 {
                        }


                        if sqlite3_column_name(compiledStatement, i) != nil {
                            result.columnNames.append(String(cString: sqlite3_column_name(compiledStatement, i), encoding: .utf8) ?? "")
                        }

                        if sqlite3_column_decltype(compiledStatement, i) != nil {
                            result.columnTypes.append(String(cString: sqlite3_column_decltype(compiledStatement, i), encoding: .utf8) ?? "")
                        }

                    }

                    while sqlite3_step(compiledStatement) == SQLITE_ROW {
                        // Read the data from the result row
                        var row = [AnyHashable](repeating: 0, count: colCount)

                        for i in 0..<colCount {
                            if sqlite3_column_text(compiledStatement, i) != nil {
                                var text = "\(String(utf8String: Int8(sqlite3_column_text(compiledStatement, i))) ?? "")"

                                if !text.isEqual(NSNull()) && text != nil {
                                    row.append(text)
                                } else {
                                    row.append("")
                                }
                                text = ""
                            } else {
                                row.append("")
                            }
                        }
                        result.rows.append(row)
                    }
                    result!.errorCode = "OK"
                }else{
                    result?.errorCode = "SQL Statement failed to execute"
                }
            }
            sqlite3_finalize(compiledStatement)
            result.lastInsertedId = Int(sqlite3_last_insert_rowid(database))

            }else{
                result?.errorCode = "SQL Statement failed to execute"
            }
            return result
    }
}*/


