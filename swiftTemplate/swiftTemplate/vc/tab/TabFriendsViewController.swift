//
//  TabFriendsViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 通讯录
import UIKit
import MJRefresh
class TabFriendsViewController: BaseTabViewController {
    var pagebody = RequestBody()
    var type = 1
    var list:[UserInfo]? = []
    var page = 0
    var hasmore :Bool = true
    lazy var  countrySearchController:UISearchController? = UISearchController()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        //        self.countrySearchController = ({
        //            let controller = UISearchController(searchResultsController: nil)
        //            controller.searchResultsUpdater = self   //两个样例使用不同的代理
        //            controller.hidesNavigationBarDuringPresentation = false
        //            controller.dimsBackgroundDuringPresentation = true
        //            controller.searchBar.barStyle = .default
        //            //            controller.view.backgroundColor = .white
        //            controller.searchBar.placeholder = "输入用户账号查找"
        //            return controller
        //        })()
        //        self.navigationItem.titleView = self.countrySearchController?.searchBar
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: FanceORFollowCell.reuseID, bundle: nil), forCellReuseIdentifier: FanceORFollowCell.reuseID)
        tableview.register(UINib(nibName: KtNoDataFooterView.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: KtNoDataFooterView.reuseID)
        tableview.register(UINib(nibName: KtNeedLoginView.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: KtNeedLoginView.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        pagebody.pageSize = 15
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getRecommend(body: pagebody.toJSONString() ?? "")
        
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.page = (pagebody.page ?? 0) + 1
            getRecommend(body: pagebody.toJSONString() ?? "")
        }
        
    }
    @objc func refresh(){
        pagebody.page  = 0
        footer.resetNoMoreData()
        getRecommend(body: pagebody.toJSONString() ?? "")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    @IBAction func addfriend(_ sender: Any) {
    }
    
    func getRecommend(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.findrecommendlist(k: body)) { (data) in
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
    
    func follow(index:Int,u:UserInfo?)  {
        let body = RequestBody()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.followId = u?.id ?? 0
        MyMoyaManager.AllRequest(controller: self, NetworkService.followuser(k: body.toJSONString() ?? "" )) { (data) in
            UserInfoHelper.instance.user = data.userinfo
            self.list?.remove(at:index )
            self.tableview.reloadData()
            self.ShowTip(Title: data.msg ?? "")
        }
    }
    func unfollow(index:Int,u:UserInfo?){
        let body = RequestBody()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.followId = u?.id ?? 0
        MyMoyaManager.AllRequest(controller: self, NetworkService.unfollowuser(k: body.toJSONString() ?? "" )) { (data) in
            UserInfoHelper.instance.user = data.userinfo
            self.list?.remove(at:index )
            self.tableview.reloadData()
            
            self.ShowTip(Title: data.msg ?? "")
        }
    }
}
extension TabFriendsViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = getVcByName(vc: .粉丝详情) as! FancesInfoViewController
        vc.userinfo = list?[indexPath.item]
        vc.userId = list?[indexPath.item].id
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FanceORFollowCell.reuseID, for: indexPath) as! FanceORFollowCell
        cell.updateCell(i:indexPath.item,u: list?[indexPath.item], type: 0)
        cell.callBackBlock { (i,user) in
            if user?.isFollow ?? false == true {
                self.unfollow(index:i,u: user)
            }else{
                self.follow(index:i,u: user)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: KtNoDataFooterView.reuseID) as! KtNoDataFooterView
        footer.toast_text.text = "没有更多推荐，请稍后再试"
        return footer
        
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if list?.count == 0 {
            return 250
        }else{
            return 0
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
        if !hasmore || list?.count ?? 0 == 0{
            return
        }
        let path = tableview.indexPathsForVisibleRows!  as [IndexPath]
        if ( path.count  > 0) {
            let lastPath = path[(path.count)-3]
            if  lastPath.item == (list?.count ?? 0) - 3{
                self.getMore()
            }
        }
    }
}
extension TabFriendsViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
