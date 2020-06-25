//
//  KtMyMapAddressViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/25.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import AMapSearchKit
class KtMyMapAddressViewCell: UITableViewCell {
static let reuseID =  "KtMyMapAddressViewCell"
    
    @IBOutlet weak var lab_addresstype: UILabel!
    @IBOutlet weak var lab_addressdetail: UILabel!
    @IBOutlet weak var lab_addresstitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func updateCell(info:AMapPOI?){
      
        lab_addresstype.text = info?.type ?? ""
        lab_addresstitle.text = info?.name ?? ""
        lab_addressdetail.text = "\(info?.province ?? "")\(info?.city ?? "")\(info?.district ?? "")\(info?.address ?? "")"
        
    }
    
}
