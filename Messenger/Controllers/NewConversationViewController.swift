//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 11/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit

class NewConversationViewController: UIViewController {

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search user here ... "
        return searchBar
    }()
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableView.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResult : UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "No user found!"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSearch))
        
        view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
        
    }

}

extension NewConversationViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    @objc private func cancelSearch(){
        dismiss(animated: true, completion: nil)
    }
    
}
