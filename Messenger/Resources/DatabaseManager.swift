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
    public func insertUser(with user : ChatAppUser , completion : @escaping (Bool)-> Void){
        guard let uid = Helper.uniqueId() else { return }
        database.child(uid).setValue([
            "username" : user.username,
            "email" : user.email
            ] , withCompletionBlock: { (error, _ ) in
                guard error == nil else {
                    print("failed to write in database")
                    completion(false)
                    return
                }
                completion(true)
        })
        
    }
    
}


struct ChatAppUser {
    let username:String
    let email : String
    // let profileImage : URL
    
    let currentId = Helper.uniqueId()!

    var profileImageFileName : String {
        return "\(currentId)_profile_Picture.png"
    }
}
