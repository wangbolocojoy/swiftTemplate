//
//  MainPostCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/20.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit
import FSPagerView
class MainPostCell: UITableViewCell {
static let reuseID =  "MainPostCell"
    
    @IBOutlet weak var poster_more: UIButton!
    
    @IBOutlet weak var banner: FSPageControl!
    
    @IBOutlet weak var ev_message: UITextField!
    @IBOutlet weak var usericon: UIImageView!
    @IBOutlet weak var lab_postnum: UILabel!
    @IBOutlet weak var lab_startnum: UILabel!
    @IBOutlet weak var btn_collection: UIImageView!
    @IBOutlet weak var btn_share: UIImageView!
    @IBOutlet weak var btn_message: UIImageView!
    @IBOutlet weak var btn_start: UIImageView!
    @IBOutlet weak var postauther_icon: UIImageView!
    
    @IBOutlet weak var poster_nickname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    @IBAction func btn_sendmessage(_ sender: Any) {
    }
    
}
