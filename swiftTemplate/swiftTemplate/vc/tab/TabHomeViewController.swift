//
//  TabHomeViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 首页
import UIKit
import MJRefresh
class TabHomeViewController: BaseTabViewController {
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    lazy var list :[PostInfo]? = nil
    var pagebody = RequestBody()
    var page = 0
    var pagesize = 10
    var type = 1
    // 搜索控制器
//      var searchController: UISearchController!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    func getNovel(body:RequestBody){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getposts(k: body.toJSONString()!)) { (data) in
            if self.type == 1 {
                self.list = data.postlist
            }else{
                
            }
            self.tableview.reloadData()
        }
        self.header.endRefreshing()
        self.footer.endRefreshing()
    }
    @objc func refresh(){
        type = 1
        page = 0
        pagebody.page = page
        pagebody.pageSize = 10
        getNovel(body: pagebody)
        
    }
    @objc func getMore(){
//        type = 2
        page+=1
        pagebody.page = page
        pagebody.pageSize = 10
        getNovel(body: pagebody)
    }
    override func initView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none

        tableview.register(UINib(nibName: MainPostCell.reuseID, bundle: nil), forCellReuseIdentifier: MainPostCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
//        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
//        tableview.mj_footer = footer
        type = 1
        pagebody.page = 0
        pagebody.pageSize = 10
        if list?.count ?? 0 != 0 {
            log.info("使用缓存数据\(list?.count ?? 0)条")
            tableview.reloadData()
        }else{
            log.info("从网络获取数据")
            getNovel(body: pagebody)

        }
    }
    
    
}
extension TabHomeViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainPostCell.reuseID, for: indexPath) as! MainPostCell
        cell.updateCell(pinfo: list?[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    
}
extension TabHomeViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
