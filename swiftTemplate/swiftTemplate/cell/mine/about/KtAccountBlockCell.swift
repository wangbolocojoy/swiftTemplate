//
//  KtAccountBlockCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtAccountBlockCell: UITableViewCell {
static let reuseID =  "KtAccountBlockCell"
    lazy var usermodel :UserInfo? = nil
    @IBOutlet weak var checkbox: KtCheckBox!
    @IBOutlet weak var usernickname: UILabel!
    @IBOutlet weak var userinfo: UILabel!
    @IBOutlet weak var usericon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func setModel(model:UserInfo?){
        usermodel = model
        updateCell()
    }
    
    func updateCell(){
        checkbox.setcheck(isheck: usermodel?.isselectid ?? false)
        usernickname.text = usermodel?.nickName ?? ""
        userinfo.text = usermodel?.easyInfo ?? ""
        usericon.setImageUrl(image: usericon, string: usermodel?.icon ?? "", proimage: #imageLiteral(resourceName: "背景色"))
    }
}
