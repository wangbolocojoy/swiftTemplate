//
//  RegisterViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
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
    var time :Int? = nil
     var password  = ""
    typealias swiftblockResult = (_ phone : String ,_ passwd:String) -> Void
    var callBack :swiftblockResult?
    func callBackBlock(block : @escaping swiftblockResult)  {
        callBack = block
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func initView(){
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
        
        time  = UserDefaults.User.getvalue(forKey: .验证码时间) as? Int
        if time == nil {
            time = 120
        }else{
        let nowtime = Int(Date().timeIntervalSince1970)
            time = 120 - (nowtime - (time ?? 0))
            if (time ?? 0) > 0 && (time ?? 0) < 120{
                self.isCounting = true
            }else{
                time = 120
            }
            
        }
       
    }
    
    @IBAction func sendMsg(_ sender: Any) {
        sendMsg()
    }
    
    
    func sendMsg(){
        let phone = ev_phone.text
        if phone == nil || phone == "" || phone?.count ?? 0 != 11 {
                   ShowTip(Title: "手机号码位数不对请重新输入")
                   return
               }
        let body = RequestBody()
        if type == 0{
            body.msgType = 1
        }else{
            body.msgType = 2
        }
        body.phone = phone
        MyMoyaManager.AllRequest(controller: self, NetworkService.getmsg(k: body.toJSONString() ?? "")) { (data) in
            self.isCounting = true
             let nowtime = Int(Date().timeIntervalSince1970)
            UserDefaults.User.set(value: nowtime, forKey: .验证码时间)
        }
    }
    
    @IBAction func register(_ sender: Any) {
        let phone = ev_phone.text
        let msg = ev_msg.text
        password = ev_password.text ?? ""
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
        
        if password == "" || password.count < 6{
            ShowTip(Title: "密码位数能小于6位")
            return
        }
        if !TextUntils.instance.isPasswordRuler(password: password ) {
            ShowTip(Title: "请输入大于6位字母和数字组合的密码")
            return
        }
        let body = RequestBody()
        body.phone = phone
        body.msgcode = msg
        body.password = password.md5()
        if type == 0  {
            registerUser(body: body)
        }else{
            changePassword(body:body)
        }
        
    }
    func registerUser(body:RequestBody){
            MyMoyaManager.AllRequest(controller: self, NetworkService.register(k: body.toJSONString()!)) { (data) in
                if self.callBack != nil {
                    self.callBack!(body.phone ?? "",self.password )
                    self.ShowTipsClose(tite: "注册成功")
                   
                }
            }
    }
    func changePassword(body:RequestBody){
        MyMoyaManager.AllRequest(controller: self, NetworkService.respsd(k: body.toJSONString()!)) { (data) in
                              if self.callBack != nil {
                                  self.callBack!(body.phone ?? "",self.password )
                                  self.ShowTipsClose(tite: "修改密码成功")
                              
                              }
                          }
    }
    var isCounting = false {
        willSet {
            if newValue {
                remainingSeconds = time ?? 0
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
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case ev_password:
            let maxLength = 25
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case ev_msg:
            let maxLength = 6
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        default:
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
    }
}
