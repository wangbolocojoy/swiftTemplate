//
//  BaseTableViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/8/4.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {
    var vctitle :String = "列表"
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = vctitle
        
    }
    

 

}
