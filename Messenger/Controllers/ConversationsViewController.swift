//
//  ViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 11/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit
import Firebase

class ConversationsViewController: UIViewController  {

    private let tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.isEditing = true
        table.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noConversationLabel : UILabel = {
        let label = UILabel()
        label.text = "no chats are found!"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21 , weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up the tableview
        setupTableView()
        
        //fetching the chats
        fetchConversation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginCheck()
    }
    
    
    func loginCheck(){
        
        if Auth.auth().currentUser == nil {
            let vc  = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: false)
        }
        
    }

}

//MARK: here we setup the table view all functionality
extension ConversationsViewController :  UITableViewDelegate, UITableViewDataSource {
        
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "AlexanderRitik"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: here we fetch the chat
extension ConversationsViewController {
    
    func fetchConversation(){
        
    }
}
