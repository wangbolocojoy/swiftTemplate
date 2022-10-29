//
//  KtAccountBlockViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 账号封禁
import UIKit
import MJRefresh
class KtAccountBlockViewController: BaseViewController {
    
    lazy var list : [UserInfo]? = []
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = true
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "全选", style: .done, target: self, action: #selector(Allselectin))
    }
    @objc func Allselectin(){
        let list1 = list
               for  (curIndex, eachItem) in list1!.enumerated(){
                   eachItem.isselectid =  !(eachItem.isselectid ?? false)
                   list![curIndex] = eachItem
               }
               self.tableview.reloadData()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtAccountBlockCell.reuseID, bundle: nil), forCellReuseIdentifier: KtAccountBlockCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        getUserList()
    }
    func getUserList(){
        type = 1
        pagebody.page = 0
        pagebody.pageSize = 10
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getUsers(body: pagebody)
    }
    func getUsers(body:RequestBody){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getallusers(k: body.toJSONString()!)) { (data) in
            if self.type == 1 {
                self.list = data.userlist
            }else{
                self.list! += data.userlist ?? []
            }
            if data.postlist?.count ?? 0 == 10{
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
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.pageSize = 10
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getUsers(body: pagebody)
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
            pagebody.page = (pagebody.page ?? 0) + 1
            pagebody.pageSize = 10
            getUsers(body: pagebody)
        }
        
    }
    
}
extension KtAccountBlockViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtAccountBlockCell.reuseID, for: indexPath) as! KtAccountBlockCell
        cell.setModel(model: list?[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
               let lastPath = path[(path.count)-1]
               if  lastPath.item == (list?.count ?? 0) - 1{
                   self.getMore()
               }
           }
       }
    
    
}
