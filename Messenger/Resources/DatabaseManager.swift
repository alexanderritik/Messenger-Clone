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
    
    /*
      "UUISIDIIhxiAI": {
            "messages" :[
                {
                    "id" : String,
                    "type" : text , video , photo,
                    "content" : String,
                    "date" : Date(),
                    "sender_id": String,
                    "isRead" : True/false
                }
            ]
        }
     
     
        Conversation => [
            [
                "conversation_id" : "UUISIDIIhxiAI",
                "otherUserId" : String,
                "latestMessage" => {
                    "date" : Date(),
                    "latestMessage" : String,
                    "isRead" : True/false,
                }
            ]
        ]
     
     */
    
    ///create new user with the current target user id
    public func createNewConversation(with otherUserID: String , message:Message , completion : @escaping (Bool) -> Void) {
        
        guard let uid = Helper.uniqueId() else {
            print("current user not found")
            completion(false)
            return
        }
        
        
        let ref = database.child(uid)
        ref.observeSingleEvent(of: .value) {[weak self] (snapshot) in
            
            guard var userNode = snapshot.value as? [String:Any] else {
                print("user not found")
                completion(false)
                return
            }
            
            //conversation id
            let conversationId = "conversation_\(message.messageId)"
            
            //convert date in string
            let messageDate = message.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            //convert type of date text
            var messageTxt = ""
            switch message.kind {
            case .text(let text):
                messageTxt = text
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            }
            
            let Newconversation : [String:Any] = [
                "id" : conversationId,
                "otherUserId" : otherUserID,
                "latestMessage" :[
                    "date" : dateString,
                    "latestMessage" : messageTxt,
                    "isRead" : false,
                ]
            ]
            
//            print(Newconversation)
            
            if var conversation = userNode["conversation"] as? [[String:Any]] {
                //conversation array exist for cuurent user
                //you shoud append
                
                conversation.append(Newconversation)
                userNode["conversation"] = conversation
                
                ref.setValue(userNode) { (error, _) in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    self?.finishCreatingFunction(conversationId: conversationId, message: message, completion: completion)
                }
                
            }else{
                // conversation array donot exist for current user
                //you should create it
                userNode["conversation"] = [
                    Newconversation
                ]
                
                ref.setValue(userNode) { (error, _) in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingFunction(conversationId: conversationId, message: message, completion: completion)
                }
                
            }
            
        }
        
    }
    
    private func finishCreatingFunction(conversationId : String , message : Message , completion : @escaping (Bool)-> Void){
        
        guard let uid = Helper.uniqueId() else {
            print("current user not found")
            completion(false)
            return
        }
        
        //convert date in string
        let messageDate = message.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        //convert type of date text
        var messageTxt = ""
        var type = ""
        switch message.kind {
        case .text(let text):
            messageTxt = text
            type = "text"
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        }
        
        
        let newMessage : [String : Any] = [
                "id" : conversationId,
                "type" : type,
                "content" : messageTxt,
                "date" : dateString,
                "sender_id": uid,
                "isRead" : false
        ]
        
        let value : [String :Any] = [
            "messages" : [
                newMessage
            ]
        ]
        
        database.child(conversationId).setValue(value) { (error, _) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
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
