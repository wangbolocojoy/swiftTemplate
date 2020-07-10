//
//  FanceInfoHeaderCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/24.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class FanceInfoHeaderCell: UICollectionViewCell {
static let reuseID =  "FanceInfoHeaderCell"
    
    
    @IBOutlet weak var lab_user_easyinfo: UILabel!
    @IBOutlet weak var lab_user_name: UILabel!
    @IBOutlet weak var lab_follow_num: UILabel!
    @IBOutlet weak var lab_fance_num: UILabel!
    @IBOutlet weak var lab_postnum: UILabel!
    @IBOutlet weak var userIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

 
   func updateCell(info:UserInfo?){
    userIcon.setImageUrl(image: userIcon, string: info?.icon, proimage: #imageLiteral(resourceName: "IMG_2507"))
    lab_postnum.text = "\(info?.postNum ?? 0)"
    lab_fance_num.text = "\(info?.fances ?? 0)"
    lab_follow_num.text = "\(info?.follows ?? 0)"
    lab_user_name.text = info?.nickName ?? ""
    lab_user_easyinfo.text = info?.easyInfo ?? ""
    
    }
    
}
