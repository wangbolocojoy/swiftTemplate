//
//  KtSexPickerViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/2.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
 // MARK: - 性别选择
import UIKit

class KtSexPickerViewController: BaseDetailViewController {
    
    let sexlist = ["男","女"]
    @IBOutlet weak var picker: UIPickerView!
    var sex = false
    func callBackBlock(block : @escaping swiftblock)  {
                   callBack = block
          }
          var callBack :swiftblock?
       typealias swiftblock = (_ user : UserInfo ) -> Void
    lazy var user = UserInfoHelper.instance.user
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        picker.delegate = self
        picker.dataSource = self
    }
    func updateUserInfo(){
        let body = RequestBody()
        body.id = user?.id ?? 0
        body.userSex = sex
        MyMoyaManager.AllRequest(controller: self, NetworkService.updateuserinfo(k: body.toJSONString() ?? "")) { (date) in
            if let us = date.userinfo {
                if self.callBack != nil {
                     UserInfoHelper.instance.user = us
                    self.callBack!(us)
                }
                 self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func choose(_ sender: Any) {
        updateUserInfo()
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
 
}
extension KtSexPickerViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexlist.count
    }
    override func didChangeValue(forKey key: String) {
        log.verbose(key)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexlist[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if sexlist[row] == "女"{
            sex = true
        }else{
            sex = false
        }
    }
    
}
