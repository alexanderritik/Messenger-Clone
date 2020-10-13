//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 11/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}

//MARK: - It is an more option in profile bar button icon
extension ProfileViewController {
    
    @IBAction func moreOption(_ sender: Any) {
        
        let alert = UIAlertController(title: "Setting", message: "option available", preferredStyle: .actionSheet)
        
        let logout = UIAlertAction(title: "Logout", style: .default) {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.doYouReallyWantToExist()
        }
        
        let setting = UIAlertAction(title: "Setting", style: .default) { _ in
            print("In the setting")
        }
        
        let cancel = UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(logout)
        alert.addAction(setting)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    func doYouReallyWantToExist(){
        let alert = UIAlertController(title: "Logout", message: "Really want to logout?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default) { [weak self]  _ in
            
            guard let strongSelf = self else { return }
            do {
                //logout from facebook
                FBSDKLoginKit.LoginManager().logOut()
                
                //logout from google
                GIDSignIn.sharedInstance().signOut()
                
                //lohout from firebase
                try Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav , animated: true)
                
            }catch{
                print("Failed to logout")
            }
        }
        
        let no = UIAlertAction(title: "No", style: .cancel) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert , animated:  true)
    }
    
    
}
