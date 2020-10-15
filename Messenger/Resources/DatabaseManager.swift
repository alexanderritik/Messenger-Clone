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
                
                self.database.child("users").observeSingleEvent(of: .value) { (snapshot) in
                    if var userCollection = snapshot.value as? [[String:String]] {
                        //append to the user dictionary
                        let newElement : [[String:String]] = [
                            [
                                "name": user.username,
                                "uid": user.currentId
                            ]
                        ]
                        userCollection.append(contentsOf: newElement)
                        self.database.child("users").setValue(userCollection , withCompletionBlock: { (error , _ ) in
                            guard error == nil else {
                                print("failed to write in database")
                                completion(false)
                                return
                            }
                            
                            completion(true)
                            
                        })
                        
                    }else{
                        //create an array
                        let newCollection : [[String:String]] = [
                            [
                            "name": user.username,
                            "uid": user.currentId
                            ]
                        ]
                        print(newCollection)
                        self.database.child("users").setValue(newCollection , withCompletionBlock: { (error , _ ) in
                            guard error == nil else {
                                print("failed to write in database")
                                completion(false)
                                return
                            }
                            
                            completion(true)
                        })
                    }
                    
                    
                }
                
                
        })
        
    }
        
    /// get all the user from database in child("users")
    func getAllUser(completion : @escaping (Result<[[String:String]] , Error>)-> Void){
        database.child("users").observeSingleEvent(of: .value) { (snapshot) in
            guard let users = snapshot.value as? [[String : String]] else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            completion(.success(users))
        }
    }
    
    
}

public enum DatabaseErrors : Error {
    case failedToFetch
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

//MARK: this is used to send message to
extension DatabaseManager {
    
    ///create new user with the current target user id
    public func createNewConversation(with otherUserID: String , message:Message , completion : @escaping (Bool) -> Void) {
        
    }
    
    ///Fetch and return all the mesage from the user id
    public func getAllConversation(for userId:String , completion : @escaping (Result<String, Error>)->Void){
        
    }
    
    /// Get all message for the conversation
    public func getAllMessageConveration(with id:String , completion: @escaping (Result<String , Error>)->Void ){
        
    }
    
    /// send a message to the target user 
    public func sendMessage(to conversation:String , message: Message ,completion: @escaping (Bool) -> Void){
        
    }
    
    
}
