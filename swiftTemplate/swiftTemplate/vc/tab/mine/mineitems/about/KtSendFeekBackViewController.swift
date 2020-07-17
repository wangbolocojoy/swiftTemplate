//
//  KtSendFeekBackViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/11.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyBeaver
import CryptoSwift
class KtSendFeekBackViewController: BaseViewController {
    
    
    
    @IBOutlet weak var ev_feekback: UITextView!
    lazy var  controller: MFMailComposeViewController? = nil
    @IBOutlet weak var allview: UIView!
    lazy var user = UserInfoHelper.instance.user
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
    }
    
    @IBAction func sendfeekback(_ sender: Any) {
        let text = ev_feekback.text
        if text?.count ?? 0 <= 10 {
            ShowTip(Title: "意见或建议大于10个字")
            return
        }
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.feedMsg = text
        sendProposal(json: body.toJSONString() ?? "")
    }
    
    func sendProposal(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.sendfeekback(k: json)) { (data) in
            self.ShowTipsClose(tite: data.msg ?? "建议提交成功")
        }
    }
    override func initView() {
        title = "意见反馈"
        ev_feekback.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(getjiaodian))
        allview.isUserInteractionEnabled = true
        allview.addGestureRecognizer(tap)
        if ApiKey.default.版本环境 == "正式版本" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送日志", style: .done, target: self, action: #selector(sendLogFile))
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送日志", style: .done, target: self, action: #selector(sendLogFile))
        }
    }
    @objc func getjiaodian(){
        ev_feekback.becomeFirstResponder()
        
    }
    @objc func sendLogFile(){
        if MFMailComposeViewController.canSendMail(){
            controller = MFMailComposeViewController()
            //设置代理
            controller?.mailComposeDelegate = self
            //设置主题
            controller?.setSubject("SwiftKt日志")
            //设置收件人
            controller!.setToRecipients(["634183261@qq.com"])
//            controller?.setCcRecipients(["634183261@qq.com"])
            let homeDirectory = NSHomeDirectory()
            let filepath = homeDirectory+"/Library/Caches/swiftybeaver.log"
            let dbpath = homeDirectory+"/Library/Caches/com.90btm.myapplication.swiftTemplate/Cache.db"
            var file : Data? = nil
            var dbfile :Data? = nil
            do {
                file = try Data(contentsOf: URL(fileURLWithPath: filepath),options: .alwaysMapped)
                 dbfile = try Data(contentsOf: URL(fileURLWithPath: dbpath),options: .alwaysMapped)
            } catch  {
                log.error("获取日志失败\(error)")
            }
            if file == nil || dbfile == nil {
                self.ShowTip(Title: "暂未产生错误日志")
                return
            }else{
                controller!.addAttachmentData(file!, mimeType: "log",
                                              fileName: "swiftybeaver.log")
                controller!.addAttachmentData(dbfile ?? Data(hex: "没有日志"), mimeType: "db",
                fileName: "Cache.db")
                //设置邮件正文内容（支持html）
                
                controller!.setMessageBody("错误日志" , isHTML: false)
                //打开界面
                //                self.show(controller!, animated: true, completion: nil)
                self.show(controller!, sender: nil)
            }
        }else{
            ShowTip(Title: "本设备不能发送邮件")
        }
    }
   
}
extension KtSendFeekBackViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         controller.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            self.ShowTip(Title: "发送日志成功")
        case .saved:
            self.ShowTip(Title: "保存日志成功")
        case .cancelled:
            self.ShowTip(Title: "取消发送日志")
        default:
            self.ShowTip(Title: "发送日志失败")
        }
       
    }
}



extension KtSendFeekBackViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView {
        case ev_feekback:
            let maxLength = 300
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
            
        default:
            let maxLength = 3
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            return newString.length <= maxLength
        }
        
    }
}
