//
//  BTMMyPostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 我的日记
import UIKit
import MJRefresh

class BTMMyPostViewController: BaseViewController {
   
    var pagebody = RequestBody()
    lazy var list:[PostInfo]? = nil
    var vcname = "我的主页"
    var type = 1
    var hasmore = false
    var userid = 0
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        title = vcname
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: MainPostCell.reuseID, bundle: nil), forCellReuseIdentifier: MainPostCell.reuseID)
        if vcname == "我的主页" {
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "发帖", style: .done, target: self, action: #selector(toSendPost)), animated: true)
        }
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        header.setTitle("下拉刷新", for: .idle)
        tableview.mj_header = header
        pagebody.pageSize = 3
        pagebody.page = 0
        pagebody.userId = userid
        getpost(json: pagebody.toJSONString() ?? "")
    }
    @objc func toSendPost(){
        if UserInfoHelper.instance.user?.authentication ?? false {
             self.navigationController?.pushViewController(getVcByName(vc: .发帖), animated: true)
        }else{
            self.navigationController?.pushViewController(getVcByName(vc: .身份证上传), animated: true)
        }
       
    }
    
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.userId = userid
        getpost(json: pagebody.toJSONString() ?? "")
    }
    @objc func getMore(){
        if !hasmore {
            return
        }
        type = 2
        pagebody.page = (pagebody.page ?? 0) + 1
        pagebody.userId = userid
        getpost(json: pagebody.toJSONString() ?? "")
        
    }
    func getpost(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getmyallposts(k:json )) { (data) in
            if self.type == 1 {
                self.list = data.postlist
            }else{
                self.list! += data.postlist ?? []
            }
            if data.postlist?.count == 3{
                self.hasmore = true
            }else{
                self.hasmore = false
                self.footer.endRefreshingWithNoMoreData()
            }
            self.tableview.reloadData()
        }
        footer.endRefreshing()
        header.endRefreshing()
    }
    func deletePost(pfo:PostInfo,index:Int){
        let body = RequestBody()
           body.userId = UserInfoHelper.instance.user?.id ?? 0
           body.postId = pfo.id
           MyMoyaManager.AllRequest(controller: self, NetworkService.deletspost(K: body.toJSONString() ?? "")) { (data) in
            UserInfoHelper.instance.user?.postNum = (UserInfoHelper.instance.user?.postNum ?? 1) - 1
               self.list?.remove(at: index)
               self.tableview.reloadData()
           }
       }
    
}
extension BTMMyPostViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 560
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainPostCell.reuseID, for: indexPath) as! MainPostCell
        cell.setModel(pinfo: list?[indexPath.item],ind: indexPath.item)
        cell.callBackBlock { (type, poinfo,index) in
                   switch type{
                   case 2:
                    self.deletePost(pfo: poinfo!, index: index) 
                   default:
                       break
                   }
               }
        return cell
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
            if  lastPath.item == (self.list?.count ?? 0) - 1{
                self.getMore()
            }
        }
    }
    
}
