//
//  BTMMyFanceFollowViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - TYPE =1 我的粉丝
// MARK: - TYPE =2 我的关注
import UIKit

class BTMMyFanceFollowViewController: BaseViewController {
    var type:Int? = nil
    var list:[UserInfo]? = []
    var pagebody = RequestBody()
    var Mjtype = 1
    var hasmore :Bool = true
    let userid = UserInfoHelper.instance.user?.id ?? 0
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView() {
        title = type == 1 ? "我的粉丝":"我的关注"
        Mjtype = type ?? 1
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: FanceORFollowCell.reuseID, bundle: nil), forCellReuseIdentifier: FanceORFollowCell.reuseID)
        tableview.register(UINib(nibName: KtNoDataFooterView.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: KtNoDataFooterView.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        pagebody.pageSize = 15
        
        getFanceOrFollow()
    }
    @objc func refresh(){
        Mjtype = 1
        pagebody.page = 0
        pagebody.userId =  UserInfoHelper.instance.user?.id ?? 0
        if type == 1 {
            getFanceList(body: pagebody.toJSONString() ?? "")
        }else{
            getFollowList(body: pagebody.toJSONString() ?? "")
        }
        
    }
    @objc func getMore(){
        Mjtype = 2
        pagebody.page = (pagebody.page ?? 0) + 1
        pagebody.userId =  UserInfoHelper.instance.user?.id ?? 0
        if type == 1 {
            getFanceList(body: pagebody.toJSONString() ?? "")
        }else{
            getFollowList(body: pagebody.toJSONString() ?? "")
        }
    }
    func getFanceOrFollow(){
        pagebody.page = 0
          pagebody.userId =  UserInfoHelper.instance.user?.id ?? 0
        if type ?? 1 == 1 {
            getFanceList(body: pagebody.toJSONString() ?? "")
        }else{
            getFollowList(body: pagebody.toJSONString() ?? "")
        }
    }
    func getFanceList(body:String){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getfancelist(k: body)) { (data) in
            if self.Mjtype == 1 {
                self.list = data.fancefollowlist
            }else{
                self.list! += data.fancefollowlist ?? []
            }
            if data.postlist?.count ?? 0 == 15{
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
    func getFollowList(body:String){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getfollowlist(k:body)) { (data) in
            if self.Mjtype == 1 {
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
    
    func follow(index:Int,u:UserInfo?)  {
        let body = RequestBody()
        body.userId = userid
        body.followId = u?.id ?? 0
        MyMoyaManager.AllRequest(controller: self, NetworkService.followuser(k: body.toJSONString() ?? "" )) { (data) in
            UserInfoHelper.instance.user = data.userinfo 
            self.ShowTip(Title: data.msg ?? "")
        }
    }
    func unfollow(index:Int,u:UserInfo?){
        let body = RequestBody()
        body.userId = userid
        body.followId = u?.id ?? 0
        MyMoyaManager.AllRequest(controller: self, NetworkService.unfollowuser(k: body.toJSONString() ?? "" )) { (data) in
            
            UserInfoHelper.instance.user = data.userinfo
            self.list?.remove(at:index )
            self.tableview.reloadData()
            self.ShowTip(Title: data.msg ?? "")
        }
    }
    
}
extension BTMMyFanceFollowViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: KtNoDataFooterView.reuseID) as! KtNoDataFooterView
        if type == 1{
            footer.toast_text.text = "暂时没有粉丝，继续努力💪吧"
        }else{
            footer.toast_text.text = "先去关注你喜欢的朋友吧🥰"
        }
        return footer
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if list?.count == 0 || list == nil{
            return 250
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = getVcByName(vc: .粉丝详情) as! FancesInfoViewController
        vc.userinfo = list?[indexPath.item]
        vc.userId = list?[indexPath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FanceORFollowCell.reuseID, for: indexPath) as! FanceORFollowCell
        cell.updateCell(i:indexPath.item,u: list?[indexPath.item],type:type)
        cell.callBackBlock { (indx, user) in
            if user?.isFollow ?? false == true {
                self.unfollow(index: indx, u: user)
            }else{
                self.follow(index: indx, u: user)
            }
        }
        return cell
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate && list?.count ?? 0 != 0){
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
            let lastPath = path[(path.count)-2]
            if  lastPath.item == (list?.count ?? 0) - 2{
                self.getMore()
            }
        }
    }
    
}
