//
//  KtEdAuthenticationViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/24.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 编辑身份信息
import UIKit

class KtEdAuthenticationViewController: BaseViewController {
    let param = ["app_id":"","time_stamp":"","nonce_str":"fa577ce340859f9fe","sign":"","image":"","card_type":"0"]
    
    @IBOutlet weak var tv_cardname: UITextField!
    @IBOutlet weak var tv_cardid: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tv_cardid.delegate = self
        tv_cardname.delegate = self
        
    }
    
    @IBAction func saveusercard(_ sender: Any) {
        
    }
    
    func checkAuthentica(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.respsd(k: json)) { (data) in
            
        }
    }
}
extension KtEdAuthenticationViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           switch textField {
           case tv_cardid:
               let maxLength = 18
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
           case tv_cardname:
               let maxLength = 8
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
