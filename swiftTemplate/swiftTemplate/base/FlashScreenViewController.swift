//
//  FlashScreenViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class FlashScreenViewController: BaseViewController {
    let time = 0.5
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRootVc()
    }
    func checkRootVc(){
        let user = UserInfoHelper.instance.user 
        UIView.animate(withDuration: time, animations:{
            let tranststion =  CATransition()
            tranststion.duration = self.time
            tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            UIApplication.shared.windows[0].layer.add(tranststion, forKey: "animation")
        }, completion: { (true) in
            if user?.phone != nil && user?.token != nil {
                UIApplication.shared.windows[0].rootViewController = self.getMainVc()
            }else{
                
                UIApplication.shared.windows[0].rootViewController = self.getloginVc()
            }
            
        })
    }
    
}
