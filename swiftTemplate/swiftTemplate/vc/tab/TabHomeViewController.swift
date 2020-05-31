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
    var list :[NovelInfo]? = []
    var pagebody = RequestBody()
    var page = 1
    var pagesize = 10
    var type = 1
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        type = 1
               page = 1
               pagebody.page = page
               pagebody.pagesize = 10
               getNovel(body: pagebody)
    }
    func getNovel(body:RequestBody){
        MyMoyaManager.AllRequest(controller: self, NetworkService.tabhome(K: body.toJSONString()!)) { (data) in
            if self.type == 1 {
                self.header.endRefreshing()
                self.list = data.novellist
            
            }else{
                self.list?.append(contentsOf: data.novellist ?? [])
                 self.footer.endRefreshing()
            }
            self.tableview.reloadData()
        }
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
    func initView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: TabHomeNovelCell.reuseID, bundle: nil), forCellReuseIdentifier: TabHomeNovelCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
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
