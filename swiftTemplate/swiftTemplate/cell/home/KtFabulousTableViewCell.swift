//
//  KtFabulousTableViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtFabulousTableViewCell: UITableViewCell {
static let reuseID =  "KtFabulousTableViewCell"
    
    @IBOutlet weak var usericon: UIImageView!
    
    @IBOutlet weak var usereasyinfo: UILabel!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func updateCell(info :UserInfo?){
        log.info(info?.toJSONString() ?? "")
        usericon.setImageUrl(image: usericon, string: info?.icon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        username.text = info?.nickName ?? ""
        usereasyinfo.text = info?.easyInfo ?? ""
    }
    
    
}
