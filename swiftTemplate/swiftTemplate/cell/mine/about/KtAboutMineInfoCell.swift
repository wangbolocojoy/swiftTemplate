//
//  KtAboutMineInfoCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/10.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtAboutMineInfoCell: UITableViewCell {
static let reuseID =  "KtAboutMineInfoCell"
    
    @IBOutlet weak var developer_email: UILabel!
    @IBOutlet weak var developer_qq: UILabel!
    @IBOutlet weak var developer_wechat: UILabel!
    @IBOutlet weak var developer_name: UILabel!
    @IBOutlet weak var developer_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    
}
