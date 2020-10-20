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
    
    private var isNewConversation = true
    private var otherUserId : String
    private var conversationId : String?
    
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
        
        let newsender = Sender(senderId: myid, displayName: navigationItem.title! , photoUrl: "")
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
    
    init(with uid: String , conId : String?) {
        self.otherUserId = uid
        self.conversationId = conId
        super.init(nibName: nil, bundle: nil)
        
        if let conversatinId = conversationId {
            listenForMessage(id: conversatinId)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func listenForMessage(id : String){
        
        DatabaseManager.shared.getAllMessageConveration(with: id) {[weak self] (result) in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case.success(let message):
                guard !message.isEmpty else { return }
                
                strongSelf.messages = message
                self?.isNewConversation = false
                DispatchQueue.main.async {
                    strongSelf.messagesCollectionView.reloadDataAndKeepOffset()
                }
                
            case .failure(let error):
                print("unable to downlaod chats \(error)")
                
            }
            
        }
        
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
            DatabaseManager.shared.createNewConversation(with: otherUserId, name: self.title!, message: message) { (status) in
                if status {
                    print("inseted sucesfully")
                    self.isNewConversation = false
                }else{
                    print("It is inseted unsuscessfully")
                }
            }
        }
        else{
            // when you already had chat
            guard let conversationId = conversationId else {return }
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserId: otherUserId , name: self.title! , message: message) { (status) in
                if status {
                    print("You have talked already")
                }else{
                    print("It is inseted unsuscessfully")
                }
            }
        }
        
    }
    
}

extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate , MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("something went wrong")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
}
