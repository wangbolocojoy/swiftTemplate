//
//  KtAboutItemCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/10.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtAboutItemCell: UITableViewCell {
static let reuseID =  "KtAboutItemCell"
    
    @IBOutlet weak var lab_itemname: UILabel!
    var itemName :String? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func setItemName(name:String?){
        itemName = name
        updateCell()
    }
    func updateCell(){
        lab_itemname.text = itemName ?? ""
    }
    
}
