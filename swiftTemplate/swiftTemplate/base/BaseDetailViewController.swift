//
//  BaseDetailViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class BaseDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         BaseinitView()
        initView()
    }
    /// 初始化该vc
       func initView(){
           
       }
    func BaseinitView(){
             if #available(iOS 13.0, *) {
                       log.debug("13.0")
                       let backgroundColor = UIColor { (trainCollection) -> UIColor in
                           
                           switch trainCollection.userInterfaceStyle {
                           case .dark:
                               log.debug("dark")
                               return Constant.DarkBackGround
                           case .light:
                               log.debug("light")
                               

                               return Constant.BackGround
                           default:
                               log.debug("default")

                               return Constant.BackGround
                           }
                       }
                       self.view.backgroundColor = backgroundColor
                       
                   } else {
           //
                       self.view.backgroundColor = Constant.BackGround

                       
                   }
       }

  
}
