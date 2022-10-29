//
//  KtFeekBackCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/11.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtFeekBackCell: UITableViewCell {
static let reuseID =  "KtFeekBackCell"
    @IBOutlet weak var feekbackusericon: UIImageView!
    @IBOutlet weak var feekbackmsg: UILabel!
    @IBOutlet weak var feekbacktime: UILabel!
    lazy var model :FeekBackInfo? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func setModel(feekbackinfo:FeekBackInfo?){
        model = feekbackinfo
        updateCell()
    }
   func updateCell(){
    feekbackusericon.setImageUrl(image: feekbackusericon, string: model?.userIcon, proimage: #imageLiteral(resourceName: "IMG_2506"))
    feekbackmsg.text = model?.userMsg ?? ""
    feekbacktime.text = model?.backTime?.string2DateMMdd ?? Date().date2String
    }
    
}
