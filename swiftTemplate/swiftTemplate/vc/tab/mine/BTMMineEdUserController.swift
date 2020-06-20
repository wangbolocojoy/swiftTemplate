//
//  BTMMineEdUserController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/7.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 修改用户信息
import UIKit

class BTMMineEdUserController: BaseViewController {
    var type :String? = nil
    @IBOutlet weak var lab_test: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(save))
    }
    override func initView() {
        switch type ?? "" {
        case "昵称":
            lab_test.placeholder = "请输入昵称"
        case "个人简介":
            lab_test.placeholder = "请输入个人简介"
        case "地区":
            lab_test.placeholder = "请输入地区"
        case "真实姓名":
            lab_test.placeholder = "请输入真实姓名"
        default:
            lab_test.placeholder = ""
        }
    }
    @objc func save(){
        let body = RequestBody()
        body.id = UserInfoHelper.instance.user?.id ?? 0
        switch type ?? "" {
        case "昵称":
            body.nickName =  lab_test.text
        case "个人简介":
            body.easyInfo =  lab_test.text
        case "地区":
            body.address =  lab_test.text
        case "真实姓名":
            body.realName =  lab_test.text
        default:
            lab_test.placeholder = ""
        }
        MyMoyaManager.AllRequest(controller: self, NetworkService.updateuserinfo(k: body.toJSONString() ?? "")) { (data) in
            UserInfoHelper.instance.user = data.userinfo
          
            self.ShowTipsClose(tite: data.msg ?? "更新成功")
        }
    }
    
    
    
}
