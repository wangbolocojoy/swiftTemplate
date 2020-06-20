//
//  BTMMyPostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 我的日记
import UIKit
 
class BTMMyPostViewController: BaseViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: BTMUserItemCell.reuseID, bundle: nil), forCellReuseIdentifier: BTMUserItemCell.reuseID)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "发帖", style: .done, target: self, action: #selector(toSendPost)), animated: true)
    }
    
    @objc func toSendPost(){
        self.navigationController?.pushViewController(getVcByName(vc: .发帖), animated: true)
    }

}
extension BTMMyPostViewController:UITableViewDataSource,UITableViewDelegate{
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
