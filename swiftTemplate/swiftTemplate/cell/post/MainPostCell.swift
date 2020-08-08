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
    @IBOutlet weak var post_status: UILabel!
    @IBOutlet weak var actionheart: UIImageView!
    @IBOutlet weak var poster_more: UIButton!
    @IBOutlet weak var banner: FSPagerView!{
        didSet{
            banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    func callBackBlock(block : @escaping swiftblock)  {
        callBack = block
    }
    var callBack :swiftblock?
    typealias swiftblock = (_ type:Int,_ btntag : PostInfo? ,_ index:Int) -> Void
    @IBOutlet weak var btn_gotostart: UIView!
    @IBOutlet weak var settingpublicview: UIView!
    @IBOutlet weak var post_detail: UILabel!
    @IBOutlet weak var post_auther_nickname: UILabel!
    @IBOutlet weak var post_auther_address: UILabel!
    @IBOutlet weak var pagecontrol: FSPageControl!
    @IBOutlet weak var message_image: UIImageView!
    @IBOutlet weak var btn_message: UIView!
    @IBOutlet weak var lab_postnum: UILabel!
    @IBOutlet weak var lab_startnum: UILabel!
    @IBOutlet weak var btn_collection: UIImageView!
    @IBOutlet weak var btn_share: UIImageView!
    @IBOutlet weak var btn_start: UIImageView!
    @IBOutlet weak var postauther_icon: UIImageView!
    var postinfo : PostInfo? = nil
    var user = UserInfoHelper.instance.user
    var index:Int = 0
    @IBOutlet weak var poster_nickname: UILabel!
    
    
    /// 是否公开帖子
    /// - Parameter sender:
    @IBAction func ispublick(_ sender: Any) {
        
    }
    
    /// 初始化cell
    override func awakeFromNib() {
        super.awakeFromNib()
        banner.dataSource = self
        banner.delegate = self
        banner.isInfinite = false
        banner.transformer = FSPagerViewTransformer(type: .linear)
        pagecontrol.numberOfPages = postinfo?.postImages?.count ?? 0
        pagecontrol.setStrokeColor(.gray, for: .selected)
        pagecontrol.setFillColor(.gray, for: .selected)
        let tapstart = UITapGestureRecognizer(target: self, action: #selector(checkstart))
        btn_start.isUserInteractionEnabled = true
        btn_start.addGestureRecognizer(tapstart)
        let tapcollec = UITapGestureRecognizer(target: self, action: #selector(checkcollection))
        btn_collection.isUserInteractionEnabled = true
        btn_collection.addGestureRecognizer(tapcollec)
        let tapgoststartvc = UITapGestureRecognizer(target: self, action: #selector(toStartUser))
        let tapmessage = UITapGestureRecognizer(target: self, action: #selector(showMessageVC))
        message_image.isUserInteractionEnabled = true
        btn_message.isUserInteractionEnabled = true
        btn_message.addGestureRecognizer(tapmessage)
        message_image.addGestureRecognizer(tapmessage)
        btn_gotostart.isUserInteractionEnabled = true
        btn_gotostart.addGestureRecognizer(tapgoststartvc)
        let tapsharpost = UITapGestureRecognizer(target: self, action: #selector(shareInfo))
        if #available(iOS 13.0, *) {
            btn_share.image = UIImage(systemName: "square.and.arrow.up")
            message_image.image = UIImage(systemName: "text.bubble")
        } else {
            btn_share.image = #imageLiteral(resourceName: "分享")
            message_image.image = #imageLiteral(resourceName: "message")
        }
        
        btn_share.isUserInteractionEnabled = true
        btn_share.addGestureRecognizer(tapsharpost)
        let tappostmore = UITapGestureRecognizer(target: self, action: #selector(showActions))
        poster_more.isUserInteractionEnabled = true
        poster_more.addGestureRecognizer(tappostmore)
        
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
    /// 设置model
    /// - Parameters:
    ///   - pinfo: model
    ///   - ind: 下标
    func setModel(pinfo:PostInfo?,ind:Int){
        index = ind
        postinfo = pinfo
        updateCell()
    }
    /// 更新cell
    func updateCell(){
        banner.reloadData()
        updateStartOrCollection()
        poster_nickname.text = postinfo?.author?.nickName ?? ""
        post_detail.text = postinfo?.postDetail ?? ""
        post_auther_nickname.text = postinfo?.author?.nickName ?? ""
        pagecontrol.numberOfPages = postinfo?.postImages?.count ?? 0
        postauther_icon.setImageUrl(image: postauther_icon,string: postinfo?.author?.icon, proimage: #imageLiteral(resourceName: "背景色"))
        post_auther_address.text = postinfo?.postAddress ?? ""
        lab_postnum.text = "\(postinfo?.postMessageNum ?? 0)"
        switch postinfo?.postState ?? 1 {
        case 0:
            post_status.isHidden = false
            //             post_status.text = "正在审核中"
            //             post_status.textColor = .red
            btn_share.isHidden = true
        case 1:
            post_status.isHidden = true
            btn_share.isHidden = false
        case 2:
            post_status.isHidden = false
            btn_share.isHidden = true
        default:
            post_status.isHidden = false
            btn_share.isHidden = true
        }
        
    }
    
    /// 弹出评论页面
    @objc func showMessageVC(){
        let vc = self.parentViewController()?.getVcByName(vc: .消息列表) as! KtMessagelistViewController
        vc.postinfo = postinfo
        vc.callBackBlock { (Info) in
            self.setModel(pinfo: Info,ind: self.index)
        }
        vc.view.backgroundColor = .clear
        self.parentViewController()?.present(vc, animated: true, completion: nil)
    }
    
    /// 更新点赞状态
    func updateStartOrCollection(){
        if postinfo?.isStart ?? false {
            
            btn_start.tintColor = .red
            
            if #available(iOS 13.0, *) {
                btn_start.image = UIImage(systemName: "heart.fill")
            } else {
                btn_start.image = #imageLiteral(resourceName: "hearts")
            }
        }else{
            if #available(iOS 13.0, *) {
                btn_start.tintColor = .label
                btn_start.image = UIImage(systemName: "heart")
            } else {
                btn_start.tintColor = .black
                btn_start.image = #imageLiteral(resourceName: "heart")
            }
            
        }
        if postinfo?.isCollection ?? false {
            if #available(iOS 13.0, *) {
                //                btn_collection.image = UIImage(systemName: "bookmark.fill")
                btn_collection.image = #imageLiteral(resourceName: "bookmarkfill")
            } else {
                btn_collection.image = #imageLiteral(resourceName: "bookmarkfill")
            }
        }else{
            if #available(iOS 13.0, *) {
                //                btn_collection.image = UIImage(systemName: "bookmark")
                btn_collection.image = #imageLiteral(resourceName: "bookmark")
            } else {
                btn_collection.image = #imageLiteral(resourceName: "bookmark")
            }
        }
        lab_startnum.text = "\(postinfo?.postStarts ?? 0)"
        lab_postnum.text = "\(postinfo?.postMessageNum ?? 0)"
        
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
            log.verbose("已经点过赞了 只显示动画")
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
        MyMoyaManager.AllRequestNospinner(controller: self.parentViewController()!, NetworkService.collection(K: body.toJSONString() ?? "")) { (data) in
            log.verbose("收藏\(data)")
            var list :[PostInfo]? = []
            list?.append(self.postinfo!)
//            CoreDataManager.default.postlist = list
            self.postinfo?.isCollection = true
            
            self.updateStartOrCollection()
        }
    }
    /// 取消收藏
    func uncollectionpost(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.postId = postinfo?.id
        MyMoyaManager.AllRequestNospinner(controller: self.parentViewController()!, NetworkService.cancelcollection(K: body.toJSONString() ?? "")) { (data) in
            log.verbose("取消收藏\(data)")
            var list :[PostInfo]? = []
            list?.append(self.postinfo!)
//            CoreDataManager.default.postlist = list
            self.postinfo?.isCollection = false
            self.updateStartOrCollection()
        }
    }
    /// 点赞
    func start(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.postId = postinfo?.id
        MyMoyaManager.AllRequestNospinner(controller: self.parentViewController()!, NetworkService.poststart(K: body.toJSONString() ?? "")) { (data) in
            log.verbose("点赞\(data)")
            var list :[PostInfo]? = []
            list?.append(self.postinfo!)
//            CoreDataManager.default.postlist = list
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
        MyMoyaManager.AllRequestNospinner(controller: self.parentViewController()!, NetworkService.postunstart(K: body.toJSONString() ?? "")) { (data) in
            log.verbose("取消点赞\(data)")
            var list :[PostInfo]? = []
            list?.append(self.postinfo!)
//            CoreDataManager.default.postlist = list
            self.postinfo?.isStart = false
            self.postinfo?.postStarts = (self.postinfo?.postStarts ?? 1) - 1
            self.updateStartOrCollection()
            //                  self.postanimation()
        }
    }
    
    /// 显示更多
    @objc func showActions(){
        let iconActionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        //        iconActionSheet.addAction(UIAlertAction(title:"举报", style: UIAlertAction.Style.destructive, handler: { (UIAlertAction) in
        //
        //
        //        }))
        
        iconActionSheet.addAction(UIAlertAction(title: "分享", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
           if UserInfoHelper.instance.user != nil {
                self.shareInfo()
           }else{
            self.parentViewController()?.ShowTip(Title: "请登录之后在尝试")
            }
           
        }))
        iconActionSheet.addAction(UIAlertAction(title: "举报", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.reportPost()
        }))
       
        
        if postinfo?.author?.id  == UserInfoHelper.instance.user?.id{
            iconActionSheet.addAction(UIAlertAction(title: "删除帖子", style: UIAlertAction.Style.destructive, handler: { (UIAlertAction) in
                if self.callBack != nil{
                    self.callBack!(2,self.postinfo,self.index)
                }
            }))
        }else{
            iconActionSheet.addAction(UIAlertAction(title: "把该用户加入黑名单", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                       if self.callBack != nil{
                           self.callBack!(3,self.postinfo,self.index)
                       }
                   }))
        }
        
        iconActionSheet.addAction(UIAlertAction(title:"取消", style: UIAlertAction.Style.cancel, handler:nil))
        self.parentViewController()?.present(iconActionSheet, animated: true, completion: nil)
    }
    
    @objc func reportPost(){
        let vc = self.parentViewController()?.getVcByName(vc: .举报原因) as! KtChoiceReportViewController
        vc.postId = postinfo?.id
        self.parentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addbacklist(){
        
    }
    /// 分享post
    @objc func shareInfo(){
        var items : [Any] = []
        items.append("\(postinfo?.postDetail ?? "")")
        let image = self.banner.cellForItem(at: 0)?.imageView?.image ?? #imageLiteral(resourceName: "WechatIMG54")
        items.append(image)
        
        items.append(URL(string: "https://apps.apple.com/cn/app/SwiftKt/id1524082231")!)
        let activityVC = UIActivityViewController(activityItems:items , applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // 如果錯誤存在，跳出錯誤視窗並顯示給使用者。
            if error != nil {
                self.parentViewController()?.ShowTip(Title: error!.localizedDescription)
                return
            }
            // 如果發送成功，跳出提示視窗顯示成功。
            if completed {
                self.parentViewController()?.ShowTip(Title:"分享成功")
            }
        }
        self.parentViewController()?.present(activityVC, animated: true, completion: nil)
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
                    
                    if #available(iOS 13.0, *) {
                        self.btn_start.image = UIImage(systemName: "heart.fill")
                    } else {
                        self.btn_start.image = #imageLiteral(resourceName: "hearts")
                    }
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
        cell.imageView?.setImageUrl(image: cell.imageView!,string: postinfo?.postImages?[index].fileUrl , proimage:#imageLiteral(resourceName: "背景色") )
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
        //               log.verbose("index\(index)")
    }
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        pagecontrol.currentPage = targetIndex
        
    }
    
}
