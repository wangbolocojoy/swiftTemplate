//
//  Constant.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import UIKit

enum MyController{
    case 注册
    case 个人中心
    case 修改信息
    case 我的帖子
    case 我的粉丝关注
    case 发帖
    case 粉丝详情
    case 我的图片
    case 我的地址
    case 我的朋友
    case 我的消息
    case 我的设置
    case 我的二维码
}

enum PictureType{
    case 原图加水印
    case 原图
    case 压缩90
    case 压缩90水印
    case 压缩80
    case 压缩80水印
    case 压缩70
    case 压缩70水印
}

extension UIViewController{
    
    func getMainVc () -> UITabBarController{
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MAINTABVC") as! MainTabController
        return vc
    }
    func getloginVc() -> UINavigationController{
        let sb = UIStoryboard.init(name: "NewLogin", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LOGINNAVVC") as! LoginNavViewController
        return vc
    }
    
    func getVcByName(vc:MyController) -> UIViewController{
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        log.info(" -----  \(vc.self)")
        switch vc {
        case .注册:
            let vc = UIStoryboard.init(name: "NewLogin", bundle: nil).instantiateViewController(withIdentifier: "REGISTERVC") as! RegisterViewController
            return vc
        case .个人中心:
            let vc = sb.instantiateViewController(withIdentifier: "BTMUSERINFOVC") as! BTMUserInfoController
            return vc
        case .修改信息:
            let vc = sb.instantiateViewController(withIdentifier: "BTMMINEEDUSERVC") as! BTMMineEdUserController
            return vc
        case .我的帖子:
            let vc = sb.instantiateViewController(withIdentifier: "BTMMYPOSTVC") as!
            BTMMyPostViewController
            return vc
        case .我的粉丝关注:
            let vc = sb.instantiateViewController(withIdentifier: "BTMMYFANCEFOLLOWVC") as!
            BTMMyFanceFollowViewController
            return vc
        case .发帖:
            let vc = sb.instantiateViewController(withIdentifier: "SENDPOSTVC") as! SendPostViewController
            return vc
        case .粉丝详情:
            let vc = sb.instantiateViewController(withIdentifier: "FANCESINFOVC") as! FancesInfoViewController
            return vc
        case .我的图片:
            let vc = sb.instantiateViewController(withIdentifier: "MYPICTUREVC") as! MyPictureViewController
            return vc
        case .我的地址:
            let vc = sb.instantiateViewController(withIdentifier: "MYADDRESSVC") as! MyAddressViewController
            return vc
        case .我的朋友:
            let vc = sb.instantiateViewController(withIdentifier: "MYFRIENDSVC") as! MyFriendsViewController
            return vc
        case .我的消息:
            let vc = sb.instantiateViewController(withIdentifier: "MYMESSAGEVC") as! MyMessageViewController
            return vc
        case .我的设置:
            let vc = sb.instantiateViewController(withIdentifier: "MYSETTINGVC") as! MySettingViewController
            return vc
        case .我的二维码:
            let vc = sb.instantiateViewController(withIdentifier: "BTMMYQRCODEVC") as! BTMMyQRCodeViewController
            return vc
        }
    }
}

struct Constant {
    
    static let instance = Constant()
    static let BackGround = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    static let DarkBackGround = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    static let 密码:String = "PASSWORD"
    static let 账号:String = "PHONE"
    
    
    
    
}
