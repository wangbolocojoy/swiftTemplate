//
//  KtBackListCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/8/5.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtBackListCell: UITableViewCell {
static let reuseID =  "KtBackListCell"
    
    @IBOutlet weak var usericon: UIImageView!
    lazy var model :UserInfo? = nil
    @IBOutlet weak var userinfo: UILabel!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func setModel(user:UserInfo?){
        model = user
        updataCell()
    }
    func updataCell(){
        usericon.setImageUrl(image: usericon, string: model?.icon ?? "", proimage: #imageLiteral(resourceName: "背景色"))
        username.text = model?.nickName ?? ""
        userinfo.text = model?.easyInfo ?? ""
    }
    
}
