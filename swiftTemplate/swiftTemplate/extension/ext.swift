//
//  vc.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    
       func Showalert(Title:String?)  {
           let TipsActionSheet : UIAlertController = UIAlertController(title: "温馨提示", message: Title ?? "", preferredStyle: UIAlertController.Style.alert)
           TipsActionSheet.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (UIAlertAction) in
               TipsActionSheet.dismiss(animated: true, completion: nil)
           }))
           self.present(TipsActionSheet, animated: true, completion: nil)
          
       }
       //显示消息一秒关闭弹窗并结束VC
       func ShowTipsClose(tite:String?)  {
           let TipsActionSheet : UIAlertController = UIAlertController(title: tite, message: nil, preferredStyle: UIAlertController.Style.alert)
         
           self.present(TipsActionSheet, animated: true, completion: nil)
           Taolsterhelper.instance.delay(by: 1) {
               TipsActionSheet.dismiss(animated: true, completion: nil)
               self.navigationController?.popViewController(animated: true)
           }
           
       }
       //显示消息一秒关闭弹窗
       func ShowTip(Title:String?){
           let TipsActionSheet : UIAlertController = UIAlertController(title: Title, message: nil, preferredStyle: UIAlertController.Style.alert)
           self.present(TipsActionSheet, animated: true, completion: nil)
           Taolsterhelper.instance.delay(by: 1) {
               TipsActionSheet.dismiss(animated: true, completion: nil)
           }
       }
       
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    @available(iOS 11, *)
    var customAccent: UIColor! {
        return UIColor(named: "tabcolor1")
    }
}
struct Taolsterhelper {
    static var instance = Taolsterhelper()
    init() {
        
    }
    /// 代码延迟运行
    /// - Parameters:
    ///   - delayTime: 延时时间。比如：.seconds(5)、.milliseconds(500)
    ///   - qosClass: 要使用的全局QOS类（默认为 nil，表示主线程）
    ///   - closure: 延迟运行的代码
    public func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil,
                      _ closure: @escaping () -> Void) {
        let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
        dispatchQueue.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: closure)}
}
