//
//  KtAboutDeveloperViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/10.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtAboutDeveloperViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    lazy var developer : DeveloperInfo? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: KtAboutMineInfoCell.reuseID, bundle: nil), forCellReuseIdentifier: KtAboutMineInfoCell.reuseID)
        getDeveloperInfo()
    }
    func getDeveloperInfo(){
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.developerinfo) { (data) in
            self.developer = data.developer
            self.tableview.reloadData()
        }
    }
    
}
extension KtAboutDeveloperViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/1.5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KtAboutMineInfoCell.reuseID, for: indexPath) as! KtAboutMineInfoCell
        cell.setModel(developer: self.developer)
        return cell
    }
    
    
}
