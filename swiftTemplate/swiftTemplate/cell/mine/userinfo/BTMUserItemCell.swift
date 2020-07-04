//
//  BTMUserItemCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/7.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class BTMUserItemCell: UITableViewCell {
static let reuseID =  "BTMUserItemCell"
    
    @IBOutlet weak var item_value: UILabel!
    
    @IBOutlet weak var item_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    func updateCell(name:String?,user:UserInfo?){
        item_name.text = name ?? ""
        switch name ?? "" {
        case "账号":
            item_value.text = user?.account ?? ""
        case "昵称":
            item_value.text = user?.nickName ?? ""
        case "真实姓名":
              item_value.text = user?.realName ?? ""
        case "个人简介":
            item_value.text = user?.easyInfo ?? ""
        case "地区":
             item_value.text = user?.address ?? ""
        case "生日":
            item_value.text = "\(user?.birthDay ?? "")--\( user?.constellation ?? "")"
        case "性别":
            item_value.text = (user?.userSex ?? false ) ? "女":"男"
        default:
            log.info("")
        }
    }
    
}
