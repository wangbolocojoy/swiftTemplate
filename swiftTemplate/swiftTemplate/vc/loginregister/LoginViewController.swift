//
//  LoginViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 登录
import UIKit

class LoginViewController: BaseTabViewController {
    let time = 0.2
    @IBOutlet weak var ev_password: UITextField!
    @IBOutlet weak var ev_phone: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    override func initView(){
        title = "登录"
        ev_phone.delegate = self
        ev_password.delegate = self
        ev_password.isSecureTextEntry = true
    }
    
    @IBAction func login(_ sender: Any) {
        let phone = ev_phone.text
        let password = ev_password.text
        if phone == nil || phone == "" || phone?.count ?? 0 != 11 {
            ShowTip(Title: "手机号码位数不对请重新输入")
            return
        }
        if !TextUntils.instance.isPhoneNumber(phoneNumber: phone ?? "") {
            ShowTip(Title: "手机号验证不通过")
            return
        }
        
        if password == nil || password == "" || password?.count ?? 0 < 6{
            ShowTip(Title: "密码位数能小于6位")
            return
        }
        if !TextUntils.instance.isPasswordRuler(password: password ?? "") {
            ShowTip(Title: "请输入大于6位字母和数字组合的密码")
            return
        }
        let body = RequestBody()
        body.phone = phone
        body.password = password
        MyMoyaManager.AllRequest(controller: self, NetworkService.login(k: body.toJSONString()!)) { (data) in
            if KeychainManager.User.SaveByIdentifier(data: data.userinfo?.toJSONString() ?? "", forKey: .UserInfo) {
                UserDefaults.User.set(value: data.userinfo?.token ?? "", forKey: .token)
                self.gotoMainVC()
            }else{
                
            }
        }
        
    }
    func gotoMainVC(){
        UIView.animate(withDuration: time, animations:{ }, completion: { (true) in
            let tranststion =  CATransition()
            tranststion.duration = self.time
            tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
            UIApplication.shared.keyWindow?.rootViewController = self.getMainVc()
            
            
        })
    }
    
    @IBAction func frogetpass(_ sender: Any) {
        let vc =  getVcByName(vc: .注册) as! RegisterViewController
        vc.type = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func gotoRegister(_ sender: Any) {
        let vc =  getVcByName(vc: .注册) as! RegisterViewController
        vc.type = 0
        vc.callBackBlock { (phone, passwd) in
            self.ev_phone.text = phone
            self.ev_password.text = passwd
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension LoginViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case ev_phone:
            let maxLength = 11
            let currentString: NSString = textField.text as? NSString ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case ev_password:
            let maxLength = 25
            let currentString: NSString = textField.text as? NSString ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            let maxLength = 1
            let currentString: NSString = textField.text as! NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
    }
}
