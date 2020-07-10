//
//  KtAboutHeaderCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/9.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtAboutHeaderCell: UITableViewCell {
static let reuseID =  "KtAboutHeaderCell"
   
    
    @IBOutlet weak var version: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        version.text = "Version  \(Constant.instance.majorVersion)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        
    }
    
}
