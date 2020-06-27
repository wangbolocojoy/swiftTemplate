//
//  MainPostCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/20.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import FSPagerView
class MainPostCell: UITableViewCell {
    static let reuseID =  "MainPostCell"
    
    @IBOutlet weak var actionheart: UIImageView!
    @IBOutlet weak var poster_more: UIButton!
    
    @IBOutlet weak var banner: FSPagerView!{
        didSet{
            banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var btn_gotostart: UIView!
    
    @IBOutlet weak var post_detail: UILabel!
    @IBOutlet weak var post_auther_nickname: UILabel!
    @IBOutlet weak var post_auther_address: UILabel!
    @IBOutlet weak var pagecontrol: FSPageControl!
    
    @IBOutlet weak var btn_message: UIView!
    @IBOutlet weak var lab_postnum: UILabel!
    @IBOutlet weak var lab_startnum: UILabel!
    @IBOutlet weak var btn_collection: UIImageView!
    @IBOutlet weak var btn_share: UIImageView!
    @IBOutlet weak var btn_start: UIImageView!
    @IBOutlet weak var postauther_icon: UIImageView!
    var postinfo : PostInfo? = nil
    var user = UserInfoHelper.instance.user
    @IBOutlet weak var poster_nickname: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        banner.dataSource = self
        banner.delegate = self
        banner.isInfinite = false
        banner.transformer = FSPagerViewTransformer(type: .linear)
        pagecontrol.numberOfPages = postinfo?.postImages?.count ?? 0
        pagecontrol.setStrokeColor(.label, for: .selected)
        pagecontrol.setFillColor(.label, for: .selected)
        let tapstart = UITapGestureRecognizer(target: self, action: #selector(checkstart))
        btn_start.isUserInteractionEnabled = true
        btn_start.addGestureRecognizer(tapstart)
        let tapcollec = UITapGestureRecognizer(target: self, action: #selector(checkcollection))
        btn_collection.isUserInteractionEnabled = true
        btn_collection.addGestureRecognizer(tapcollec)
        let tapgoststartvc = UITapGestureRecognizer(target: self, action: #selector(toStartUser))
        let tapmessage = UITapGestureRecognizer(target: self, action: #selector(showMessageVC))
        btn_message.isUserInteractionEnabled = true
        btn_message.addGestureRecognizer(tapmessage)
        btn_gotostart.isUserInteractionEnabled = true
        btn_gotostart.addGestureRecognizer(tapgoststartvc)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    /// 去点赞的用户页面
    @objc func toStartUser(){
        let vc = self.parentViewController()?.getVcByName(vc: .赞👍) as! KtFabulousViewController
        vc.postinfo = postinfo
        self.pushVC(vc: vc)
    }
    func setModel(pinfo:PostInfo?){
        postinfo = pinfo
        updateCell()
    }
    func updateCell(){
        banner.reloadData()
        updateStartOrCollection()
        poster_nickname.text = postinfo?.author?.nickName ?? ""
        post_detail.text = postinfo?.postDetail ?? ""
        post_auther_nickname.text = postinfo?.author?.nickName ?? ""
        pagecontrol.numberOfPages = postinfo?.postImages?.count ?? 0
        postauther_icon.setImageUrl(image: postauther_icon,string: postinfo?.author?.icon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        post_auther_address.text = postinfo?.postAddress ?? ""
        lab_postnum.text = "\(postinfo?.postMessageNum ?? 0)"
    }
    
    @objc func showMessageVC(){
        let vc = self.parentViewController()?.getVcByName(vc: .消息列表) as! KtMessagelistViewController
        vc.postinfo = postinfo
        vc.callBackBlock { (Info) in
            self.setModel(pinfo: Info)
        }
        vc.view.backgroundColor = .clear
        self.parentViewController()?.present(vc, animated: true, completion: nil)
    }
    func updateStartOrCollection(){
        if postinfo?.isStart ?? false {
            btn_start.tintColor = .systemPink
            btn_start.image = UIImage(systemName: "heart.fill")
        }else{
            btn_start.tintColor = .label
            btn_start.image = UIImage(systemName: "heart")
        }
        if postinfo?.isCollection ?? false {
            btn_collection.image = UIImage(systemName: "bookmark.fill")
        }else{
            btn_collection.image = UIImage(systemName: "bookmark")
        }
        lab_startnum.text = "\(postinfo?.postStarts ?? 0)"
        lab_postnum.text = "\(postinfo?.msgNum ?? 0)"
        
    }
    /// 选择收藏还是取消收藏
    @objc func  checkcollection(){
        if postinfo?.isCollection ?? false{
            uncollectionpost()
        }else{
            collectionpost()
        }
    }
    /// 选择点赞还是取消点赞
    @objc func checkstart(){
        if postinfo?.isStart ?? false {
            unstart()
        }else{
            start()
        }
        
    }
    /// 双击点赞
    /// - Parameter gesture:
    @objc func postStart(gesture:UITapGestureRecognizer){
        if postinfo?.isStart ?? false {
            log.info("已经点过赞了 只显示动画")
            self.postanimation()
        }else{
            start()
        }
    }
    
    /// 收藏
    func collectionpost(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.postId = postinfo?.id
        MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.collection(K: body.toJSONString() ?? "")) { (data) in
            log.info("收藏\(data)")
            self.postinfo?.isCollection = true
            
            self.updateStartOrCollection()
        }
    }
    /// 取消收藏
    func uncollectionpost(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.postId = postinfo?.id
        MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.cancelcollection(K: body.toJSONString() ?? "")) { (data) in
            log.info("取消收藏\(data)")
            self.postinfo?.isCollection = false
            self.updateStartOrCollection()
        }
    }
    /// 点赞
    func start(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.postId = postinfo?.id
        MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.poststart(K: body.toJSONString() ?? "")) { (data) in
            log.info("点赞\(data)")
            self.postinfo?.isStart = true
            self.postinfo?.postStarts = (self.postinfo?.postStarts ?? 0) + 1
            self.postanimation()
        }
    }
    /// 取消点赞
    func unstart(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.postId = postinfo?.id
        MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.postunstart(K: body.toJSONString() ?? "")) { (data) in
            log.info("取消点赞\(data)")
            self.postinfo?.isStart = false
            self.postinfo?.postStarts = (self.postinfo?.postStarts ?? 1) - 1
            self.updateStartOrCollection()
            //                  self.postanimation()
        }
    }
    /// 点赞动画
    func postanimation(){
        self.actionheart.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.actionheart.transform = CGAffineTransform.identity
                .scaledBy(x: 1.5, y: 1.5)
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.actionheart.transform = CGAffineTransform.identity
                    .rotated(by:CGFloat(Double.pi/5))
                    .scaledBy(x: 1, y: 1)
            }) { (Bool) in
                UIView.animate(withDuration: 0.6, animations: {
                    self.actionheart.transform = CGAffineTransform.identity
                        .translatedBy(x:  (self.btn_start.center.x - self.actionheart.center.x) , y: (self.btn_start.center.y + self.actionheart.center.y)-45)
                        .rotated(by:CGFloat(Double.pi*4))
                        .scaledBy(x: 0.4, y: 0.4)
                    
                }) { (Bool) in
                    self.actionheart.transform = CGAffineTransform.identity
                    self.actionheart.isHidden = true
                    self.btn_start.tintColor = .red
                    self.btn_start.image = UIImage(systemName: "heart.fill")
                    self.lab_startnum.text = "\(self.postinfo?.postStarts ?? 0)"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.btn_start.transform = CGAffineTransform.identity
                            .scaledBy(x: 1.5, y: 1.5)
                    }) { (Bool) in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.btn_start.transform = CGAffineTransform.identity
                                .scaledBy(x: 1, y: 1)
                        }) { (Bool) in
                            self.btn_start.transform = CGAffineTransform.identity
                        }
                    }
                }
                
            }
            //
        }
    }
    
}
extension MainPostCell:FSPagerViewDelegate,FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return postinfo?.postImages?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.setImageUrl(image: cell.imageView!,string: postinfo?.postImages?[index].fileUrl , proimage:#imageLiteral(resourceName: "IMG_2507") )
        cell.isHighlighted = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(postStart(gesture: )))
        cell.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        cell.backgroundColor = .clear
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
