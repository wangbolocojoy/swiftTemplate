//
//  ScanQrcodeViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/24.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import Kingfisher
class ScanQrcodeViewController: BaseViewController {
    let provider = LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "sdc", ofType: ".gif", inDirectory: "extension")!))
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


  

}
