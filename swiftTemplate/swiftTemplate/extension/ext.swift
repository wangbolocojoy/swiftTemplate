//
//  vc.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
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
extension BaseViewController{
    
    func parentViewController() -> UIViewController? {
        
        var n = self.next
        
        while n != nil {
            
            if (n is UIViewController) {
                
                return n as? UIViewController
            }
            
            n = n?.next
        }
        
        return nil
    }
}
extension UIImageView{
    func setImageUrl(_ string : String?,proimage:UIImage?) {
        if(string != nil){
            do {
                guard let url = try URL(string: string ?? "") ?? nil else { return   self.image = proimage }
                  self.af_setImage(withURL: url, placeholderImage: proimage)
            } catch  {
               
            }
        }
    }
    
}
extension UIImage{
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func creatQrcode(qrstring:String?,imagename:String?) -> UIImage?{
        if let qrs = qrstring {
             // 创建二维码滤镜
                   let filter = CIFilter(name: "CIQRCodeGenerator")
                   
                   // 恢复滤镜默认设置
                   filter?.setDefaults()
                   
                   // 设置滤镜输入数据
                    let data = qrs.data(using: String.Encoding.utf8)
                   filter?.setValue(data, forKey: "inputMessage")
                   
                   // 设置二维码的纠错率
                   filter?.setValue("M", forKey: "inputCorrectionLevel")
                   
                   // 从二维码滤镜里面, 获取结果图片
                   var image = filter?.outputImage
                   
                   // 生成一个高清图片
                   let transform = CGAffineTransform.init(scaleX: 20, y: 20)
                    image = image?.transformed(by: transform)
                   
                   // 图片处理
                   var resultImage = UIImage(ciImage: image!)
                    
            if let name  = imagename  {
                let center = UIImage(named: name)
                     resultImage = getClearImage(sourceImage: resultImage, center: center!)
                return resultImage
            }
            
            return resultImage
        
            
        }else{
            return nil
        }
    }
    // 使图片放大也可以清晰
       func getClearImage(sourceImage: UIImage, center: UIImage) -> UIImage {
           
           let size = sourceImage.size
           // 开启图形上下文
           UIGraphicsBeginImageContext(size)
           
           // 绘制大图片
           sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
           
           // 绘制二维码中心小图片
           let width: CGFloat = 80
           let height: CGFloat = 80
           let x: CGFloat = (size.width - width) * 0.5
           let y: CGFloat = (size.height - height) * 0.5
           center.draw(in: CGRect(x: x, y: y, width: width, height: height))
           
           // 取出结果图片
           let resultImage = UIGraphicsGetImageFromCurrentImageContext()
           
           // 关闭上下文
           UIGraphicsEndImageContext()
    
           return resultImage!
       }
}
