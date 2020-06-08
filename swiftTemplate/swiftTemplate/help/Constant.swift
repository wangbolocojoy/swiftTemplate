//
//  Constant.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import UIKit

enum MyController{
    case 注册
    case 个人中心
    case 修改信息
    case 我的帖子
    case 我的粉丝关注
}

extension UIViewController{
    
    func getMainVc () -> UITabBarController{
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MAINTABVC") as! MainTabController
        return vc
    }
    func getloginVc() -> UINavigationController{
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LOGINNAVVC") as! LoginNavViewController
        return vc
    }
    
    func getVcByName(vc:MyController) -> UIViewController{
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        switch vc {
        case .注册:
            let vc = sb.instantiateViewController(withIdentifier: "REGISTERVC") as! RegisterViewController
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
        }
    }
}

struct Constant {
    
    static let instance = Constant()
    static let BackGround = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    static let DarkBackGround = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    static let 密码:String = "PASSWORD"
    static let 账号:String = "PHONE"
    var BaseApi :String{
        #if DEBUG
        
        return "https://90btm.com"
        #else
        return "https://90btm.com"
        #endif
    }
    var 版本环境:String{
        #if DEBUG
        return "测试版本"
        #else
        return "正式版本"
        #endif
    }
    
    
    
}
