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
        checkRsa()
        checkRootVc()
    }
    func checkRsa(){
        let puk = KeychainManager.User.ReadDataByIdentifier(forKey: .公钥) as? String
        let prk = KeychainManager.User.ReadDataByIdentifier(forKey: .私钥) as? String
        if puk == nil || prk == nil {
            RsaUtil.default.creatPublicAndPrivateKey(publicKeyTag: ApiKey.default.RSAPUK, privateKeyTag: ApiKey.default.RSAPRK)
            log.verbose("第一次生成公私钥")
        }else{
            log.info("已经生成公私钥")
        }
    }
    func checkRootVc(){
            UIView.animate(withDuration: time1, animations:{ }, completion: { (true) in
                           let tranststion =  CATransition()
                           tranststion.duration = self.time1
                           tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                           UIApplication.shared.windows[0].layer.add(tranststion, forKey: "animation")
                           UIApplication.shared.windows[0].rootViewController = self.getMainVc()
                       })
        
    }
    
}
