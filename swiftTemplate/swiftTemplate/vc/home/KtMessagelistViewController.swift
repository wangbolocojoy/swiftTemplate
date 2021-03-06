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
    var postinfo :PostInfo? = nil
    var list:[PostMessage]? = nil
    let inputBar = iMessageInputBar()
    @IBOutlet weak var messagebackground: UIView!
    @IBOutlet weak var message_num: UILabel!
    @IBOutlet weak var tableview: UITableView!
    private var keyboardManager = KeyboardManager()
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var type = 0
    var postmsg : PostMessage? = nil
    var hasmore :Bool = false
    
    func callBackBlock(block : @escaping swiftblock)  {
        callBack = block
    }
    var callBack :swiftblock?
    typealias swiftblock = (_ btntag : PostInfo? ) -> Void
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .formSheet
    }
    var replyNickName : String? = nil
    var replyUserId : Int? = nil
    var edsection : Int? = nil
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
        tableview.register(UINib(nibName: KtMessageHeader.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: KtMessageHeader.reuseID)
        tableview.separatorStyle = .none
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        self.message_num.text = "\(postinfo?.postMessageNum ?? 0)条评论"
        getmessage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hide(node:)), name:  UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    func getmessage(){
        let body = RequestBody()
        type = 1
        body.page = 0
        body.pageSize = 20
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.postId = postinfo?.id ?? 0
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
    override func viewDidDisappear(_ animated: Bool) {
        if callBack != nil {
            callBack!(self.postinfo)
        }
    }
    @objc func refresh(){
        footer.resetNoMoreData()
        let body = RequestBody()
        type = 1
        body.page = 0
        body.pageSize = 20
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.postId = postinfo?.id ?? 0
        commentlist(body: body.toJSONString() ?? "")
    }
    
    @objc func getMore(){
        if hasmore {
            let body = RequestBody()
            type = 2
            body.page = (body.page ?? 0) + 1
            body.pageSize = 20
            body.postId = postinfo?.id ?? 0
            body.userId = UserInfoHelper.instance.user?.id ?? 0
            commentlist(body: body.toJSONString() ?? "")
        }else{
            
        }
        
    }
    func commentlist(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.commentlist(k: body)) { (data) in
            if self.type == 1 {
                log.verbose(data.userlist?.toJSONString() ?? "")
                self.list = data.postmsgs
            }else{
                self.list! += data.postmsgs ?? []
            }
            if data.postmsgs?.count ?? 0 == 20{
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
    deinit {
        log.verbose("释放")
        // 删除键盘监听
        log.verbose("删除键盘监听")
        NotificationCenter.default.removeObserver(self)
    }
    func sendComment(value:String?){
        let body = RequestBody()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        if postmsg != nil {
            body.postMsgId = postmsg?.id ?? nil
            body.replyUserId = replyUserId ?? nil
            body.replyNickName = replyNickName ?? nil
        }
        body.postId = postinfo?.id ?? 0
        body.postMessage = value
        MyMoyaManager.AllRequest(controller: self, NetworkService.sendcomment(k: body.toJSONString() ?? "")) { (data) in
            self.postinfo?.postMessageNum = (self.postinfo?.postMessageNum ?? 0)+1
            self.inputBar.inputTextView.endEditing(true)
            self.message_num.text = "\(self.postinfo?.postMessageNum ?? 0)条评论"
            if let pos = data.postmsg {
                pos.userIcon = UserInfoHelper.instance.user?.icon
                pos.userNickName =  UserInfoHelper.instance.user?.nickName
                if self.postmsg != nil {
                    self.list?[self.edsection ?? 0].chiledMessage?.insert(pos, at: 0)
                }else{
                    log.verbose(pos.toJSONString() ?? "")
                    self.list?.insert(pos, at: 0)
                }
                self.tableview.reloadData()
            }
            
        }
    }
    @objc private func hide(node : Notification){
        self.inputBar.inputTextView.text = String()
        self.inputBar.sendButton.stopAnimating()
        self.inputBar.inputTextView.placeholder = "说点好听的吧"
        self.edsection = nil
        self.postmsg = nil
        self.replyUserId = nil
        self.replyNickName = nil
        print("软键盘隐藏")
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
        
        //          inputBar.inputTextView.text = String()
        inputBar.sendButton.startAnimating()
        inputBar.invalidatePlugins()
        
        // Send button activity animation
        
        inputBar.inputTextView.placeholder = "发送中"
        log.verbose("\(inputBar.inputTextView.text ?? "")")
        sendComment(value: inputBar.inputTextView.text)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        print(size)
        // keyboard size estimate
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        
    }
    
    func editCommit(msg:PostMessage?){
        postmsg = msg
        inputBar.inputTextView.becomeFirstResponder()
        inputBar.inputTextView.placeholder = "回复@\(msg?.userNickName ?? "")"
    }
    
    func celleditCommit(msg:PostMessage?,placeholder:String?){
        postmsg = msg
        inputBar.inputTextView.becomeFirstResponder()
        inputBar.inputTextView.placeholder = "回复@\(placeholder ?? "")"
    }
    
}
extension KtMessagelistViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?[section].chiledMessage?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: KtMessageHeader.reuseID) as! KtMessageHeader
        header.setModel(info: list?[section],pinf: postinfo)
        header.callBackBlock { (postmsg) in
            self.edsection = section
            self.editCommit(msg: postmsg)
        }
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtMessageCell.reuseID, for: indexPath) as! KtMessageCell
        cell.setModel(info: list?[indexPath.section].chiledMessage?[indexPath.item],pinf: postinfo)
        cell.callBackBlock { (pmsg) in
            self.edsection = indexPath.section
            self.replyUserId = pmsg?.userId
            self.replyNickName = pmsg?.userNickName
            self.celleditCommit(msg: self.list?[indexPath.section],placeholder: pmsg?.userNickName)
        }
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate){
            self.scrollLoadData()
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
        log.verbose(event ?? "阿斯顿")
        log.verbose(touches)
        
    }
}
