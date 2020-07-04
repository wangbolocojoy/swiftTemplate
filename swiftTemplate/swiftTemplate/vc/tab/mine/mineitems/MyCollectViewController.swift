//
//  MyCollectViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 我的收藏
import UIKit
import MJRefresh
class MyCollectViewController: BaseViewController {
    lazy var list :[PostInfo]? = nil
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var type = 0
    var hasmore :Bool = false
    lazy var body = RequestBody()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtMyCollectCell.reuseID, bundle: nil), forCellReuseIdentifier: KtMyCollectCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        type = 1
        body.page = 0
        body.pageSize = 10
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        getCollectList(body: body.toJSONString() ?? "")
    }
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        body.page = 0
        getCollectList(body: body.toJSONString() ?? "")
    }
    
    @objc func getMore(){
        if hasmore {
            type = 2
            body.userId = UserInfoHelper.instance.user?.id ?? 0
            body.page = (body.page ?? 0) + 1
            getCollectList(body: body.toJSONString() ?? "")
        }else{
            
        }
        
    }
    func getCollectList(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getcollectionlist(K: body)) { (data) in
                   if self.type == 1 {
                       log.info(data.userlist?.toJSONString() ?? "")
                       self.list = data.postlist
                   }else{
                       self.list! += data.postlist ?? []
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
    
}
extension MyCollectViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtMyCollectCell.reuseID, for: indexPath) as! KtMyCollectCell
        cell.setModel(md: list?[indexPath.item])
        return cell
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
            let lastPath = path[(path.count)-3]
            if  lastPath.item == (self.list?.count ?? 0) - 3{
                self.getMore()
            }
        }
    }
    
    
}
