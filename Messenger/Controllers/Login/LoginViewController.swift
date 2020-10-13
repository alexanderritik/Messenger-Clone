//
//  LoginViewController.swift
//  Messenger
//
//  Created by Ritik Srivastava on 11/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    private var imageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Logo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField : UITextField = {
        let email = UITextField()
        
        email.autocapitalizationType = .none
        email.autocorrectionType = .no
        email.backgroundColor = .white
        email.layer.cornerRadius = 12
        email.layer.borderWidth = 1
        email.layer.borderColor = UIColor.lightGray.cgColor
        email.placeholder = "Email Address ..."
        email.returnKeyType = .continue
        //to clear side buffer because text and border touches at left
        email.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        email.leftViewMode = .always
        
        return email
    }()
    
    
    private let passwordField : UITextField = {
        let password = UITextField()
        
        password.autocapitalizationType = .none
        password.autocorrectionType = .no
        password.returnKeyType = .done
        password.backgroundColor = .white
        password.layer.cornerRadius = 12
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.placeholder = "Password ..."
        password.isSecureTextEntry = true
        //to clear side buffer because text and border touches at left
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        password.leftViewMode = .always
        return password
    }()
    
    
    private let LoginButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.addTarget(self,action: #selector(LoginButtonDidTouch), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Log In"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(registerButtonDidTouch))
        // Do any additional setup after loading the view.
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(LoginButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        let size = view.frame.size.width / 3;
        imageView.frame = CGRect(x: (view.frame.size.width-size)/2, y: 20, width: size, height: size)
        
        emailField.frame = CGRect(x: 30, y: imageView.bottom+10, width: scrollView.width-60, height: 52)
        
        passwordField.frame = CGRect(x: 30, y: emailField.bottom+15, width: scrollView.width-60, height: 52)
        
        LoginButton.frame = CGRect(x: 30, y: passwordField.bottom+20, width: scrollView.width-60, height: 52)
    }
    
    
    @objc func registerButtonDidTouch(){
        print("register clecked")
        
        let vc = RegisterViewController()
        
        vc.title = "Register"
        
        navigationController?.pushViewController(vc, animated: true)
    }

    
    @objc func LoginButtonDidTouch(){
        print("Login is clicked")
        
        //get rid of keyboard
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text  , let password = passwordField.text ,!email.isEmpty ,!password.isEmpty , password.count>=6  else {
            let error = Helper.error(title: "Email or Password Invalid", message: "Please retry to fill!")
            present(error, animated:  true)
            return
        }
        
        //firebase login
        let spinner = UIViewController.displayLoading(withView: self.view)
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            
            if error == nil {
                DispatchQueue.main.async {
                    //remove spinner
                    UIViewController.removingLoading(spinner: spinner)
                }
                print("enter to database")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
                
            else if let error = error{
                DispatchQueue.main.async {
                    UIViewController.removingLoading(spinner: spinner)
                }
                let alertError = Helper.loginSignError(error: error , title: "Email or password is invalid")
                DispatchQueue.main.async {
                    strongSelf.present(alertError , animated: true)
                }
            }
            
        }
        
        
    }
    
}

// this help on clicking enter in the text it will goes to other field we can also do textEditing
extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if passwordField == passwordField {
            LoginButtonDidTouch()
        }
        return true
    }
    
}
