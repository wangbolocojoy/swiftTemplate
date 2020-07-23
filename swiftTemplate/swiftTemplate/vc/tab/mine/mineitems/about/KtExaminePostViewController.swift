//
//  KtExaminePostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 帖子审核
import UIKit
import MJRefresh
class KtExaminePostViewController: BaseViewController {
    lazy var list :[PostInfo]? = []
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
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
            eachItem.postisselectid =  !(eachItem.postisselectid ?? false)
            list![curIndex] = eachItem
        }
        self.tableview.reloadData()
        
    }
    
    @IBAction func agregram(_ sender: Any) {
        let body = updatePos()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        var listpo : [pstInfo]? = []
        list?.forEach({ (Pos) in
            if Pos.postisselectid ?? false {
                let p = pstInfo()
                p.postId = Pos.id
                p.postState = 1
                listpo?.append( p)
            }
        })
        body.postList = listpo
        updatePosts(json: body.toJSONString() ?? "")
    }
    
    func updatePosts(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.updateposts(k:json)) { (data) in
            self.ShowTip(Title: data.msg)
            self.getpost()
        }
    }
    @IBAction func notagregram(_ sender: Any) {
        let body = updatePos()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        var listpo : [pstInfo]? = []
        list?.forEach({ (Pos) in
            if Pos.postisselectid ?? false {
                let p = pstInfo()
                p.postId = Pos.id
                p.postState = 2
                listpo?.append( p)
            }
        })
        body.postList = listpo
        updatePosts(json: body.toJSONString() ?? "")
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtExaminePostCell.reuseID, bundle: nil), forCellReuseIdentifier: KtExaminePostCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        getpost()
    }
    func getpost(){
        type = 1
        pagebody.page = 0
        pagebody.pageSize = 5
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        pagebody.postState = 0
        getPosts(body: pagebody)
    }
    func getPosts(body:RequestBody){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getposts(k: body.toJSONString()!)) { (data) in
            
            if self.type == 1 {
                self.list = data.postlist
            }else{
                self.list! += data.postlist ?? []
            }
            if data.postlist?.count ?? 0 == 5{
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
        pagebody.pageSize = 5
        pagebody.postState = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getPosts(body: pagebody)
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.postState = 0
            pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
            pagebody.page = (pagebody.page ?? 0) + 1
            pagebody.pageSize = 5
            getPosts(body: pagebody)
        }
        
    }
}
extension KtExaminePostViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtExaminePostCell.reuseID, for: indexPath) as! KtExaminePostCell
        cell.setModel(model: list?[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
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
