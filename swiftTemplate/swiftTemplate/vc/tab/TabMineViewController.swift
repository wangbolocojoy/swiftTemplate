//
//  TabMineViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 我的
import UIKit

class TabMineViewController: BaseTabViewController {
    let time = 0.2
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func loginout(_ sender: Any) {
        KeychainManager.User.DeleteByIdentifier(forKey: .UserInfo)
        
        UIView.animate(withDuration: time, animations:{ }, completion: { (true) in
            let tranststion =  CATransition()
            tranststion.duration = self.time
            tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
            UIApplication.shared.keyWindow?.rootViewController = self.getloginVc()
            
            
        })
    }
    
}
