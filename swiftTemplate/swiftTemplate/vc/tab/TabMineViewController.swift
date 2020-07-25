//
//  TabMineViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 我的
import UIKit
import MJRefresh
import SwiftyBeaver
class TabMineViewController: BaseTabViewController {
    let time = 0.2
    var list = ["我的图片","我的地址","我的收藏","我的评论","关于","清除缓存","退出登录"]
    
    @available(iOS 13.0, *)
    lazy var imagelist = [UIImage(systemName: "photo.on.rectangle"),UIImage(systemName: "mappin.circle"),UIImage(systemName: "person.2"),UIImage(systemName: "ellipses.bubble"),UIImage(systemName: "info.circle"),UIImage(systemName: "xmark.icloud"),UIImage(systemName: "power")]
    lazy var imagelist1  = [#imageLiteral(resourceName: "图片"),#imageLiteral(resourceName: "地址"),#imageLiteral(resourceName: "bookmark"),#imageLiteral(resourceName: "评论"),#imageLiteral(resourceName: "关于"),#imageLiteral(resourceName: "清除缓存"),#imageLiteral(resourceName: "退出登录")]
    
    var user  = UserInfoHelper.instance.user
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        user = UserInfoHelper.instance.user
        tableview.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableview.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableview.register(UINib(nibName: MineUserInfoViewCell.reuseID, bundle: nil), forCellReuseIdentifier: MineUserInfoViewCell.reuseID)
        tableview.register(UINib(nibName: MineItemViewCell.reuseID, bundle: nil), forCellReuseIdentifier: MineItemViewCell.reuseID)
        tableview.register(UINib(nibName: BTMCleanHeader.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: BTMCleanHeader.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
    
    }
    @objc func refresh(){
        let body = RequestBody()
        body.id = user?.id ?? 0
        MyMoyaManager.AllRequest(controller: self, NetworkService.getuserinfo(k: body.toJSONString() ?? "")) { (data) in
            
            UserInfoHelper.instance.user = data.userinfo
            
            self.tableview.reloadData()
        }
        header.endRefreshing()
    }
    func logout(){
       ShowLoginoutTip(Title: "是否需要退出登录")
    }
    func deleteCoreNovel(){
        ShowScanTip(Title: "是否需要清理缓存")
        
    }
    
    /// 清除缓存
       /// - Parameter Title: 提示信息
       func ShowLoginoutTip(Title:String)  {
           let TipsActionSheet : UIAlertController = UIAlertController(title: "温馨提示", message: Title, preferredStyle: UIAlertController.Style.alert)
           TipsActionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in
               TipsActionSheet.dismiss(animated: true, completion: nil)
               
           }))
           TipsActionSheet.addAction(UIAlertAction(title: "确认", style: .destructive, handler: { (UIAlertAction) in
              KeychainManager.User.DeleteByIdentifier(forKey: .UserInfo)
                     UserInfoHelper.instance._setuser = nil
            UIView.animate(withDuration: self.time, animations:{ }, completion: { (true) in
                         let tranststion =  CATransition()
                         tranststion.duration = self.time
                         tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                         UIApplication.shared.windows[0].layer.add(tranststion, forKey: "animation")
                         UIApplication.shared.windows[0].rootViewController = self.getloginVc()
                     })
           }))
           self.present(TipsActionSheet, animated: true, completion: nil)
           
       }
    /// 清除缓存
    /// - Parameter Title: 提示信息
    func ShowScanTip(Title:String)  {
        let TipsActionSheet : UIAlertController = UIAlertController(title: "温馨提示", message: Title, preferredStyle: UIAlertController.Style.alert)
        TipsActionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in
            TipsActionSheet.dismiss(animated: true, completion: nil)
            
        }))
        TipsActionSheet.addAction(UIAlertAction(title: "确认", style: .destructive, handler: { (UIAlertAction) in
            if FileDestination().deleteLogFile(){
                self.ShowTip(Title: "删除日志成功")
            }
            CoreDataManager.default.deleteAllPost {
                self.ShowTip(Title:"删除缓存成功")
                  UserDefaults.User.set(value: 0, forKey: .MAXPostId)
            }
        }))
        self.present(TipsActionSheet, animated: true, completion: nil)
        
    }
    
}
extension TabMineViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            log.verbose("哈哈哈")
        default:
            switch indexPath.item {
            case 0:
                self.navigationController?.pushViewController(getVcByName(vc: .我的图片), animated: true)
            case 1:
                self.navigationController?.pushViewController(getVcByName(vc: .我的地图), animated: true)
            case 2:
                self.navigationController?.pushViewController(getVcByName(vc: .我的收藏), animated: true)
            case 3:
                self.navigationController?.pushViewController(getVcByName(vc: .我的评论), animated: true)
            case 4:
                let vc = getVcByName(vc: .关于) as! KtAboutMineViewController
                vc.user = user
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                deleteCoreNovel()
            case 6:
                logout()
            default:
                debugPrint()
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BTMCleanHeader.reuseID) as! BTMCleanHeader
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 10
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
            cell.updateCell(user: UserInfoHelper.instance.user )
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: MineItemViewCell.reuseID, for: indexPath) as! MineItemViewCell
            if #available(iOS 13.0, *) {
                cell.updetaCell(image: imagelist[indexPath.item], lname: list[indexPath.item], rname: nil)
            } else {
                cell.updetaCell(image: imagelist1[indexPath.item], lname: list[indexPath.item], rname: nil)
            }
            return cell
        }
    }
    
    
}
