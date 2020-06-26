//
//  KtFabulousViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 赞
import UIKit
import MJRefresh
class KtFabulousViewController: BaseViewController {
    lazy var list : [UserInfo]? = nil
    var postId :Int? = 0
    @IBOutlet weak var tableview: UITableView!
    lazy var body = RequestBody()
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var type = 0
    var hasmore :Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtFabulousTableViewCell.reuseID, bundle: nil), forCellReuseIdentifier: KtFabulousTableViewCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
               tableview.mj_header = header
               footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
               tableview.mj_footer = footer
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        type = 1
        body.page = 0
        body.pageSize = 10
        body.userId = UserInfoHelper.instance.user?.id ?? 0
        body.postId = postId
        getUsers(body: body.toJSONString() ?? "")
    }
    
    func getUsers(body:String){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getpoststartlist(K: body)) { (data) in
                  if self.type == 1 {
                    log.info(data.userlist?.toJSONString() ?? "")
                    self.list = data.userlist
                  }else{
                      self.list! += data.userlist ?? []
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
        body.page = 0
        
        getUsers(body: body.toJSONString() ?? "")
       }
        
    @objc func getMore(){
          if hasmore {
              type = 2
              body.userId = UserInfoHelper.instance.user?.id ?? 0
              body.page = (body.page ?? 0) + 1
            getUsers(body: body.toJSONString() ?? "")
          }else{
              
          }
          
      }
}
extension KtFabulousViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =       tableView.dequeueReusableCell(withIdentifier: KtFabulousTableViewCell.reuseID, for: indexPath) as! KtFabulousTableViewCell
        cell.updateCell(info: list?[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = getVcByName(vc: .粉丝详情) as! FancesInfoViewController
        vc.userId = list?[indexPath.item].id
        vc.userinfo = list?[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
               let lastPath = path[(path.count)-3]
               if  lastPath.item == (self.list?.count ?? 0) - 3{
                   self.getMore()
               }
           }
       }
    
}
