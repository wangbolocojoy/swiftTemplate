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
    @IBOutlet weak var btn_post: UIView!
    @IBOutlet weak var btn_guanzhu: UIView!
    
    @IBOutlet weak var btn_fance: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(toUserinfo))
        img_usericon.isUserInteractionEnabled = true
        img_usericon.addGestureRecognizer(tap)
        let tappost =  UITapGestureRecognizer(target: self, action: #selector(toMyPost))
        btn_post.isUserInteractionEnabled = true
        btn_post.addGestureRecognizer(tappost)
        let tapfance =   UITapGestureRecognizer(target: self, action: #selector(toMyFance))
        btn_fance.isUserInteractionEnabled = true
        btn_fance.addGestureRecognizer(tapfance)
        let tapfollow =  UITapGestureRecognizer(target: self, action: #selector(toMyFollow))
        btn_guanzhu.isUserInteractionEnabled = true
        btn_guanzhu.addGestureRecognizer(tapfollow)
    }
    
    
    @objc func toMyFance(){
        let vc = self.parentViewController()?.getVcByName(vc: .我的粉丝关注) as! BTMMyFanceFollowViewController
        vc.type = 1
        self.pushVC(vc: vc )
        
    }
    @objc func toMyFollow(){
        let vc = self.parentViewController()?.getVcByName(vc: .我的粉丝关注) as! BTMMyFanceFollowViewController
        vc.type = 2
        self.pushVC(vc: vc )
    }
    
    @objc func toMyPost(){
        self.pushVC(vc: (self.parentViewController()?.getVcByName(vc: .我的帖子))!)
        
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
        lab_useresayinfo.text = user?.seayinfo
        versionname.text = Constant.instance.版本环境
    }
    
}
