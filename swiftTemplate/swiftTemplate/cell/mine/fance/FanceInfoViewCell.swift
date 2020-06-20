//
//  FanceInfoViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class FanceInfoViewCell: UITableViewCell {
static let reuseID =  "FanceInfoViewCell"
    
    @IBOutlet weak var btn_follow: UIView!
    
    @IBOutlet weak var image_fanceicon: UIImageView!
    @IBOutlet weak var lab_fanceeasyinfo: UILabel!
    @IBOutlet weak var lab_fancenickname: UILabel!
    @IBOutlet weak var btn_post: UIView!
    @IBOutlet weak var btn_fance: UIView!
    @IBOutlet weak var lab_follownum: UILabel!
    @IBOutlet weak var post_num: UILabel!
    @IBOutlet weak var lab_fancenum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    func updateCell(user:UserInfo?){
        lab_fancenum.text = "\(user?.fances ?? 0)"
        lab_follownum.text = "\(user?.follows ?? 0)"
        post_num.text = "\(user?.likeStarts ?? 0)"
        lab_fancenickname.text = user?.nickName ?? ""
        lab_fanceeasyinfo.text = user?.easyInfo ?? ""
        image_fanceicon.setImageUrl(user?.icon, proimage: #imageLiteral(resourceName: "IMG_2506"))
    }
    
}
