//
//  BTMMineEdUserController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/7.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 修改用户信息
import UIKit

class BTMMineEdUserController: BaseViewController {
    var type :String? = nil
    @IBOutlet weak var lab_test: UITextField!
    @IBOutlet weak var ev_background: UIView!
    lazy var user = UserInfoHelper.instance.user
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showedv))
        ev_background.isUserInteractionEnabled = true
        ev_background.addGestureRecognizer(tap)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .done, target: self, action: #selector(save))
    }
    @objc func showedv(){
        lab_test.becomeFirstResponder()
    }
    override func initView() {
        switch type ?? "" {
        case "昵称":
            if user?.nickName != nil{
                lab_test.text = user?.nickName ?? ""
            }else{
                lab_test.placeholder = "请输入你喜欢的昵称"
            }
            
            
        case "个人简介":
            if user?.easyInfo != nil{
                lab_test.text = user?.easyInfo ?? ""
            }else{
                lab_test.placeholder = "请输入个人简介"
            }
            
        case "地区":
            if user?.address != nil{
                lab_test.text = user?.address ?? ""
            }else{
                lab_test.placeholder = "请输入地区"
            }
            
        case "真实姓名":
            if user?.realName != nil{
                lab_test.text = user?.realName ?? ""
            }else{
                lab_test.placeholder = "请输入真实姓名"
            }
        default:
            lab_test.placeholder = ""
        }
    }
    @objc func save(){
        let body = RequestBody()
        body.id = user?.id ?? 0
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
