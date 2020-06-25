//
//  FanceORFollowCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/10.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class FanceORFollowCell: UITableViewCell {
static let reuseID =  "FanceORFollowCell"
    typealias swiftblockFollow = (_ index:Int,_ user:UserInfo?) -> Void
      var callBack :swiftblockFollow?
      func callBackBlock(block : @escaping swiftblockFollow)  {
            callBack = block
    }
    var user:UserInfo? = nil
    var index:Int = 0
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
    func updateCell(i:Int,u:UserInfo?){
        index = i
        user = u
        user_name.text = u?.nickName ?? ""
        user_info.text = u?.easyInfo ?? ""
        lab_isfollow.setTitle(u?.isFollow ?? false  ? "以关注" : "未关注", for: .normal)
        icon_image.setImageUrl(image: icon_image,string: u?.icon ?? "", proimage: #imageLiteral(resourceName: "IMG_2507"))
    }
    @IBAction func followorunfollow(_ sender: Any) {
        if  callBack != nil {
            callBack!(index,user)
        }
    }
    
    
}
