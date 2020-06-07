//
//  TabMineViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 我的
import UIKit

class TabMineViewController: BaseTabViewController {
    let time = 0.2
    var list = ["我的图片","我的地址","我的朋友","我的消息","我到家啊"]
    var imagelist = [#imageLiteral(resourceName: "IMG_2488-1"),#imageLiteral(resourceName: "IMG_2488-1"),#imageLiteral(resourceName: "IMG_2488-1"),#imageLiteral(resourceName: "IMG_2488-1"),#imageLiteral(resourceName: "IMG_2488-1")]
    var user : UserInfo? = nil
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.contentInsetAdjustmentBehavior = .never
        tableview.register(UINib(nibName: MineUserInfoViewCell.reuseID, bundle: nil), forCellReuseIdentifier: MineUserInfoViewCell.reuseID)
        tableview.register(UINib(nibName: MineItemViewCell.reuseID, bundle: nil), forCellReuseIdentifier: MineItemViewCell.reuseID)
        
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
           self.navigationController?.setNavigationBarHidden(true, animated: false)
         user = UserInfoHelper.instance.getUser()
        tableview.reloadData()
       }
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.navigationController?.setNavigationBarHidden(false, animated: false)
       }

    
//
    
    func logout(){
          KeychainManager.User.DeleteByIdentifier(forKey: .UserInfo)
                UIView.animate(withDuration: time, animations:{ }, completion: { (true) in
                    let tranststion =  CATransition()
                    tranststion.duration = self.time
                    tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                    UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
                    UIApplication.shared.keyWindow?.rootViewController = self.getloginVc()
                })
    }
    
    
}
extension TabMineViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            log.info("哈哈哈")
        default:
            switch indexPath.item {
            case 0,1,2,3:
                self.ShowTip(Title: list[indexPath.item])
            default:
                logout()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return list.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        default:
            return 45
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MineUserInfoViewCell.reuseID, for: indexPath) as! MineUserInfoViewCell
            cell.updateCell(user: user )
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MineItemViewCell.reuseID, for: indexPath) as! MineItemViewCell
            cell.updetaCell(image: imagelist[indexPath.item], lname: list[indexPath.item], rname: nil)
                       return cell
            
        }
    }
    
    
}
