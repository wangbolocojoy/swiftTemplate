//
//  KtBackListViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/8/4.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 黑名单
import UIKit

class KtBackListViewController: BaseViewController {
    @IBOutlet weak var tableview: UITableView!
    var list : [UserInfo]? = []
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtBackListCell.reuseID, bundle: nil), forCellReuseIdentifier: KtBackListCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        initdata()
    }
    func initdata(){
           type = 1
           pagebody.page = 0
           pagebody.pageSize = 10
           pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
           getbacklist(body: pagebody)
    }
    func getbacklist(body:RequestBody){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getbacklist(k: body.toJSONString()!)) { (data) in
            if self.type == 1 {
                self.list = data.fancefollowlist
            }else{
                self.list! += data.fancefollowlist ?? []
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
        getbacklist(body: pagebody)
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
            pagebody.page = (pagebody.page ?? 0) + 1
            pagebody.pageSize = 10
            getbacklist(body: pagebody)
        }
        
    }
    func  removeBaclList(json:String,index:Int){
        MyMoyaManager.AllRequest(controller: self, NetworkService.removebacklist(k: json)) { (data) in
            self.list?.remove(at: index)
            self.tableview.reloadData()
        }
    }
    
}
extension KtBackListViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtBackListCell.reuseID, for: indexPath) as! KtBackListCell
        cell.setModel(user: list?[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "移出黑名单"
    }
    //设置哪些行可以编辑
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
       }
       
       // 设置单元格的编辑的样式
       func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return UITableViewCell.EditingStyle.delete
       }
       
       //设置点击删除之后的操作
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
             log.verbose("none")
        case .none:
            log.verbose("none")
        default:
             log.verbose("none")
        }
           if editingStyle == .delete {
               // Delete the row from the data source
              let body = RequestBody()
            body.userId = UserInfoHelper.instance.user?.id ?? 0
             
              body.backId = list?[indexPath.item].id ?? 0
             removeBaclList(json: body.toJSONString() ?? "", index: indexPath.item)
           }
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
            let lastPath = path[(path.count)-1]
            if  lastPath.item == (list?.count ?? 0) - 1{
                self.getMore()
            }
        }
    }
    
}
