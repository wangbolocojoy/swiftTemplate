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
    lazy var model :DeveloperInfo? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    func setModel(developer:DeveloperInfo?){
        model = developer
        updateCell()
    }
    func updateCell(){
        developer_email.text = model?.developerEmail_ ?? "634183261@qq.com"
        developer_qq.text = model?.developerQQ_ ?? "634183261"
        developer_icon.setImageUrl(image: developer_icon, string: model?.developerIcon_, proimage: #imageLiteral(resourceName: "IMG_2506"))
        developer_name.text = model?.developerName ?? "Tomcat"
        developer_wechat.text = model?.developerWechat_ ?? "SwiftKt"
    }
    
}
