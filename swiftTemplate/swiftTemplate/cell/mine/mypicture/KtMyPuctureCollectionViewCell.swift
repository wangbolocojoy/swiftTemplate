//
//  KtMyPuctureCollectionViewCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/4.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtMyPuctureCollectionViewCell: UICollectionViewCell {
static let reuseID =  "KtMyPuctureCollectionViewCell"
    
    lazy var model : PostImages? = nil
    @IBOutlet weak var picture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func setModel(md:PostImages?){
        model = md
        updateCell()
    }
    func updateCell(){
        picture.setImageUrl(image: picture, string: model?.fileUrl, proimage: #imageLiteral(resourceName: "IMG_2507"))
    }

}
