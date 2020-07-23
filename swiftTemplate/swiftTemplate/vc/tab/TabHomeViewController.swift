//
//  TabHomeViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
// MARK: - 首页
import UIKit
import MJRefresh
class TabHomeViewController: BaseTabViewController {
   
    lazy var list :[PostInfo]? = nil
    lazy var listpost :[PostStart]? = nil
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = true
    @IBOutlet weak var tableview: UITableView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        CoreDataManager.default.getCoreDataPost(success: { (PostInfolist) in
            self.list = PostInfolist
            self.tableview.reloadData()
        })
        checkPosts()
        
    }
    
    func checkPosts(){
        if list?.count == 0 {
            getpost()
        } else {
            checkIsHavNew()
        }
    }
    func getpost(){
        type = 1
        pagebody.page = 0
        pagebody.pageSize = 5
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getPosts(body: pagebody)
    }
    func checkIsHavNew(){
        let json = RequestBody()
        json.postId = UserDefaults.User.getvalue(forKey: .MAXPostId) as? Int ?? 0
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getisnewpost(k: json.toJSONString() ?? "")) { (data) in
            self.ShowTip(Title: "有新的帖子")
            self.getpost()
        }
        
    }
    @IBAction func btnsendpost(_ sender: Any) {
        self.navigationController?.pushViewController(self.getVcByName(vc: .发帖), animated: true)
    }
    func getPosts(body:RequestBody){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getposts(k: body.toJSONString()!)) { (data) in
            CoreDataManager.default.postlist = data.postlist
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
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getPosts(body: pagebody)
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
            pagebody.page = (pagebody.page ?? 0) + 1
            pagebody.pageSize = 5
            getPosts(body: pagebody)
        }
        
    }
    override func initView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: MainPostCell.reuseID, bundle: nil), forCellReuseIdentifier: MainPostCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        
        
    }
    func deletePost(pfo:PostInfo,index:Int){
        let body = RequestBody()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.postId = pfo.id
        MyMoyaManager.AllRequest(controller: self, NetworkService.deletspost(K: body.toJSONString() ?? "")) { (data) in
            UserInfoHelper.instance.user?.postNum = (UserInfoHelper.instance.user?.postNum ?? 1) - 1
            CoreDataManager.default.deletePost(id: body.postId ?? 0) {
                CoreDataManager.default.getCoreDataPost { (pinl) in
                    CoreDataManager.default.postlist = pinl
                }
            }
            self.list?.remove(at: index)
            self.tableview.reloadData()
        }
    }
    
}
extension TabHomeViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainPostCell.reuseID, for: indexPath) as! MainPostCell
        cell.setModel(pinfo: list?[indexPath.item],ind: indexPath.item)
        cell.callBackBlock { (type, poinfo,index) in
            switch type{
            case 2:
                self.deletePost(pfo: poinfo!, index: index)
                break
            default:
                break
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 560
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
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        log.verbose("滑动")
    //
    //    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let minAlphaOffset:CGFloat = 64.0;
        let maxAlphaOffset:CGFloat = 200.0;
        let offset = scrollView.contentOffset.y;
        let alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
        
//        self.navigationController?.navigationBar.subviews.first?.alpha = alpha
        

        
        
//        self.navigationController
        
    }
    
    
}
extension TabHomeViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
