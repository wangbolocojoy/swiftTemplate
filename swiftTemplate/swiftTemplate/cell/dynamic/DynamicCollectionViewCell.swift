//
//  DynamicCollectionViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/21.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class DynamicCollectionViewCell: UICollectionViewCell {
static let reuseID = "DynamicCollectionViewCell"
   
    @IBOutlet weak var ismoreimage: UIImageView!
    @IBOutlet weak var post_image: UIImageView!
    var list:[PostImages]? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func updateCell(list:[PostImages]? ){
        if list?.count ?? 0 > 1 {
            ismoreimage.isHidden = false
        }else{
            ismoreimage.isHidden = true
        }
        if list?.count != 0 {
            post_image.setImageUrl(image: post_image, string: list?[0].fileUrl, proimage: #imageLiteral(resourceName: "IMG_2507"))
        }
      
    }

}
