//
//  MineItemViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/6.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class MineItemViewCell: UITableViewCell {
static let reuseID =  "MineItemViewCell"
    
    @IBOutlet weak var item_image: UIImageView!
    @IBOutlet weak var item_rightname: UILabel!
    
    @IBOutlet weak var item_leftname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    func  updetaCell(image:UIImage?,lname:String?,rname:String?){
        item_image.image = image
        item_leftname.text = lname
        item_rightname.text = rname
    }
}
