//
//  MyMessageViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/21.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 我的消息
import UIKit
import MJRefresh
class MyMessageViewController: BaseViewController {
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    lazy var list :[PostMessage]? = nil
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = false
    let user = UserInfoHelper.instance.user
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtMessageCell.reuseID, bundle: nil), forCellReuseIdentifier: KtMessageCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        tableview.mj_footer = footer
        pagebody.pageSize = 20
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getMyMsgs(json: pagebody.toJSONString() ?? "")
    }
    func getMyMsgs(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getusermsgs(k: json)) { (data) in
            if self.type == 1 {
                self.list = data.postmsgs
            }else{
                self.list! += data.postmsgs ?? []
            }
            if data.postmsgs?.count == 20{
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
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getMyMsgs(json: pagebody.toJSONString() ?? "")
    }
    @objc func getMore(){
        if !hasmore {
            return
        }
        type = 2
        pagebody.page = (pagebody.page ?? 0) + 1
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getMyMsgs(json: pagebody.toJSONString() ?? "")
        
    }
    
    func deleteMsg(json:String,index:Int){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.deletecomment(k: json)) { (data) in
            self.list?.remove(at: index)
            self.tableview.reloadData()
        }
    }
    
}
extension MyMessageViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtMessageCell.reuseID, for: indexPath) as! KtMessageCell
        cell.setModel(info: list?[indexPath.item],type: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    //设置哪些行可以编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(list?[indexPath.item].userId == user?.id ){
              return true
          }else{
              return false
          }
      }
      
      // 设置单元格的编辑的样式
      func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
          return UITableViewCell.EditingStyle.delete
      }
      
      //设置点击删除之后的操作
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Delete the row from the data source
             let body = RequestBody()
            body.userId = list?[indexPath.item].userId ?? 0
            body.postId = list?[indexPath.item].postId ?? 0
            deleteMsg(json: body.toJSONString() ?? "", index: indexPath.item)
          }
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
            if  lastPath.item == (self.list?.count ?? 0) - 1{
                self.getMore()
            }
        }
    }
}
