//
//  FlashScreenViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class FlashScreenViewController: BaseViewController {
    let time = 1.0
    let time1 = 0.5
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRootVc()
    }
    func checkRootVc(){
        let user = UserInfoHelper.instance.user
        if user?.phone != nil && user?.token != nil {
            UIView.animate(withDuration: time1, animations:{ }, completion: { (true) in
                let tranststion =  CATransition()
                tranststion.duration = self.time1
                tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                UIApplication.shared.windows[0].layer.add(tranststion, forKey: "animation")
                UIApplication.shared.windows[0].rootViewController = self.getMainVc()
            })
        }else{
            UIView.animate(withDuration: time1, animations:{ }, completion: { (true) in
                let tranststion =  CATransition()
                tranststion.duration = self.time1
                tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                UIApplication.shared.windows[0].layer.add(tranststion, forKey: "animation")
                UIApplication.shared.windows[0].rootViewController = self.getloginVc()
            })
        }
        
        
    }
    
}
