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
        
        //add bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newChat))
        
        view.addSubview(tableView)
        view.addSubview(noConversationLabel)
    }
    
    override func viewDidLayoutSubviews() {
       super.viewWillLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.width , height: view.height)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginCheck()
    }
    
    @objc private func newChat(){
        let vc = NewConversationViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav , animated: true)
        print("New chat available")
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
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("table view did select at")
        
        let vc = ChatViewController()
        vc.title = "AlexanderRitik"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: here we fetch the chat
extension ConversationsViewController {
    
    func fetchConversation(){
        tableView.isHidden = false
    }
}
