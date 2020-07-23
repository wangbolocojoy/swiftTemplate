//
//  KtCheckBox.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

@IBDesignable class KtCheckBox: UIView {
static let reuseID =  "KtCheckBox"
  var contentView :UIView!
     var ischeck = false
    
    @IBOutlet weak var checkbtn: UIImageView!
    override init(frame: CGRect) {
          super.init(frame: frame)
          contentView = loadViewFromNib()
          addSubview(contentView)
          addConstraints()
          //初始化属性配置
          initial()
      }
      
      //初始化时将xib中的view添加进来
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          contentView = loadViewFromNib()
          addSubview(contentView)
          addConstraints()
          //初始化属性配置
          initial()
      }
      //加载xib
      func loadViewFromNib() -> UIView {
          let className = type(of: self)
          let bundle = Bundle(for: className)
          let name = NSStringFromClass(className).components(separatedBy: ".").last
          let nib = UINib(nibName: name!, bundle: bundle)
          let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
          return view
      }
      //设置好xib视图约束
      func addConstraints() {
          contentView.translatesAutoresizingMaskIntoConstraints = false
          var constraint = NSLayoutConstraint(item: contentView, attribute: .leading,
                                              relatedBy: .equal, toItem: self, attribute: .leading,
                                              multiplier: 1, constant: 0)
          addConstraint(constraint)
          constraint = NSLayoutConstraint(item: contentView, attribute: .trailing,
                                          relatedBy: .equal, toItem: self, attribute: .trailing,
                                          multiplier: 1, constant: 0)
          addConstraint(constraint)
          constraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal,
                                          toItem: self, attribute: .top, multiplier: 1, constant: 0)
          addConstraint(constraint)
          constraint = NSLayoutConstraint(item: contentView, attribute: .bottom,
                                          relatedBy: .equal, toItem: self, attribute: .bottom,
                                          multiplier: 1, constant: 0)
          addConstraint(constraint)
      }
    func  initial(){
        
    }
    public func ischeckd() -> Bool{
          if ischeck {
              checkbtn.image = #imageLiteral(resourceName: "check_boxs")
          }else{
              checkbtn.image = #imageLiteral(resourceName: "check-box")
          }
          return ischeck
      }
      
      public func setcheck(isheck :Bool){
          self.ischeck = isheck
          if ischeck{
               checkbtn.image = #imageLiteral(resourceName: "check_boxs")
          }else{
                checkbtn.image = #imageLiteral(resourceName: "check-box")
          }
      }
}
