//
//  BaseViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - Vc基类
import UIKit

class BaseViewController: UIViewController ,UIGestureRecognizerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseinitView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:#imageLiteral(resourceName: "back"), style: .plain, target:self, action: #selector(back))
        initView()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    /// 初始化该vc
    func initView(){
        
    }
    func BaseinitView(){
        if #available(iOS 13.0, *) {
            let backgroundColor = UIColor { (trainCollection) -> UIColor in
                switch trainCollection.userInterfaceStyle {
                case .dark:
                    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .clear), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    
                    self.navigationController?.navigationBar.tintColor = .white
                    return Constant.DarkBackGround
                case .light:
                    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: .clear), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    
                    self.navigationController?.navigationBar.tintColor = .black
                    return Constant.BackGround
                default:
                    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    
                    self.navigationController?.navigationBar.tintColor = .black
                    return Constant.BackGround
                }
            }
            self.view.backgroundColor = backgroundColor
            
        } else {
            //
            self.view.backgroundColor = Constant.BackGround
            
            
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                switch previousTraitCollection?.userInterfaceStyle {
                case .dark:
                    log.verbose("Dark")
                    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: Constant.BackGround), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    self.view.backgroundColor = Constant.BackGround
                    self.navigationController?.navigationBar.tintColor = .black
                    
                case .light:
                       log.verbose("light")
                    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: Constant.DarkBackGround), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    self.view.backgroundColor = Constant.DarkBackGround
                    self.navigationController?.navigationBar.tintColor = .white
                    
                default:
                     log.verbose("default")
                    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    self.view.backgroundColor = Constant.BackGround
                    self.navigationController?.navigationBar.tintColor = .black
                    
                }
            }
        } else {
            log.verbose("else")
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
            self.navigationController?.navigationBar.tintColor = .black
            self.view.backgroundColor = Constant.BackGround
        } }
    
}
