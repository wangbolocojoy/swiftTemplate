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
    
    @IBOutlet weak var banner: FSPagerView!{
        didSet{
            banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var btn_sendmessage: UIImageView!
    @IBOutlet weak var post_detail: UILabel!
    @IBOutlet weak var post_auther_nickname: UILabel!
    @IBOutlet weak var post_auther_address: UILabel!
    @IBOutlet weak var pagecontrol: FSPageControl!
    @IBOutlet weak var ev_message: UITextField!
    @IBOutlet weak var usericon: UIImageView!
    @IBOutlet weak var lab_postnum: UILabel!
    @IBOutlet weak var lab_startnum: UILabel!
    @IBOutlet weak var btn_collection: UIImageView!
    @IBOutlet weak var btn_share: UIImageView!
    @IBOutlet weak var btn_message: UIImageView!
    @IBOutlet weak var btn_start: UIImageView!
    @IBOutlet weak var postauther_icon: UIImageView!
    var postinfo : PostInfo? = nil
    
    @IBOutlet weak var poster_nickname: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        banner.dataSource = self
        banner.delegate = self
        banner.isInfinite = false
        banner.transformer = FSPagerViewTransformer(type: .linear)
        // Initialization code
        pagecontrol.numberOfPages = postinfo?.postImages?.count ?? 0
        pagecontrol.setStrokeColor(.label, for: .selected)
        pagecontrol.setFillColor(.label, for: .selected)
        usericon.setImageUrl(image: usericon,string: UserInfoHelper.instance.user?.icon, proimage: #imageLiteral(resourceName: "IMG_2506"))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
  
    func updateCell(pinfo:PostInfo?){
        postinfo = pinfo
        banner.reloadData()
        poster_nickname.text = pinfo?.author?.nickName ?? ""
        post_detail.text = pinfo?.postDetail ?? ""
        post_auther_nickname.text = pinfo?.author?.nickName ?? ""
        pagecontrol.numberOfPages = pinfo?.postImages?.count ?? 0
        postauther_icon.setImageUrl(image: postauther_icon,string: pinfo?.author?.icon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        usericon.setImageUrl(image: usericon,string: UserInfoHelper.instance.user?.icon, proimage: #imageLiteral(resourceName: "IMG_2506"))
    }
    
}
extension MainPostCell:FSPagerViewDelegate,FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return postinfo?.postImages?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.setImageUrl(image: cell.imageView!,string: postinfo?.postImages?[index].fileUrl , proimage:#imageLiteral(resourceName: "IMG_2507") )
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
       
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
       
    }
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
//        pagecontrol.currentPage = index
//               log.info("index\(index)")
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pagecontrol.currentPage = targetIndex
        
    }
    
}
