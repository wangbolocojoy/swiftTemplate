//
//  BTMMyQRCodeViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/24.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class BTMMyQRCodeViewController: BaseViewController {

    @IBOutlet weak var qr_code: UIImageView!
    @IBOutlet weak var user_sex: UIImageView!
    @IBOutlet weak var usre_address: UILabel!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_icon: UIImageView!
    let user = UserInfoHelper.instance.user
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    override func initView() {
        if user?.userSex ?? false {
            user_sex.tintColor = .systemPink
        }else{
             user_sex.tintColor = .blue
        }
        user_name.text = user?.nickName ?? ""
        usre_address.text = "\(user?.province ?? "")\(user?.city ?? "")"
        user_icon.setImageUrl(image: user_icon, string: user?.icon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        qr_code.creatQrcode(imageView: qr_code,qrstring: user?.account, imagecenter: user_icon.image)
    }
    

}

