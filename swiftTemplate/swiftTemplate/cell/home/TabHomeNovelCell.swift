//
//  TabHomeNovelCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class TabHomeNovelCell: UITableViewCell {
static let reuseID =  "TabHomeNovelCell"
    
    var cellnovel:NovelInfo? = nil
    @IBOutlet weak var novel_name: UILabel!
    @IBOutlet weak var novel_easyinfo: UILabel!
    @IBOutlet weak var novel_uptime: UILabel!
    @IBOutlet weak var novel_typename: UILabel!
    @IBOutlet weak var novel_state: UILabel!
    @IBOutlet weak var novel_author: UILabel!
    @IBOutlet weak var novel_icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    func updateCell(novel:NovelInfo?){
        cellnovel = novel
        novel_name.text = novel?.novel_name ?? ""
        novel_author.text = novel?.novel_author ?? ""
        novel_state.text = novel?.novel_state ?? ""
        novel_typename.text = novel?.novel_typename ?? ""
        novel_uptime.text = novel?.novel_uptime ?? ""
        novel_easyinfo.text = novel?.novel_easyinfo ?? ""
        novel_icon.setImageUrl(image: novel_icon,string: novel?.novel_img, proimage: #imageLiteral(resourceName: "quanshidaluandou"))
    
    }
    
}
