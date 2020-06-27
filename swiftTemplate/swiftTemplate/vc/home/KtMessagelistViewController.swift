//
//  KtMessagelistViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 消息列表
import IQKeyboardManagerSwift
import UIKit
import MJRefresh
import InputBarAccessoryView
class KtMessagelistViewController: BaseDetailViewController {
    var postId :Int? = 0
    var list:[PostMessage]? = nil
    let inputBar = iMessageInputBar()
    @IBOutlet weak var messagebackground: UIView!
    @IBOutlet weak var message_num: UILabel!
    @IBOutlet weak var tableview: UITableView!
     private var keyboardManager = KeyboardManager()
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var type = 0
    var hasmore :Bool = false
    lazy var body = RequestBody()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .formSheet
    }
    override func initView() {
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .default
        inputBar.inputTextView.textContentType = .none
        inputBar.inputTextView.placeholder = "说点好听的吧"
        view.addSubview(inputBar)
              // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
              // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: KtMessageCell.reuseID, bundle: nil), forCellReuseIdentifier: KtMessageCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        type = 1
        body.page = 0
        body.pageSize = 20
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.postId = postId
        commentlist(body: body.toJSONString() ?? "")
    }
   
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
    }

    override func viewWillDisappear(_ animated: Bool) {
         IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
         

    }
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        body.page = 0
        commentlist(body: body.toJSONString() ?? "")
    }
    
    @objc func getMore(){
        if hasmore {
            type = 2
            body.userId = UserInfoHelper.instance.user?.id ?? 0
            body.page = (body.page ?? 0) + 1
            commentlist(body: body.toJSONString() ?? "")
        }else{
            
        }
        
    }
    func commentlist(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.commentlist(k: body)) { (data) in
            if self.type == 1 {
                log.info(data.userlist?.toJSONString() ?? "")
                self.list = data.postmsg
            }else{
                self.list! += data.postmsg ?? []
            }
            if data.postlist?.count ?? 0 == 20{
                self.hasmore = true
            }else{
                self.hasmore = false
                self.footer.endRefreshingWithNoMoreData()
            }
            self.tableview.reloadData()
        }
        self.header.endRefreshing()
        self.footer.endRefreshing()
    }
    
    @IBAction func closevc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension KtMessagelistViewController:InputBarAccessoryViewDelegate{
    
      func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
          
          // Here we can parse for which substrings were autocompleted
          let attributedText = inputBar.inputTextView.attributedText!
          let range = NSRange(location: 0, length: attributedText.length)
          attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
              
              let substring = attributedText.attributedSubstring(from: range)
              let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
              print("Autocompleted: `", substring, "` with context: ", context ?? [])
          }

          inputBar.inputTextView.text = String()
          inputBar.invalidatePlugins()

          // Send button activity animation
          inputBar.sendButton.startAnimating()
          inputBar.inputTextView.placeholder = "发送中"
         
      }
      
      func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
          // Adjust content insets
          print(size)
          // keyboard size estimate
      }
      
      func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
          
         
      }
      
    
}
extension KtMessagelistViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtMessageCell.reuseID, for: indexPath) as! KtMessageCell
        cell.setModel(info: list?[indexPath.item])
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate){
            self.scrollLoadData()
        }else{
            
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollLoadData()
    }
    
    func scrollLoadData() {
        if !hasmore {
            return
        }
        let path = tableview.indexPathsForVisibleRows!  as [IndexPath]
        if ( path.count  > 0) {
            let lastPath = path[(path.count)-3]
            if  lastPath.item == (self.list?.count ?? 0) - 3{
                self.getMore()
            }
        }
    }
    
}
extension KtMessagelistViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.info(event)
        log.info(touches)
          
    }
}
