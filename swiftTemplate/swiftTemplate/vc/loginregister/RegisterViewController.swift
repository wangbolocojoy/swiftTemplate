//
//  RegisterViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 注册
import UIKit

class RegisterViewController: BaseViewController {
    var type = 0
    var countdownTimer : Timer?
    @IBOutlet weak var lab_zhuce: UIButton!
    @IBOutlet weak var lab_yanzhengma: UIButton!
    @IBOutlet weak var ev_password: UITextField!
    @IBOutlet weak var ev_msg: UITextField!
    @IBOutlet weak var ev_phone: UITextField!
    typealias swiftblockResult = (_ phone : String ,_ passwd:String) -> Void
    var callBack :swiftblockResult?
    func callBackBlock(block : @escaping swiftblockResult)  {
        callBack = block
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
    }
    func initView(){
        ev_password.delegate = self
        ev_msg.delegate = self
        ev_phone.delegate = self
        ev_password.isSecureTextEntry = true
        if type == 0 {
            title = "注册"
            lab_zhuce.setTitle("注册", for: .normal)
        }else{
            title = "修改密码"
            lab_zhuce.setTitle("修改密码", for: .normal)
        }
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        self.isCounting = true
    }
    
    @IBAction func register(_ sender: Any) {
        let phone = ev_phone.text
        let msg = ev_msg.text
        let password = ev_password.text
        if phone == nil || phone == "" || phone?.count ?? 0 != 11 {
            ShowTip(Title: "手机号码位数不对请重新输入")
            return
        }
        if !TextUntils.instance.isPhoneNumber(phoneNumber: phone ?? "") {
            ShowTip(Title: "手机号验证不通过")
            return
        }
        if msg == nil || msg == "" || msg?.count ?? 0 != 6{
            ShowTip(Title: "验证码位数不对")
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
        var body = RequestBody()
        body.phone = phone
        body.msg = msg
        body.password = password
        if type == 0  {
            registerUser(body: body)
        }else{
            changePassword(body:body)
        }
        
    }
    func registerUser(body:RequestBody){
        if body.msg == "666666" {
            let phone = UserDefaults.User.getvalue(forKey: .手机号) as? String
            if phone == body.phone {
                ShowTip(Title: "该号码已经注册请直接登录")
            }else{
                UserDefaults.User.set(value: body.phone ?? "", forKey: .手机号)
                UserDefaults.User.set(value: body.password ?? "", forKey: .密码)
                if callBack != nil{
                    callBack!(body.phone ?? "" , body.password ?? "")
                    self.ShowTipsClose(tite: "注册成功")
                }
            }
        }else{
            ShowTip(Title: "验证码错误")
        }
        //            let savephone = UserDefaults.User.getvalue(forKey: .手机号) as? String
        //            if savephone != nil {
        //
        //            }
        //
        //            if KeychainManager.User.SaveByIdentifier(data: body.phone, forKey: .手机号) && KeychainManager.User.SaveByIdentifier(data: body.password , forKey: .密码){
        //                log.info("keychain保存用户信息成功")
        //            }else{
        //                log.error("keychain保存用户信息失败")
        //            }
        //
        //        }else{
        //            ShowTip(Title: "验证码错误")
        //        }
        //
        //
        //        MyMoyaManager.AllRequest(controller: self, NetworkService.register(k: body.toJSONString()!)) { (data) in
        //            self.ShowTip(Title: "注册成功")
        //        }
        
    }
    func changePassword(body:RequestBody){
        
    }
    var isCounting = false {
        willSet {
            if newValue {
                remainingSeconds = 120
                lab_yanzhengma.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                lab_yanzhengma.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(Timer:)), userInfo: nil, repeats: true)
                
            }else{
                countdownTimer?.invalidate()
                countdownTimer = nil
                lab_yanzhengma.backgroundColor = #colorLiteral(red: 0.05725937337, green: 0.5547938943, blue: 0.9959492087, alpha: 1)
            }
            lab_yanzhengma.isEnabled = !newValue
        }
    }
    //显示倒计时
    var remainingSeconds : Int = 0 {
        willSet {
            
            lab_yanzhengma.setTitle("\(newValue)秒", for: .normal)
            if newValue <= 0 {
                lab_yanzhengma.setTitle("重新发送", for: .normal)
                isCounting = false
            }
        }
    }
    //更新时间
    @objc func updateTime(Timer:Timer) {
        remainingSeconds -= 1
    }
}
extension RegisterViewController:UITextFieldDelegate {
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
        case ev_msg:
            let maxLength = 6
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
