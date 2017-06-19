//
//  TLModelManager.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 05/06/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import SQLite

class TLModelManager: NSObject {

    static let sharedModelManagerInstance = TLModelManager()
    var db: Connection!
    
    static func getSharedManager() -> TLModelManager {
        if sharedModelManagerInstance.db == nil {
            sharedModelManagerInstance.db = self.createDatabase()
        }
        return sharedModelManagerInstance
    }
    
    static func createDatabase() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let localDB = try! Connection("\(path)/db.sqlite3")
        print("\n\n *******************************\n database path: \(path) \n******************************* \n\n")
        return localDB
    }
    
}
