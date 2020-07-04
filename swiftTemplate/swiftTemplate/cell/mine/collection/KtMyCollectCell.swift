//
//  KtMyCollectCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/28.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtMyCollectCell: UITableViewCell {
static let reuseID =  "KtMyCollectCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    lazy var model : PostInfo? = nil
    @IBOutlet weak var postlist1image: UIImageView!
    @IBOutlet weak var ismore: UIImageView!
    
    @IBOutlet weak var postahtuer: UILabel!
    @IBOutlet weak var postdetail: UILabel!
    @IBOutlet weak var numbermessage: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   func  setModel(md:PostInfo?){
        model = md
        updateCell()
    }
    func updateCell(){
        if model?.postImages?.count != 0 {
             postlist1image.setImageUrl(image: postlist1image, string: model?.postImages?[0].fileUrl , proimage: #imageLiteral(resourceName: "IMG_2507"))
        }else{
             postlist1image.image = #imageLiteral(resourceName: "IMG_2507")
        }
        if model?.postImages?.count ?? 0 > 1 {
            ismore.isHidden = false
        }else{
             ismore.isHidden = true
        }
        postahtuer.text = model?.author?.nickName ?? ""
        postdetail.text = model?.postDetail ??  ""
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
}
