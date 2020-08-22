//
//  DBManager.swift
//  DBTest
//
//  Created by matsumoto keiji on 2017/07/25.
//  Copyright © 2017年 matsumoto keiji. All rights reserved.
//

import Foundation
import UIKit
import FMDB

class DBManager: NSObject {
    private var filePath:String? = nil
    var myDB:FMDatabase? = nil
    var isOK = false
    
    //初期化
    init(dbFileName:String) {
        super.init()
        
        if(setupDatabaseFile(dbFileName:dbFileName)) {
            if(self.connect()) {
                isOK = true
            }
            else {
                isOK = false
            }
        }
        else {
            isOK = false
        }
    }
    
    //接続
    private func connect() -> Bool {
        self.myDB = FMDatabase(path: self.filePath)
        if((self.myDB != nil) && (self.myDB?.open())!) {
            return true
        }
        return false
    }
    
    //切断
    private func disConnect() -> Bool {
        if((self.myDB != nil) && (self.myDB?.close())!) {
            self.myDB = nil
            return true
        }
        return false
    }
    
    //DBファイルのパスを取得
    private static func getDatabaseFilePath(dbFileName:String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0].appending("/" + dbFileName)
    }
    
    //DBファイルを準備
    private func setupDatabaseFile(dbFileName:String)->Bool {
        self.filePath = DBManager.getDatabaseFilePath(dbFileName:dbFileName)
        
        //ファイルがない場合はコピー
        if(!FileManager.default.fileExists(atPath: self.filePath!)) {
            let defaltDBPath = Bundle.main.path(forResource: dbFileName, ofType:nil)!
            
            do {
                try
                    FileManager.default.copyItem(atPath: defaltDBPath, toPath:self.filePath!)
            }
            catch let error as NSError {
                NSLog(error.description + " / Copy error = " + defaltDBPath)
                return false
            }
            
            if FileManager.default.fileExists(atPath: self.filePath!) == false {
                //error
                NSLog("Copy error = " + defaltDBPath)
                return false
            }
        }
        return true
    }
    
    //SQLを実行する
    func execQuery(sql:String)->FMResultSet {
        do {
            return try self.myDB!.executeQuery(sql, values: nil)
        } catch {
            return FMResultSet()
        }
    }
    
    //更新系SQLを実行する
    func execUpdateSQL(sql:String)->Bool {
        do {
            try self.myDB!.executeUpdate(sql, values: nil)
        } catch {
            return false
        }
        return true
    }
    
    //トランザクション
    func begin() {
        self.myDB?.beginTransaction()
    }
    func rollback() {
        self.myDB?.rollback()
    }
    func commit() {
        self.myDB?.commit()
    }
    
    //文字列の日付をNSDateにする
    static func stringToDate(format:String,strDate:String)->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        return dateFormatter.date(from: strDate)!
    }
    
    //文字列をSQL正規化する
    static func normalizeSQL(_ str:String?)->String
    {
        var repStr = str
        repStr = repStr?.replacingOccurrences(of: " ", with: "%20")
        repStr = repStr?.replacingOccurrences(of: "'", with: "%27")
        
        return repStr!
    }
    
    //SQL正規化を元に戻す
    static func normalizeString(_ str:String?)->String
    {
        var repStr = str
        repStr = repStr?.replacingOccurrences(of: "%20", with: " ")
        repStr = repStr?.replacingOccurrences(of: "%27", with: "'")
        
        return repStr!
    }
    
}


