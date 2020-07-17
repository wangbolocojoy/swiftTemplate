//
//  MainTabController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    lazy var homenvc = getNavc(vc: .首页nav)
    lazy var dyncnvc = getNavc(vc: .发现nav)
    lazy var fridnvc = getNavc(vc: .推荐nav)
    lazy var minenvc = getNavc(vc: .我的nav)
    
    lazy var items = [homenvc,dyncnvc,fridnvc,minenvc]
    @IBOutlet weak var tablebar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = items
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
        log.verbose("选择\(item.title)")
        
    }

}
