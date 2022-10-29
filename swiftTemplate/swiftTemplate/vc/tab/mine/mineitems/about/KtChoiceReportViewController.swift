//
//  KtChoiceReportViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 选择举报原因
import UIKit

class KtChoiceReportViewController: BaseViewController {
    var postId : Int? = nil
    lazy var list :[String]  = ["色情低俗","政治敏感","违法犯罪","造谣传谣","涉嫌欺诈","侮辱谩骂","侵犯权益","未成年不当行为","引人不适","疑似自我伤害","其他"]
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: MineItemViewCell.reuseID, bundle: nil), forCellReuseIdentifier: MineItemViewCell.reuseID)
        tableview.separatorStyle = .none
    }
    
    
}
extension KtChoiceReportViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineItemViewCell.reuseID, for: indexPath) as! MineItemViewCell
        cell.updetaCell(image: nil, lname: list[indexPath.item], rname: "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.getVcByName(vc: .填写举报信息) as!  KtEdReportViewController
        vc.reportReason = list[indexPath.item]
        vc.postId = self.postId
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
}
