//
//  PostBuddy.swift
//  TraveLibro
//
//  Created by Chintan Shah on 23/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import SQLite

public class Buddy {
    
    let db = TLModelManager.getSharedManager().db!
    
    var buddyID = ""
    var postID = 0
    var buddyEmail = ""
    var buddyName = ""
    var buddyImg = ""
    let buddy = Table("Buddy")
    
    let id = Expression<Int64>("id")
    let postid = Expression<Int64>("postId")
    let buddyuserid = Expression<String>("buddyUserId")
    
    init() {
        try! db.run(buddy.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(postid)
            t.column(buddyuserid)
        })
    }
    
    func save() {
        let photoinsert = self.buddy.insert(
            self.buddyuserid <- self.buddyID,
            self.postid <- Int64(self.postID)
        )
        do {
            try db.run(photoinsert)
        } catch _ {
            
        }
    }
    
    func dropBuddyTable() {
        try! db.run(buddy.drop(ifExists: true))
    }
    
}
