//
//  KtMySettingViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/8/4.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 设置
import UIKit
import SwiftyBeaver
class KtMySettingViewController: BaseViewController {
    var list = ["黑名单","清除缓存","退出"]
    @available(iOS 13.0, *)
    lazy var imagelist = [UIImage(systemName: "person.crop.circle.fill.badge.exclam"),UIImage(systemName: "xmark.icloud"),UIImage(systemName: "power")]
    lazy var imagelist1  = [#imageLiteral(resourceName: "关于"),#imageLiteral(resourceName: "清除缓存"),#imageLiteral(resourceName: "退出登录")]
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView() {
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: MineItemViewCell.reuseID, bundle: nil), forCellReuseIdentifier: MineItemViewCell.reuseID)
        
    }
    func deleteCoreNovel(){
        ShowScanTip(Title: "是否需要清理缓存")
        
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
//            CoreDataManager.default.deleteAllPost {
//                self.ShowTip(Title:"删除缓存成功")
//                UserDefaults.User.set(value: 0, forKey: .MAXPostId)
//            }
        }))
        self.present(TipsActionSheet, animated: true, completion: nil)
        
    }
    func logout(){
        if UserInfoHelper.instance.user == nil {
            
            self.navigationController?.pushViewController(getVcByName(vc: .登录), animated: true)
        }else{
            ShowLoginoutTip(Title: "是否需退出登录")
        }
        
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
            KeychainManager.User.DeleteByIdentifier(forKey: .IDCARD)
            UserInfoHelper.instance.user = nil
            self.ShowTipsClose(tite: "用户信息已清除")
        }))
        self.present(TipsActionSheet, animated: true, completion: nil)
        
    }
}
extension KtMySettingViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            self.navigationController?.pushViewController(getVcByName(vc: .黑名单), animated: true)
        case 1:
            deleteCoreNovel()
        case 2:
            logout()
        default:
            log.verbose("")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineItemViewCell.reuseID, for: indexPath) as! MineItemViewCell
        if #available(iOS 13.0, *) {
            cell.updetaCell(image: imagelist[indexPath.item], lname: list[indexPath.item], rname: nil)
        } else {
            cell.updetaCell(image: imagelist1[indexPath.item], lname: list[indexPath.item], rname: nil)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
}
