//
//  KtFeekBackListViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/11.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import MJRefresh
class KtFeekBackListViewController: BaseViewController {
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var type = 0
    lazy var body = RequestBody()
    lazy var list :[FeekBackInfo]? = nil
    var hasmore :Bool = false
    var height:Float = 200
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.estimatedRowHeight = 200
        tableview.rowHeight = UITableView.automaticDimension
        tableview.register(UINib(nibName: KtFeekBackCell.reuseID, bundle: nil), forCellReuseIdentifier: KtFeekBackCell.reuseID)
        type = 1
        body.page = 0
        body.pageSize = 20
        getBeekList(body: body.toJSONString() ?? "")
    }
    func getBeekList(body:String){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getfeekbacklist(k: body)) { (data) in
            if self.type == 1 {
                log.verbose(data.userlist?.toJSONString() ?? "")
                self.list = data.feekbacklist
            }else{
                self.list! += data.feekbacklist ?? []
            }
            if data.postmsgs?.count ?? 0 == 20{
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
        body.page = 0
        getBeekList(body: body.toJSONString() ?? "")
    }
    
    @objc func getMore(){
        if hasmore {
            type = 2
            body.page = (body.page ?? 0) + 1
            getBeekList(body: body.toJSONString() ?? "")
        }
    }
    
}
extension KtFeekBackListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtFeekBackCell.reuseID, for: indexPath) as! KtFeekBackCell
        cell.setModel(feekbackinfo: list?[indexPath.item])
        height = Float(cell.feekbackmsg.bounds.height + cell.feekbacktime.bounds.height + 30.0)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
}
extension KtFeekBackListViewController:UIScrollViewDelegate{
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
            let lastPath = path[(path.count)-3]
            if  lastPath.item == (self.list?.count ?? 0) - 3{
                self.getMore()
            }
        }
    }
}
