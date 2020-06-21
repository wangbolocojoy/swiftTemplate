//
//  TabHomeViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 首页
import UIKit
import MJRefresh
class TabHomeViewController: BaseTabViewController {
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    lazy var list :[PostInfo]? = nil
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = false
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func getNovel(body:RequestBody){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getposts(k: body.toJSONString()!)) { (data) in
            if self.type == 1 {
                self.list = data.postlist
                
            }else{
                
                self.list! += data.postlist ?? []
            }
            if data.postlist?.count ?? 0 == 3{
                self.hasmore = true
            }else{
                self.hasmore = false
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
        pagebody.pageSize = 3
        getNovel(body: pagebody)
        
    }
    @objc func getMore(){
        if hasmore {
            type = 2
            pagebody.page = (pagebody.page ?? 0) + 1
            pagebody.pageSize = 3
            getNovel(body: pagebody)
        }else{
            footer.endRefreshingWithNoMoreData()
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
        type = 1
        pagebody.page = 0
        pagebody.pageSize = 3
        getNovel(body: pagebody)
    }
    
    
}
extension TabHomeViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainPostCell.reuseID, for: indexPath) as! MainPostCell
        cell.updateCell(pinfo: list?[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate){
            //             print("手指离开屏幕之后页面直接停住到这里")
            self.scrollLoadData()
        }else{
            //            print("这里是页面没停住 继续滑动 但是时间点是手指离开屏幕的瞬间")
            //            print("这种情况就等页面自然停住 然后走scrollViewDidEndDecelerating方法")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        print("手指离开屏幕之后 页面还以某个速度继续滑 然后在停下的时候 到这里")
        self.scrollLoadData()
    }
    
    func scrollLoadData() {
        let path = tableview.indexPathsForVisibleRows!  as [IndexPath]
        //        log.info("path.count---\( path.count)")
        if ( path.count  > 0) {
            let lastPath = path[(path.count)-1]
            //            log.info("lastPath\( lastPath.item)")
            //             log.info("self.list?.count\( self.list?.count ?? 0 - 1)")
            //如果是最后一行了 加载新数据 //这里应该再加一层判断返回的数据已经没有后续页可翻了
            if  lastPath.item == (self.list?.count ?? 0) - 1{
                //                print("滑动到最后了")
                self.getMore()
            }
        }
    }
}
extension TabHomeViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
