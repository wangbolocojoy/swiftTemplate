//
//  FlashScreenViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class FlashScreenViewController: BaseViewController {
    let time = 0.5
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRootVc()
        
    }
    
    func checkRootVc(){
        let phone = KeychainManager.keyChainReadData(identifier: Constant.账号) as? String
        let pass = KeychainManager.keyChainReadData(identifier: Constant.密码) as? String
            UIView.animate(withDuration: time, animations:{ }, completion: { (true) in
                let tranststion =  CATransition()
                tranststion.duration = self.time
                tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                if pass != nil && phone != nil {
                    UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
                                   UIApplication.shared.keyWindow?.rootViewController = self.getMainVc()
                }else{
                    UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
                                   UIApplication.shared.keyWindow?.rootViewController = self.getloginVc()
                }
               
            })
       
        
    }

}
