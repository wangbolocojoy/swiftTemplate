//
//  KtAboutMineViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/9.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import SafariServices
class KtAboutMineViewController: BaseViewController {
    lazy var list = ["去评分","版本更新","意见反馈","关于我们"]
    lazy var list1 = ["去评分","版本更新","意见反馈","关于我们","反馈列表","帖子审核","账号封禁"]
    @IBOutlet weak var tableview: UITableView!
    lazy var user : UserInfo? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtAboutHeaderCell.reuseID, bundle: nil), forCellReuseIdentifier: KtAboutHeaderCell.reuseID)
        tableview.register(UINib(nibName: KtAboutItemCell.reuseID, bundle: nil), forCellReuseIdentifier: KtAboutItemCell.reuseID)
    }
    func showSafariVC(for url: String){
        guard let url = URL(string: url) else {
            return
        }
        UIApplication.shared.open(url, options: [:]) { (Bool) in
            log.verbose("好了哇")
        }
    }
    
    
}
extension KtAboutMineViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if user?.phone ?? "0" == "13550247642" || user?.administrators ?? false{
                return list1.count
            }else{
                return list.count
            }
            
            
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 240
        default:
            return 55
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.item {
            case 0:
                showSafariVC(for: "itms-apps://itunes.apple.com/app/id15240822319")
            case 1:
                showSafariVC(for: "itms-apps://itunes.apple.com/app/id15240822319?action=write-review")
            case 2:
                let vc = getVcByName(vc: .意见反馈) as! KtSendFeekBackViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = getVcByName(vc: .关于我们) as! KtAboutDeveloperViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = getVcByName(vc: .意见反馈列表) as! KtFeekBackListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = getVcByName(vc: .帖子审核管理) as! KtExaminePostViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                let vc = getVcByName(vc: .账号封禁管理) as! KtAccountBlockViewController
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                let vc = getVcByName(vc: .意见反馈列表) as! KtFeekBackListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            log.verbose("")
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: KtAboutHeaderCell.reuseID, for: indexPath) as! KtAboutHeaderCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: KtAboutItemCell.reuseID, for: indexPath) as! KtAboutItemCell
            if #available(iOS 13.0, *) {
                if user?.phone ?? "0" == "13550247642"{
                    cell.setItemName(name: list1[indexPath.item])
                }else{
                    cell.setItemName(name: list[indexPath.item])
                }
            } else {
                cell.setItemName(name: list[indexPath.item])
            }
            
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: KtAboutItemCell.reuseID, for: indexPath) as! KtAboutItemCell
            return cell
        }
    }
    
    
}
