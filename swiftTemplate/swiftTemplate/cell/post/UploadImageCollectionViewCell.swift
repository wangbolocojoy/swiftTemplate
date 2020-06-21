//
//  UploadImageCollectionViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 波王. All rights reserved.
//

import UIKit

class UploadImageCollectionViewCell: UICollectionViewCell {
static let reuseID =  "UploadImageCollectionViewCell"
    
    @IBOutlet weak var image_post: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func updateCell(image:UIImage){
        image_post.image = image
    }

}
