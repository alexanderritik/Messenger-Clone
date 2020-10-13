//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Ritik Srivastava on 13/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    //creating a shared delegate
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

//MARK: - Database query
extension DatabaseManager {
    
    ///Insert query
    public func insertUser(with user : ChatAppUser){
        guard let uid = Helper.uniqueId() else { return }
        database.child(uid).setValue([
            "username" : user.username,
            "email" : user.email
            ])
    }
    
}


struct ChatAppUser {
    let username:String
    let email : String
    // let profileImage : URL
}
