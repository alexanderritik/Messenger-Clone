//
//  ChatViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 13/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

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
    
    public var isNewConversation = false
    public var otherUserId : String
    
    // it help to get date in form of long string
    public static let dateFormatter: DateFormatter = {
        let date = DateFormatter()
        date.dateStyle = .medium
        date.timeStyle = .long
        date.locale = .current
        return date
    }()
    
    private var messages = [Message]()
    private var selfSender : Sender?
    
    let myid = Helper.uniqueId()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemPink
        
        let newsender = Sender(senderId: otherUserId, displayName: navigationItem.title!    , photoUrl: "")
        selfSender = newsender
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    init(with uid: String) {
        self.otherUserId = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension ChatViewController : InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty ,
             let selfsender = selfSender    else {
            return
        }
        
        let date = Self.dateFormatter.string(from: Date())
        let messageUniqueId = "\(otherUserId)-\(myid)-\(date)"
        
        print(text , otherUserId , date , messageUniqueId)
        
        let message = Message(sender: selfsender,
                              messageId: messageUniqueId,
                              sentDate: Date(),
                              kind: .text(text))
        
        if isNewConversation {
            // when new conversation first time
            DatabaseManager.shared.createNewConversation(with: otherUserId, message: message) { (status) in
                if status {
                    print("inseted sucesfully")
                }else{
                    print("It is inseted unsuscessfully")
                }
            }
        }
        else{
            // when you already had chat
        }
        
    }
    
}

extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate , MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        selfSender!
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
