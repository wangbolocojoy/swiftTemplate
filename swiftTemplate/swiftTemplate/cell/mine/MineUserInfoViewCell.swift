//
//  MineUserInfoViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/6.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class MineUserInfoViewCell: UITableViewCell {
    static let reuseID =  "MineUserInfoViewCell"
    @IBOutlet weak var lab_guanzhunumber: UILabel!
    @IBOutlet weak var lab_userfancenumber: UILabel!
    @IBOutlet weak var lab_userpostnumber: UILabel!
    
    @IBOutlet weak var user_icon: RainbowRing!
    @IBOutlet weak var lab_nickname: UILabel!
    @IBOutlet weak var lab_useresayinfo: UILabel!
    @IBOutlet weak var view_version: UIView!
    @IBOutlet weak var versionname: UILabel!
    @IBOutlet weak var btn_post: UIView!
    @IBOutlet weak var btn_guanzhu: UIView!
    
    @IBOutlet weak var btn_fance: UIView!
    
    @IBOutlet weak var btn_qrcode: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(toUserinfo))
        user_icon.isUserInteractionEnabled = true
        user_icon.addGestureRecognizer(tap)
        let tappost =  UITapGestureRecognizer(target: self, action: #selector(toMyPost))
        btn_post.isUserInteractionEnabled = true
        btn_post.addGestureRecognizer(tappost)
        let tapfance =   UITapGestureRecognizer(target: self, action: #selector(toMyFance))
        btn_fance.isUserInteractionEnabled = true
        btn_fance.addGestureRecognizer(tapfance)
        let tapfollow =  UITapGestureRecognizer(target: self, action: #selector(toMyFollow))
        btn_guanzhu.isUserInteractionEnabled = true
        btn_guanzhu.addGestureRecognizer(tapfollow)
        view_version.isHidden = true
        let tapqrcode = UITapGestureRecognizer(target: self, action: #selector(toMyQrcode))
        btn_qrcode.isUserInteractionEnabled = true
        btn_qrcode.addGestureRecognizer(tapqrcode)
        if #available(iOS 13.0, *) {
            btn_qrcode.image = UIImage(systemName: "qrcode")
        } else {
            btn_qrcode.image = #imageLiteral(resourceName: "二维码")
        }
    }
    
    @objc func toMyQrcode() {
        if UserInfoHelper.instance.user?.id ?? 0 == 0 {
             let vc = self.parentViewController()?.getVcByName(vc: .登录) as! LoginViewController
                       vc.modalPresentationStyle = .fullScreen
                         self.preshVC(vc: vc)
        }else{
            let vc = self.parentViewController()?.getVcByName(vc: .我的二维码) as! BTMMyQRCodeViewController
            self.pushVC(vc: vc)
        }
        
        
    }
    
    @objc func toMyFance(){
        if UserInfoHelper.instance.user?.id ?? 0 == 0 {
            let vc = self.parentViewController()?.getVcByName(vc: .登录) as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
              self.preshVC(vc: vc)
        }else{
            let vc = self.parentViewController()?.getVcByName(vc: .我的粉丝关注) as! BTMMyFanceFollowViewController
            vc.type = 1
            self.pushVC(vc: vc )
        }
        
    }
    @objc func toMyFollow(){
        if UserInfoHelper.instance.user?.id ?? 0 == 0 {
              let vc = self.parentViewController()?.getVcByName(vc: .登录) as! LoginViewController
                       vc.modalPresentationStyle = .fullScreen
                         self.preshVC(vc: vc)
        }else{
            let vc = self.parentViewController()?.getVcByName(vc: .我的粉丝关注) as! BTMMyFanceFollowViewController
            vc.type = 2
            self.pushVC(vc: vc )
        }
        
        
    }
    
    @objc func toMyPost(){
        if UserInfoHelper.instance.user?.id ?? 0 == 0 {
              let vc = self.parentViewController()?.getVcByName(vc: .登录) as! LoginViewController
                       vc.modalPresentationStyle = .fullScreen
                         self.preshVC(vc: vc)
        }else{
            let vc = self.parentViewController()?.getVcByName(vc: .我的帖子) as! BTMMyPostViewController
            vc.vcname = "我的主页"
            vc.userid = UserInfoHelper.instance.user?.id ?? 0
            self.pushVC(vc: vc)
        }
        
        
    }
    
    @objc func toUserinfo(){
        if UserInfoHelper.instance.user?.id ?? 0 == 0 {
            
             let vc = self.parentViewController()?.getVcByName(vc: .登录) as! LoginViewController
                      vc.modalPresentationStyle = .fullScreen
                        self.preshVC(vc: vc)
        }else{
            self.pushVC(vc: (self.parentViewController()?.getVcByName(vc: .个人中心))!)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func updateCell(user:UserInfo?){
        user_icon.setimage(url: user?.icon ?? "")
        if UserInfoHelper.instance.user?.id ?? 0 == 0 {
            lab_nickname.text = user?.nickName ?? "注册登录"
            lab_useresayinfo.text = user?.easyInfo ?? ""
        }else{
            lab_nickname.text = user?.nickName ?? "还没想好"
            lab_useresayinfo.text = user?.easyInfo ?? "什么都没有留下"
        }
        versionname.text = ApiKey.default.版本环境
        lab_userpostnumber.text = "\(user?.postNum ?? 0)"
        lab_guanzhunumber.text = "\(user?.follows ?? 0)"
        lab_userfancenumber.text = "\(user?.fances ?? 0)"
    }
    
}
