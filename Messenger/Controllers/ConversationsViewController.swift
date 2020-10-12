//
//  ViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 11/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isloggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        
        if !isloggedIn {
            let vc  = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav,animated: false)
        }
    }

}

