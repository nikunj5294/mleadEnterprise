//
//  SQLiteDatabaseServices.swift
//  NewMleadsEnterprise
//
//  Created by Triforce New Mac on 10/07/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

import Foundation

/*class SqliteDatabaseService {
    // MARK: -
    // MARK: Initials
    func execQuery(_ query: String?) -> SqliteServiceResult? {
        let responseData = SqliteServiceResult()
        let resultCategory = SQLite.query(query)
        
        if (resultCategory?.errorCode.uppercased() == "OK") {
            responseData.isSuccess = true
            if resultCategory?.rows.count() ?? 0 > 0 {
                if let rows = resultCategory?.rows {
                    responseData.rowsValue = rows
                }
                if let columnNames = resultCategory?.columnNames {
                    responseData.colsName = columnNames
                }
                responseData.lastInsertedId = resultCategory?.lastInsertedId
            } else {
                responseData.rowsValue = nil
                responseData.colsName = nil
                responseData.lastInsertedId = -1
            }
        }else{
            print("Execution failed !")
            responseData.isSuccess = false
            responseData.rowsValue = nil
            responseData.colsName = nil
            responseData.lastInsertedId = -1
        }
        return responseData
    }
    
    // MARK: - Insert Data
    func performModifyQueryAndGetAllValues(_ queryString: String?) -> SqliteServiceResult? {
        let queryStr = queryString ?? ""
        //NSLog(@"%@",[NSString stringWithFormat:@"Query String: %@",queryStr]);
        let response = APPLICATION_DELEGATE.objSqliteDatabase.execQuery(queryStr)
        
        return response
    }
    func performModifyQuery(_ queryString: String?) -> Bool {
        let queryStr = queryString ?? ""
        //    NSLog(@"%@",[NSString stringWithFormat:@"Query String: %@",queryStr]);
        let response = APPLICATION_DELEGATE.objSqliteDatabase.execQuery(queryStr)
        
        return response?.isSuccess ?? false
    }
    
    // MARK: - Initials
    init?() {
        if super.init() {
            appDelegate = UIApplication.shared.delegate as? MLeadAppDelegate
        }
    }

}*/
