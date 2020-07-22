//
//  vc.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
extension UIViewController{
    /// 弹框
    /// - Parameter Title: 内容
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
    
    /// 获取父VC
    /// - Returns: 父VC
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
    
    /// KF加载图片
    /// - Parameters:
    ///   - image: 需要设置图片的imageVIew
    ///   - string: 图片地址
    ///   - proimage: 占位图
    func setImageUrl(image:UIImageView, string : String?,proimage:UIImage?) {
        if string == nil{
            image.image = proimage
            return
        }
        let url = URL(string: string ?? "")
        
        if url == nil {
            image.image = proimage
            return
        }
        let imageResource = ImageResource(downloadURL: url!, cacheKey: string)
        image.kf.setImage(
            with: imageResource,
            placeholder: #imageLiteral(resourceName: "背景色"),
            options: [
                .backgroundDecode,
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage,
                .diskCacheExpiration(.days(10)),
                .diskCacheAccessExtendingExpiration(.cacheTime)
                
            ]
            
        )
        
        
       
       
    }
    func GetImageType(type:PictureType?)->String{
        switch type {
        case .压缩90水印:
            return "?x-oss-process=style/YS-SY-90"
        case .压缩90:
            return "?x-oss-process=style/YS-SY-90"
        case .压缩80水印:
            return "?x-oss-process=style/yasuo90"
        case .压缩80:
            return "?x-oss-process=style/YX-80"
        case .压缩70水印:
            return "?x-oss-process=style/yasuo90"
        case .压缩70:
            return "?x-oss-process=style/YS-70"
        case .原图加水印:
            return "?x-oss-process=style/yasuo90"
        default:
            return "?x-oss-process=style/yasuo90"
        }
    }
    /// 生产一个带头像的二维码
    /// - Parameters:
    ///   - imageView: UIImageview
    ///   - qrstring: 生产二维码需要的数据
    ///   - imagename: 二维码中间的图片
    open func creatQrcode(imageView:UIImageView,qrstring:String?,imagecenter:UIImage?) {
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
            let transform = CGAffineTransform.init(scaleX: 30, y: 30)
            image = image?.transformed(by: transform)
            
            // 图片处理
            var resultImage = UIImage(ciImage: image!)
            
            if let name  = imagecenter  {
                resultImage = getClearImage(sourceImage: resultImage, center: name)
              imageView.image = resultImage
            }else{
                 imageView.image = #imageLiteral(resourceName: "IMG_2488-1")
            }
            
        }else{
            imageView.image = #imageLiteral(resourceName: "IMG_2488-1")
        }
    }
    
    /// 使图片放大也可以清晰
    /// - Parameters:
    ///   - sourceImage: 二维码图片
    ///   - center: 二维码中间的图片
    /// - Returns: 返回合成的图片
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
extension UIImage{
    ///  根据颜色生产一张图片
    /// - Parameter color: 颜色
    /// - Returns: 图片
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    func downloadWith(urlStr: String, complete: ((UIImage?) -> ())? = nil) {
       if let url = URL(string: urlStr) {
           KingfisherManager.shared.retrieveImage(with: url) { (result) in
               switch result {
               case .success(let imgResult):
                   complete?(imgResult.image)
               case .failure(let error):
                   print(error)
                   complete?(nil)
               }
           }
       } else {
           complete?(nil)
       }
   }
    //二分压缩法
        func compressImageMid(maxLength: Int) -> Data? {
           var compression: CGFloat = 1
            var data = self.jpegData(compressionQuality: 1)!
            log.verbose( "压缩前:---- \( Double((data.count)/1024))kb")
           if data.count < maxLength {
               return data
           }
           var max: CGFloat = 1
           var min: CGFloat = 0
           for _ in 0..<4 {
               compression = (max + min) / 2
               data = jpegData(compressionQuality: compression)!
               if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                   min = compression
               } else if data.count > maxLength {
                   max = compression
               } else {
                   break
               }
           }
            var _: UIImage = UIImage(data: data)!
           if data.count < maxLength {
            log.verbose( "压缩后： \( Double((data.count)/1024))kb")
               return data
           }
             log.verbose( "压缩后: \( Double((data.count)/1024))kb")
            return data
    }
}
extension UITableViewCell {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    /// 扩展类获取cell所在的VC
    /// - Returns: 返回VC
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
    
    /// 扩展类PushVC
    /// - Parameter vc: VC
    func pushVC(vc:UIViewController){
        parentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UITableViewHeaderFooterView{
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
    func pushVC(vc:UIViewController){
           parentViewController()?.navigationController?.pushViewController(vc, animated: true)
       }
}
extension Int{
    var int32:Int32{
        return Int32(self) 
    }
}
extension Int32{
    var int32:Int{
           return Int(self)
    }
}

