//
//  MineUserInfoViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/6.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class MineUserInfoViewCell: UITableViewCell {
static let reuseID =  "MineUserInfoViewCell"
   
    @IBOutlet weak var lab_guanzhunumber: UILabel!
    @IBOutlet weak var lab_userfancenumber: UILabel!
    @IBOutlet weak var lab_userpostnumber: UILabel!
    @IBOutlet weak var img_usericon: UIImageView!
    @IBOutlet weak var lab_nickname: UILabel!
    @IBOutlet weak var lab_useresayinfo: UILabel!
    @IBOutlet weak var view_version: UIView!
    @IBOutlet weak var versionname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(toUserinfo))
        img_usericon.isUserInteractionEnabled = true
        img_usericon.addGestureRecognizer(tap)
    }

    @objc func toUserinfo(){
        self.pushVC(vc: (self.parentViewController()?.getVcByName(vc: .个人中心))!)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func updateCell(user:UserInfo?){
        img_usericon.setImageUrl(user?.icon ?? "", proimage: #imageLiteral(resourceName: "IMG_2506"))
        lab_nickname.text = user?.nickname ?? "SuperHero"
        versionname.text = Constant.instance.版本环境
    }
    
}
