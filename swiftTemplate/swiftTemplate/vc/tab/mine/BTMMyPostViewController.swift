//
//  BTMMyPostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 我的日记
import UIKit
import MJRefresh

class BTMMyPostViewController: BaseViewController {
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    var pagebody = RequestBody()
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: MainPostCell.reuseID, bundle: nil), forCellReuseIdentifier: MainPostCell.reuseID)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "发帖", style: .done, target: self, action: #selector(toSendPost)), animated: true)
       
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        header.setTitle("下拉刷新", for: .idle)
        tableview.mj_header = header
        pagebody.pageSize = 10
    }
    
    @objc func toSendPost(){
        self.navigationController?.pushViewController(getVcByName(vc: .发帖), animated: true)
    }
    
    @objc func refresh(){
        pagebody.page = 1
        getpost(json: pagebody.toJSONString() ?? "")
    }
    @objc func getMore(){
        pagebody.page = pagebody.page ?? 1 + 1
        getpost(json: pagebody.toJSONString() ?? "")
    }
    func getpost(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getposts(k:json )) { (data) in
        }
    }
    
}
extension BTMMyPostViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainPostCell.reuseID, for: indexPath) as! MainPostCell
        return cell
    }
    
    
}
