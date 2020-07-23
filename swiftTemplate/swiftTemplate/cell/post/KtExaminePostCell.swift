//
//  KtExaminePostCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/23.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import FSPagerView
class KtExaminePostCell: UITableViewCell {
    static let reuseID =  "KtExaminePostCell"
    
    
    @IBOutlet weak var postdetail: UILabel!
    @IBOutlet weak var banner: FSPagerView!{
        didSet{
            banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var userisselect: KtCheckBox!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usericon: UIImageView!
    var postmodel :PostInfo? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        banner.dataSource = self
        banner.delegate = self
        banner.isInfinite = false
        banner.transformer = FSPagerViewTransformer(type: .linear)
        
    }
    func setModel(model :PostInfo?){
        postmodel = model
        updateCell()
    }
    func updateCell(){
        postdetail.text = postmodel?.postDetail ?? ""
        username.text = postmodel?.author?.nickName ?? ""
        userisselect.setcheck(isheck: postmodel?.postisselectid ?? false)
        usericon.setImageUrl(image: usericon, string: postmodel?.author?.icon ?? "", proimage: #imageLiteral(resourceName: "IMG_2506"))
        banner.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
extension KtExaminePostCell:FSPagerViewDelegate,FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        postmodel?.postImages?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.setImageUrl(image: cell.imageView!,string: postmodel?.postImages?[index].fileUrl , proimage:#imageLiteral(resourceName: "loadingimg") )
        cell.isHighlighted = false
        return cell
    }
    
    
}
