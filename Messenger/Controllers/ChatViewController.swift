//
//  ChatViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 13/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit
import MessageKit

struct Message : MessageType {
    
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}

struct Sender : SenderType {
    var senderId: String
    var displayName: String
    var photoUrl : String
}



class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    private var selfSender = Sender(senderId: "1", displayName: "Alex", photoUrl: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("hello world")))
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("hello Alex can you talk to me")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
    }
    
}


extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate , MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
