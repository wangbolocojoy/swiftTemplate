//
//  FanceORFollowCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/10.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class FanceORFollowCell: UITableViewCell {
static let reuseID =  "FanceORFollowCell"
   
    var user:UserInfo? = nil
    @IBOutlet weak var lab_isfollow: UIButton!
    @IBOutlet weak var user_info: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var icon_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    func updateCell(u:UserInfo?){
        user_name.text = u?.nickname ?? ""
        user_info.text = u?.seayinfo ?? ""
        lab_isfollow.setTitle(u?.isfollow ?? false  ? "以关注" : "未关注", for: .normal)
        icon_image.setImageUrl(u?.icon ?? "", proimage: #imageLiteral(resourceName: "IMG_2507"))
    }
    @IBAction func followorunfollow(_ sender: Any) {
        
    }
    
    
}
