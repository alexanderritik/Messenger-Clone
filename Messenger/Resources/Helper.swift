//
//  Helper.swift
//  Messenger
//
//  Created by Ritik Srivastava on 12/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    class func error(title: String , message:String)-> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        return alert
    }
}
