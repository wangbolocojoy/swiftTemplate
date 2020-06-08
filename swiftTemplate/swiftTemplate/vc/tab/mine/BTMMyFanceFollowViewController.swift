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
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView() {
        title = type == 1 ? "我的粉丝":"我的关注"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: BTMUserItemCell.reuseID, bundle: nil), forCellReuseIdentifier: BTMUserItemCell.reuseID)
    }
    
    
}
extension BTMMyFanceFollowViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BTMUserItemCell.reuseID, for: indexPath) as! BTMUserItemCell
        return cell
    }
}
