//
//  KtMessageCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/27.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtMessageCell: UITableViewCell {
static let reuseID =  "KtMessageCell"
    
    
    @IBOutlet weak var msgstartnum: UILabel!
    @IBOutlet weak var btn_heart: UIImageView!
    @IBOutlet weak var usericon: UIImageView!
    @IBOutlet weak var time: UILabel!
    var msgModel : PostMessage? = nil
    @IBOutlet weak var antuername: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var auther: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func setModel(info:PostMessage?){
        msgModel = info
        updateCell()
    }
    func updateCell(){
        antuername.text = msgModel?.userNickName ?? ""
        msgstartnum.text = "\(msgModel?.messageStart ?? 0)"
        usericon.setImageUrl(image: usericon, string: msgModel?.userIcon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        message.text = msgModel?.message ?? ""
        time.text = msgModel?.postMsgCreatTime?.date2String ?? Date().date2String
    }
   
}
