//
//  BTMUserItemCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/7.
//  Copyright © 2020 波王. All rights reserved.
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
        // Configure the view for the selected state
    }
    func updateCell(name:String?,user:UserInfo?){
        item_name.text = name ?? ""
        switch name ?? "" {
        case "账号id":
            item_value.text = "\(user?.id ?? 0)"
        case "昵称":
            item_value.text = user?.nickname ?? ""
        case "真实姓名":
              item_value.text = user?.relasename ?? ""
        case "个人简介":
            item_value.text = user?.seayinfo ?? ""
        case "地区":
             item_value.text = user?.address ?? ""
        default:
            log.info("")
        }
    }
    
}