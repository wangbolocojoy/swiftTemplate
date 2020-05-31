//
//  Constant.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import UIKit
struct Constant {
    
    static let instance = Constant()
    static let BackGround = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    static let DarkBackGround = #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    static let 密码:String = "PASSWORD"
    static let 账号:String = "PHONE"
    var BaseApi :String{
        #if DEBUG
//        return "http://192.168.0.46:8072"
        //return "http://192.168.0.51:8072"
//        return "http://192.168.0.46:8072"
        return "http://192.168.0.4:8071"
        #else
        return "http://192.168.31.179:8071"
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
