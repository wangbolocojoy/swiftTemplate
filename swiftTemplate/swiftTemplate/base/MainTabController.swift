//
//  MainTabController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //保存数据
        UserDefaults.User.set(value: "1355024547", forKey: .手机号)
        
        //获取数据
//        let phone = UserDefaults.User.getvalue(forKey: .手机号) as? String
    }
    


}
