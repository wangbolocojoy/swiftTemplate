//
//  MainTabController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
  
    lazy var imagelist = [#imageLiteral(resourceName: "图片"),#imageLiteral(resourceName: "地址"),#imageLiteral(resourceName: "bookmark"),#imageLiteral(resourceName: "评论"),#imageLiteral(resourceName: "关于"),#imageLiteral(resourceName: "退出登录")]
    lazy var imagelist1  = [#imageLiteral(resourceName: "图片"),#imageLiteral(resourceName: "地址"),#imageLiteral(resourceName: "bookmark"),#imageLiteral(resourceName: "评论"),#imageLiteral(resourceName: "关于"),#imageLiteral(resourceName: "退出登录")]
    var itemsname = ["",""]
    
    @IBOutlet weak var tablebar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        creatSubViewControllers()
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
        log.verbose("选择\(item.title)")
    }
    
    func creatSubViewControllers(){
        
        let homenvc = getNavc(vc: .首页nav)
        if #available(iOS 13.0, *) {
            let item1 : UITabBarItem = UITabBarItem (title: "首页", image:UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
         homenvc.tabBarItem = item1
        } else {
              let item1 : UITabBarItem = UITabBarItem (title: "首页", image:UIImage(named: "tabhomeun"), selectedImage: UIImage(named: "tabhome"))
            homenvc.tabBarItem = item1
        }
       
        
        let dyncnvc = getNavc(vc: .发现nav)
      if #available(iOS 13.0, *) {
                 let item1 : UITabBarItem = UITabBarItem (title: "发现", image:UIImage(systemName: "circle.grid.hex"), selectedImage: UIImage(systemName: "circle.grid.hex.fill"))
              dyncnvc.tabBarItem = item1
             } else {
                   let item1 : UITabBarItem = UITabBarItem (title: "发现", image:UIImage(named: "tabdypostun"), selectedImage: UIImage(named: "tabdypostun"))
                 dyncnvc.tabBarItem = item1
             }
        
      
        
        let fridnvc = getNavc(vc: .推荐nav)
      if #available(iOS 13.0, *) {
                      let item1 : UITabBarItem = UITabBarItem (title: "推荐", image:UIImage(systemName: "person.2.square.stack"), selectedImage: UIImage(systemName: "person.2.square.stack.fill"))
                   fridnvc.tabBarItem = item1
                  } else {
                        let item1 : UITabBarItem = UITabBarItem (title: "推荐", image:UIImage(named: "tabfridun"), selectedImage: UIImage(named: "tabfrid"))
                      fridnvc.tabBarItem = item1
                  }
      
        
        let minenvc = getNavc(vc: .我的nav)
        if #available(iOS 13.0, *) {
                             let item1 : UITabBarItem = UITabBarItem (title: "我的", image:UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
                          minenvc.tabBarItem = item1
                         } else {
                               let item1 : UITabBarItem = UITabBarItem (title: "我的", image:UIImage(named: "tabmineun"), selectedImage: UIImage(named: "tabmine"))
                             minenvc.tabBarItem = item1
                         }
      
        
        let tabArray = [homenvc, dyncnvc, fridnvc,minenvc]
        self.viewControllers = tabArray
    }
    
    
}
