//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by Ritik Srivastava on 20/10/20.
//  Copyright © 2020 Ritik Srivastava. All rights reserved.
//

import UIKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {

    static let identifier = "ConversationTableViewCell"
    

    
    private let userImage : UIImageView = {
         let img = UIImageView()
         img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
         img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
         img.layer.cornerRadius = 35
         img.clipsToBounds = true
        return img
    }()
    
    private var userlabel : UILabel = {
       let label = UILabel()
       label.font = UIFont.boldSystemFont(ofSize: 20)
       label.textColor = UIColor(displayP3Red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
    }()
    
    let onlineView: UIView = {
        let img = UIView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = UIColor.green
        return img
    }()
        
    private var messagelabel : UILabel = {
       let label = UILabel()
       label.font = UIFont.boldSystemFont(ofSize: 18)
       label.textColor =  UIColor(displayP3Red: 0.2431372549, green: 0.7647058824, blue: 0.8392156863, alpha: 1)
       label.layer.cornerRadius = 5
       label.clipsToBounds = true
       label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(userImage)
        contentView.addSubview(userlabel)
        contentView.addSubview(messagelabel)
        contentView.addSubview(onlineView)
        
        onlineView.layer.cornerRadius = 7.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImage.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        
        userlabel.frame = CGRect(x: userImage.right + 10,
                                 y: 15,
                                 width: contentView.width - 20 - userImage.width ,
                                 height: 25)
        
        messagelabel.frame = CGRect(x: userImage.right + 10,
                                    y: userlabel.bottom + 2 ,
                                    width: contentView.width - 20 - userImage.width ,
                                    height: 30 )
        
        onlineView.frame = CGRect(x: userImage.right - 8  ,
                                    y: messagelabel.bottom + 8,
                                    width: 15,
                                    height: 15)
    
    }
    
    public func configure(with model: Converstaion){
        print(model)
        
        let path = "images/\(model.otherUserId)_profile_Picture.png"
        
        StorageManager.shared.downloadUrl(with: path) { (result) in
            
            switch result {
            case .success(let url):
                
                DispatchQueue.main.async {
                    self.userImage.sd_setImage(with: url, completed: nil)
                }
                                
            case .failure((let error)):
                print("failed to get the image url \(error)")
            }
            
        }
        
        userlabel.text = model.name
        messagelabel.text = model.latestMessage.text
    }
   
}
