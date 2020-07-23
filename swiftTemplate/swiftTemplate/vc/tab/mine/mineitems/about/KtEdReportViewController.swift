//
//  KtEdReportViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 填写举报信息
import UIKit

class KtEdReportViewController: BaseViewController {
    var reportReason : String? = ""
    var postId : Int? = nil
    @IBOutlet weak var ev_description: UITextView!
    @IBOutlet weak var lavlereportresaon: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提交", style: .done, target: self, action: #selector(postReport))
       
    }
    override func initView() {
         lavlereportresaon.text = reportReason ?? "未知原因"
    }
    @objc func postReport(){
        let body = RequestBody()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.postId = postId ?? 0
        MyMoyaManager.AllRequest(controller: self, NetworkService.reportpostbypostd(k: body.toJSONString() ?? "")) { (data) in
            self.ShowTipsClose(tite: "提交举报成功")
        }
        
    }
    


}
