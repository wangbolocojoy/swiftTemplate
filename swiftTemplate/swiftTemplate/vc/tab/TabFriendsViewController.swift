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
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var list:[UserInfo]? = nil
    var page = 0
    let userid = UserInfoHelper.instance.user?.id ?? 0
    lazy var  countrySearchController:UISearchController? = UISearchController()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self   //两个样例使用不同的代理
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = true
            controller.searchBar.barStyle = .default
            //            controller.view.backgroundColor = .white
            controller.searchBar.placeholder = "输入用户账号查找"
            return controller
        })()
        self.navigationItem.titleView = self.countrySearchController?.searchBar
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: FanceORFollowCell.reuseID, bundle: nil), forCellReuseIdentifier: FanceORFollowCell.reuseID)
        header.setTitle("下拉刷新", for: .idle)
        footer.setRefreshingTarget(self, refreshingAction: #selector(refremore))
        tableview.mj_footer = footer
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        getRecommend()
    }
    @objc func refresh(){
        page=0
        getRecommend()
        footer.resetNoMoreData()
    }
    @IBAction func addfriend(_ sender: Any) {
    }
    
    func getRecommend(){
        let body = RequestBody()
        body.userId = userid
        body.page = page
        body.pageSize = 10
        MyMoyaManager.AllRequest(controller: self, NetworkService.findrecommendlist(k: body.toJSONString() ?? "")) { (data) in
            if self.page == 0 {
                self.list = data.fancefollowlist ?? []
                  self.tableview.reloadData()
            }else{
                if data.fancefollowlist?.count ?? 0 >= 1 {
                     self.list?.append(contentsOf: data.fancefollowlist ?? [])
                     self.tableview.reloadData()
                }else {
                      self.footer.endRefreshingWithNoMoreData()
                    self.tableview.reloadData()
                }
               
              
            }
          
        }
        header.endRefreshing()
        footer.endRefreshing()
    }
    @objc func refremore(){
        page+=1
        getRecommend()
    }
    func follow(index:Int,u:UserInfo?)  {
        let body = RequestBody()
        body.userId = userid
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
extension TabFriendsViewController:UITableViewDelegate,UITableViewDataSource{
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
        cell.updateCell(i:indexPath.item,u: list?[indexPath.item])
        cell.callBackBlock { (i,user) in
            if user?.isFollow ?? false == true {
                self.unfollow(index:i,u: user)
            }else{
                self.follow(index:i,u: user)
            }
        }
        return cell
    }
    
    
}
extension TabFriendsViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
