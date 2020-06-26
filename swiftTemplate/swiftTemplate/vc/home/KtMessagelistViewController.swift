//
//  KtMessagelistViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 消息列表
import UIKit

class KtMessagelistViewController: BaseDetailViewController {
    var postId :Int? = 0
    var list:[PostMessage]? = nil
    @IBOutlet weak var send_message: UIImageView!
    
    @IBOutlet weak var btn_message: UILabel!
    
    @IBOutlet weak var messagebackground: UIView!
    
    @IBOutlet weak var message_num: UILabel!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .formSheet
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: KtMessageCell.reuseID, bundle: nil), forCellReuseIdentifier: KtMessageCell.reuseID)
    }
    @IBAction func closevc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension KtMessagelistViewController:UITableViewDelegate,UITableViewDataSource{
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
    
    
}
