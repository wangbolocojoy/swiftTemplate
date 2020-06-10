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
    lazy var list :[NovelInfo]? = CoreDataManager.shared.getAllNovel()
    var pagebody = RequestBody()
    var page = 1
    var pagesize = 10
    var type = 1
    // 搜索控制器
      var searchController: UISearchController!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化搜索控制器
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
              // 将搜索控制器集成到导航栏上
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    func getNovel(body:RequestBody){
        MyMoyaManager.AllRequest(controller: self, NetworkService.tabhome(K: body.toJSONString()!)) { (data) in
            if self.type == 1 {
                
                self.list = data.novellist
                if data.novellist?.count ?? 0 != 0 {
                    DispatchQueue.global().async {
                        for item in data.novellist ?? [] {
                            CoreDataManager.shared.saveandupdateNovel(item: item)
                        }
                    }
                }
                
            }else{
                self.list?.append(contentsOf: data.novellist ?? [])
                if data.novellist?.count ?? 0 != 0 {
                    DispatchQueue.global().async {
                        for item in data.novellist ?? [] {
                            CoreDataManager.shared.saveandupdateNovel(item: item)
                        }
                    }
                }
            }
            self.tableview.reloadData()
        }
        self.header.endRefreshing()
        self.footer.endRefreshing()
    }
    @objc func refresh(){
        type = 1
        page = 1
        pagebody.page = page
        pagebody.pagesize = 10
        getNovel(body: pagebody)
        
    }
    @objc func getMore(){
        type = 2
        page+=1
        pagebody.page = page
        pagebody.pagesize = 10
        getNovel(body: pagebody)
    }
    override func initView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        self.navigationItem.searchController = UISearchController()
        tableview.register(UINib(nibName: TabHomeNovelCell.reuseID, bundle: nil), forCellReuseIdentifier: TabHomeNovelCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        type = 1
        page = 1
        pagebody.page = page
        pagebody.pagesize = 10
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TabHomeNovelCell.reuseID, for: indexPath) as! TabHomeNovelCell
        cell.updateCell(novel: list?[indexPath.item])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
extension TabHomeViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
