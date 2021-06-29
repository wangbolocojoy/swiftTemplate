//
//  TabHomeViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
// MARK: - 首页
import UIKit
import MJRefresh
import CryptoSwift
class TabHomeViewController: BaseTabViewController {
    
    lazy var list :[PostInfo]? = []
    lazy var listpost :[PostStart]? = []
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = true
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if UserInfoHelper.instance.user?.authentication ?? false {
            self.navigationController?.pushViewController(self.getVcByName(vc: .发帖), animated: true)
        }else{
            if UserInfoHelper.instance.user == nil {
                let vc = getVcByName(vc: .登录) as! LoginViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                self.navigationController?.pushViewController(self.getVcByName(vc: .身份证上传), animated: true)
            }
        }
        
    }
    func getPosts(body:RequestBody){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getposts(k: body.toJSONString()!)) { (data) in
            //            CoreDataManager.default.postlist = data.postlist
            if self.type == 1 {
                self.list = data.postlist
            }else{
                self.list! += data.postlist ?? []
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
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getPosts(body: pagebody)
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
            pagebody.page = (pagebody.page ?? 0) + 1
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
        pagebody.pageSize = 10
        self.getpost()
        
    }
    func getpost(){
        type = 1
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getPosts(body: pagebody)
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
    func addbacklist(pfo:PostInfo){
        let body = RequestBody()
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.backId = pfo.userId
        MyMoyaManager.AllRequest(controller: self, NetworkService.addbacklist(k: body.toJSONString() ?? "")) { (data) in
            //            CoreDataManager.default.deleteAllPost {
            self.getpost()
            //            }
            
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
            case 3:
                self.addbacklist(pfo: poinfo!)
                break
            default:
                break
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
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
            let lastPath = path[(path.count)-2]
            if  lastPath.item == (list?.count ?? 0) - 2{
                self.getMore()
            }
        }
    }
    
    
    
    
}

