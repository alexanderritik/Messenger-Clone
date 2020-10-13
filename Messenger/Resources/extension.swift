//
//  extension.swift
//  Messenger
//
//  Created by Ritik Srivastava on 12/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public var width : CGFloat {
        return self.frame.size.width
    }
    
    public var height : CGFloat {
        return self.frame.size.height
    }
    
    public var top : CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom : CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left : CGFloat {
        return self.frame.origin.x
    }
    
    public var right : CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}


//to add spiner view in viewcontroller
extension UIViewController {
     
    class func displayLoading(withView: UIView) -> UIView{
        
        //to make cover all cuurent view
        let spinnerView = UIView.init(frame: withView.frame)
        
        spinnerView.backgroundColor = UIColor.clear
        
        let ActvitySpinner = UIActivityIndicatorView.init(style: .medium)
        
        ActvitySpinner.startAnimating()
        
        ActvitySpinner.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ActvitySpinner)
            
            withView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removingLoading(spinner : UIView) {
        
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
        
    }
    
}
