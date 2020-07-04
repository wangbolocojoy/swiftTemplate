//
//  KtDatePickerViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/29.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtDatePickerViewController: BaseDetailViewController {
    var birthday:Date = Date()
    var choosedirthday:Date? = nil
    var choosexinzuo:String? = nil
    lazy var user = UserInfoHelper.instance.user
    @IBOutlet weak var constellation: UILabel!
    @IBOutlet weak var timepicker: UIDatePicker!
    func callBackBlock(block : @escaping swiftblock)  {
                callBack = block
       }
       var callBack :swiftblock?
    typealias swiftblock = (_ user : UserInfo ) -> Void
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        constellation.text = Date().calculateWithDate
        timepicker.addTarget(self, action: #selector(changevalue), for: .valueChanged)
    }
    
    @objc func changevalue(datePicker : UIDatePicker){
        //更新提醒时间文本框
              
               //日期样式
        choosedirthday = datePicker.date
       
                constellation.text = datePicker.date.calculateWithDate
              choosexinzuo = constellation.text
    }
    @IBAction func cancle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let formatter = DateFormatter()
                     formatter.dateFormat = "yyyy年MM月dd日"
        let body = RequestBody()
        body.constellation = choosexinzuo
        body.birthDay = formatter.string(from: choosedirthday ?? Date()) 
        body.id = user?.id ?? 0
        updateInfo(body: body.toJSONString() ?? "")
        
    }
    
    func updateInfo(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.updateuserinfo(k: body)) { (data) in
            if let u = data.userinfo {
                if self.callBack != nil {
                    UserInfoHelper.instance.user = u
                    self.callBack!(u)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
