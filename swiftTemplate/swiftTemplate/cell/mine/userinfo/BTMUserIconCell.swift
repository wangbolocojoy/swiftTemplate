//
//  BTMUserIconCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/7.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class BTMUserIconCell: UITableViewCell {
static let reuseID =  "BTMUserIconCell"
   
    
    @IBOutlet weak var usericon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
      
    }
    func updateCell(user:UserInfo?){
        usericon.setImageUrl(image: usericon ,string: user?.icon, proimage: #imageLiteral(resourceName: "背景色"))
    }
    
}
