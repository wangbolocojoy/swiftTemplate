//
//  FancesInfoViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 粉丝详情
import UIKit

class FancesInfoViewController: BaseViewController {
    var list :[String]? = []
    var userinfo :UserInfo? = nil 
 
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = userinfo?.nickName ?? "粉丝信息"
        
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: FanceInfoHeaderCell.reuseID, bundle: nil), forCellReuseIdentifier: FanceInfoHeaderCell.reuseID)

    }
    

}
extension FancesInfoViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FanceInfoHeaderCell.reuseID, for: indexPath) as! FanceInfoHeaderCell
        return cell
    }
    
    
}
