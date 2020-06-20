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
         tableview.register(UINib(nibName: FanceInfoViewCell.reuseID, bundle: nil), forCellReuseIdentifier: FanceInfoViewCell.reuseID)
    }
    

}
extension FancesInfoViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return list?.count ?? 0
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: FanceInfoViewCell.reuseID, for: indexPath) as! FanceInfoViewCell
            cell.updateCell(user: userinfo)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: FanceInfoViewCell.reuseID, for: indexPath) as! FanceInfoViewCell
            return cell
        }
    }
    
    
}
