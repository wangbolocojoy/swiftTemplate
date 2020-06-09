//
//  BTMMyFanceFollowViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - TYPE =1 我的粉丝
// MARK: - TYPE =2 我的关注
import UIKit

class BTMMyFanceFollowViewController: BaseViewController {
    var type:Int? = nil
    var list:[UserInfo]? = nil
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView() {
        title = type == 1 ? "我的粉丝":"我的关注"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: FanceORFollowCell.reuseID, bundle: nil), forCellReuseIdentifier: FanceORFollowCell.reuseID)
        getFanceOrFollow()
    }
    
    func getFanceOrFollow(){
        let body = RequestBody()
        body.userid = UserInfoHelper.instance.getUser()?.id ?? 0
        if type ?? 1 == 1 {
            getFanceList(body: body.toJSONString() ?? "")
        }else{
            getFollowList(body: body.toJSONString() ?? "")
        }
    }
    func getFanceList(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getfancelist(k: body)) { (data) in
            self.list = data.fancefollowlist
            self.tableview.reloadData()
        }
    }
    func getFollowList(body:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getfollowlist(k:body)) { (data) in
            self.list = data.fancefollowlist
            self.tableview.reloadData()
        }
    }
    
}
extension BTMMyFanceFollowViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FanceORFollowCell.reuseID, for: indexPath) as! FanceORFollowCell
        cell.updateCell(u: list?[indexPath.item])
        return cell
    }
}
