//
//  KtTestViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 测试
import UIKit

class KtTestViewController: BaseViewController {
    
    
    
    @IBOutlet weak var imageheart: UIImageView!
    @IBOutlet weak var tebutton: UIButton!
    @IBOutlet weak var viewheart: UIView!
    @IBOutlet weak var collectionactivity: UIImageView!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var banner: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func initView() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(showheart))
        let moreTap = UITapGestureRecognizer(target: self, action: #selector(towheart))
        //触发响应的点击次数
        moreTap.numberOfTapsRequired = 2
        banner.isUserInteractionEnabled = true
        /**
         检测手势识别器方法
         moreTap.require(toFail: singleTap)
         优先检测singleTap,若singleTap检测不到，或检测失败，则检测moreTap,检测成功后，触发方法
         singleTap.require(toFail: moreTap)
         优先检测moreTap,若moreTap检测不到，或检测失败，则检测singleTap,检测成功后，触发方法
         */
        var arr = [UIImage]()
        let w : CGFloat = 18
        for i in 0 ..< 6 {
          UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: w), false, 0)
          let context = UIGraphicsGetCurrentContext()!
          context.setFillColor(UIColor.red.cgColor)
          let ii = CGFloat(i)
          let rect = CGRect(x: ii, y:ii, width: w-ii*2, height: w-ii*2)
          context.addEllipse(in: rect)
          context.fillPath()
          let im = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()
          arr.append(im)
        }
        let im = UIImage.animatedImage(with: arr, duration: 0.5)
        self.tebutton.setImage(im, for: .normal)
        banner.addGestureRecognizer(singleTap)
        banner.addGestureRecognizer(moreTap)
        singleTap.require(toFail: moreTap)
        
    }
    @IBAction func btn_collection(_ sender: Any) {
        
    }
    @objc func showheart(){
        log.info("单机")
    }
    @objc func towheart(){
         log.info("双击")
        self.viewheart.isHidden = false
        let size = viewheart.frame
        UIView.animate(withDuration: 0.3, animations: {
           self.viewheart.transform = CGAffineTransform.identity
            .scaledBy(x: 1.5, y: 1.5)
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                 self.viewheart.transform = CGAffineTransform.identity
                    .rotated(by:CGFloat(Double.pi/4))
                .scaledBy(x: 1, y: 1)
            }) { (Bool) in
                UIView.animate(withDuration: 0.6, animations: {
                    self.viewheart.transform = CGAffineTransform.identity
                        .translatedBy(x:  (self.imageheart.center.x - self.viewheart.center.x) , y: (self.imageheart.center.y - self.viewheart.center.y))
                                                            .rotated(by:CGFloat(Double.pi*4))
                                                               .scaledBy(x: 0.5, y: 0.5)
                        
                }) { (Bool) in
                    self.imageheart.tintColor = .red
                    self.imageheart.image = UIImage(systemName: "suit.heart.fill")
                     self.viewheart.transform = CGAffineTransform.identity
                    self.viewheart.isHidden = true
                }
                
            }
//
        }
//        viewheart.ani
    }
    
    
}
