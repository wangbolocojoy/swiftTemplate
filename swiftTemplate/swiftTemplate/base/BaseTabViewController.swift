//
//  BaseTabViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - TabVc
import UIKit
import MJRefresh
class BaseTabViewController: UIViewController {
    var isdark = false
    let header = MJRefreshGifHeader()
    let footer = MJRefreshBackFooter()
    override func viewDidLoad() {
        super.viewDidLoad()
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        BaseinitView()
        initView()
    }
    func  initView(){
      
    }
    func BaseinitView(){
        if #available(iOS 13.0, *) {
            let backgroundColor = UIColor { (trainCollection) -> UIColor in
                switch trainCollection.userInterfaceStyle {
                case .dark:
//                    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                                      self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                                      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                                      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                                      
                                      self.navigationController?.navigationBar.tintColor = .white
                    return Constant.DarkBackGround
                    
                case .light:
//                    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    
                    self.navigationController?.navigationBar.tintColor = .black
                    return Constant.BackGround
                default:
//                    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    
                    self.navigationController?.navigationBar.tintColor = .black
                    
                    return Constant.BackGround
                }
            }
            self.view.backgroundColor = backgroundColor
            
        } else {
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: Constant.BackGround), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
            self.view.backgroundColor = Constant.BackGround
            self.navigationController?.navigationBar.tintColor = .black
            
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                switch previousTraitCollection?.userInterfaceStyle {
                case .dark:
//                    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: Constant.BackGround), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    self.view.backgroundColor = Constant.BackGround
                    self.navigationController?.navigationBar.tintColor = .black
                    
                case .light:
//                    self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: Constant.DarkBackGround), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    self.view.backgroundColor = Constant.DarkBackGround
                    self.navigationController?.navigationBar.tintColor = .white
                    
                default:
//                    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                    self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
                    self.view.backgroundColor = Constant.BackGround
                    self.navigationController?.navigationBar.tintColor = .black
                    
                }
            }
        } else {
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .clear)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]
            self.navigationController?.navigationBar.tintColor = .black
            self.view.backgroundColor = Constant.BackGround
        } }
    


}
