//
//  KtInputView.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/27.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit



@IBDesignable class KtInputView: UIView {
    @IBOutlet weak var sendcomment: UIImageView!
    @IBOutlet weak var evcomment: UITextField!
    var contentView:UIView!
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        
        initview()
    }
    func initview(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(sendmessage))
        sendcomment.isUserInteractionEnabled = true
        sendcomment.addGestureRecognizer(tap)
        evcomment.delegate = self
    }
    
    @objc func sendmessage(){
        log.info("框架分开分开分开分开")
    }
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
         initview()
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
        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }
  
    
}
extension KtInputView:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        log.info("uytu")
    }
}
