//
//  StorageManager.swift
//  Messenger
//
//  Created by Ritik Srivastava on 13/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/uid
     */
    
    public typealias uploadPictureCompletion = (Result< String , Error>) -> Void
    
    ///Uplaod picture to firebase and return completion with url string
    public func uploadProfilePicture(with data: Data , filename : String , completion: @escaping uploadPictureCompletion ) {
        

        storage.child("images/\(filename)").putData(data, metadata: nil , completion: { (metaData , error) in
            
            guard error == nil else {
                print("Failed to uplaod profile image to firebase")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(filename)").downloadURL { (url, error) in
                
                guard let url = url else {
                    print("failed to downlaod url")
                    completion(.failure(StorageErrors.failedToDownlaodUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print(urlString)
                completion(.success(urlString))
            }
            
        })
        
    }
    
    
    public enum StorageErrors : Error {
        case failedToUpload
        case failedToDownlaodUrl
    }
    
}