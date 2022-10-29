//
//  LoginViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 登录
import UIKit
import AuthenticationServices
class LoginViewController: BaseViewController {
    let time = 0.2
    @IBOutlet weak var ev_password: UITextField!
    @IBOutlet weak var ev_phone: UITextField!
    
    @IBOutlet weak var btn_agreement: UILabel!
    var vc : UIViewController? = nil
//    var authorizationButton :ASAuthorizationAppleIDButton? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
        initView()
       
    }
    
    // Add “Sign In with Apple” button to your login view
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
//            switch previousTraitCollection?.userInterfaceStyle {
//            case .dark:
//                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
//            case .light:
//                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
//            case .none:
//                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
//            default:
//                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
//            }
//        }
    }
    func setupProviderLoginView() {
//
//        if self.view.backgroundColor == Constant.BackGround  {
//            authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
//        }else{
//            authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
//        }
//
//
//        authorizationButton?.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//
//        loginProviderStackView.addArrangedSubview(authorizationButton ?? UIView())
    }
    
    
    
    // Configure request, setup delegates and perform authorization request
    @objc func handleAuthorizationAppleIDButtonPress() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
    }
    
    @IBAction func closevc(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func initView(){
        title = "登录"
        ev_phone.delegate = self
        ev_password.delegate = self
        ev_password.isSecureTextEntry = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoAgreement))
        btn_agreement.isUserInteractionEnabled = true
        btn_agreement.addGestureRecognizer(tap)
    }
    @objc func gotoAgreement(){
        let vc = getVcByName(vc: .我的隐私协议) as! KtMyWkWebViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
        body.password = password?.md5()
        MyMoyaManager.AllRequest(controller: self, NetworkService.login(k: body.toJSONString()!)) { (data) in
            if KeychainManager.User.SaveByIdentifier(data: data.userinfo?.toJSONString() ?? "", forKey: .UserInfo) {
                 UserInfoHelper.instance.user = data.userinfo
                log.debug( String(describing: UserInfoHelper.instance.user?.id ?? 1))
                log.debug(UserInfoHelper.instance.user?.toJSONString())
                V2TIMManager.sharedInstance().login(String(describing: UserInfoHelper.instance.user?.id ?? 1), userSig: UserInfoHelper.instance.user?.imUserSig) {
                    log.info("登陆成功")
                    //V2TIM_STATUS_LOGINED 已登录
                    //V2TIM_STATUS_LOGINING 登录中
                    //V2TIM_STATUS_LOGOUT 无登录
                    var loginstatus = V2TIMManager.sharedInstance().getLoginStatus()
                    log.info("登陆成功\(loginstatus)")
//                    log.debug()
                } fail: { a, b in
                    log.error("错误代码\(a)------错误信息\(b!)")
                }

                if data.userinfo?.isbanned ?? false  == true  || data.userinfo == nil{
                                   self.ShowTip(Title: data.msg ?? "该账号已被封禁")
                               }else{
                    self.dismiss(animated: true) {
                        self.parent?.viewDidAppear(true)
                    }
                               }
            }
           
        }
        
    }
    func gotoMainVC(){
        
//        UIView.animate(withDuration: time, animations:{
//            let tranststion =  CATransition()
//            tranststion.duration = self.time
//            tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
//            UIApplication.shared.windows[0].layer.add(tranststion, forKey: "animation")
//        }, completion: { (true) in
//            UIApplication.shared.windows[0].rootViewController = self.getMainVc()
//        })
        
       
       
    }
    
    @IBAction func frogetpass(_ sender: Any) {
        let vc =  getVcByName(vc: .注册) as! RegisterViewController
        vc.type = 1
        vc.callBackBlock { (phone, passwd) in
                   self.ev_phone.text = phone
                   self.ev_password.text = passwd
               }
       vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true) {
            
        }
    }
    @IBAction func gotoRegister(_ sender: Any) {
        let vc =  getVcByName(vc: .注册) as! RegisterViewController
        vc.type = 0
        vc.callBackBlock { (phone, passwd) in
            self.ev_phone.text = phone
            self.ev_password.text = passwd
        }
        vc.modalPresentationStyle = .fullScreen
         
        self.present(vc, animated: true) {
            
        }
    }
}
extension LoginViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case ev_phone:
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        case ev_password:
            let maxLength = 25
            let currentString: NSString = textField.text! as NSString
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
//extension LoginViewController:ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//    /// MARK: ASAuthorizationControllerDelegate
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            let realUserStatus = appleIDCredential.realUserStatus
//
//            let identityToken = appleIDCredential.identityToken?.base64EncodedString()
//            let authCode = appleIDCredential.authorizationCode?.base64EncodedString()
//            log.verbose("userIdentifier  \(userIdentifier)")
//            log.verbose("fullName  \(String(describing: fullName?.familyName) )\(String(describing: fullName?.givenName))")
//             log.verbose("email  \(email ?? "")")
//            log.verbose("realUserStatus  \(realUserStatus.rawValue )")
//             log.verbose("identityToken  \(identityToken ?? "")")
//             log.verbose("authCode  \(authCode ?? "")")
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            _ = KeychainManager.User.SaveByIdentifier(data: userIdentifier, forKey: .currentUserIdentifier)
//
//        // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            _ = passwordCredential.user
//            _ = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                //                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//
//        default:
//            break
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle error.
//    }
//
//
//
//}
