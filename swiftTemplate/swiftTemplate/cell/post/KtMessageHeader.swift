//
//  KtMessageHeader.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/5.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtMessageHeader: UITableViewHeaderFooterView {
    static let reuseID =  "KtMessageHeader"
    func callBackBlock(block : @escaping swiftblock)  {
        callBack = block
    }
    var callBack :swiftblock?
    typealias swiftblock = (_ btntag : PostMessage? ) -> Void
    @IBOutlet weak var isatuher: UILabel!
    @IBOutlet weak var btn_edmessage: UIView!
    @IBOutlet weak var startnum: UILabel!
    @IBOutlet weak var start: UIImageView!
    @IBOutlet weak var datetime: UILabel!
    @IBOutlet weak var auther: UILabel!
    @IBOutlet weak var messagedetail: UILabel!
    @IBOutlet weak var image: UIImageView!
    var model : PostMessage? = nil
    var postinfo : PostInfo? = nil
    let user = UserInfoHelper.instance.user
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(edComment))
        btn_edmessage.isUserInteractionEnabled = true
        btn_edmessage.addGestureRecognizer(tap)
        let starttap = UITapGestureRecognizer(target: self, action: #selector(msgStart(gesture: )))
        starttap.numberOfTapsRequired = 2
        start.isUserInteractionEnabled = true
        start.addGestureRecognizer(starttap)
        
    }
    
    @objc func edComment(){
        if callBack != nil {
            callBack!(model)
        }
    }
    func setModel(info:PostMessage?,pinf :PostInfo?){
        model = info
        postinfo = pinf
        updateHerader()
    }
    
    func updateHerader(){
        if postinfo?.userId ?? 0 == model?.userId ?? 0 {
            isatuher.isHidden = false
        }else{
            isatuher.isHidden = true
        }
        if model?.isStart ?? false {
            start.image = UIImage(systemName: "heart.fill")
            start.tintColor = .red
        }else{
            start.image = UIImage(systemName: "heart")
            start.tintColor = .label
        }
        startnum.text = "\(model?.messageStart ?? 0)"
        datetime.text = model?.postMsgCreatTime?.string2DateMMdd
        auther.text = model?.userNickName
        messagedetail.text = model?.message
        image.setImageUrl(image: image, string: model?.userIcon, proimage: #imageLiteral(resourceName: "IMG_2507"))
    }
    
    func startMsganimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.start.tintColor = .red
            self.start.image = UIImage(systemName: "heart.fill")
            self.start.transform = CGAffineTransform.identity
                .scaledBy(x: 1.5, y: 1.5)
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.start.transform = CGAffineTransform.identity
                    .scaledBy(x: 1, y: 1)
            }) { (Bool) in
                self.start.transform = CGAffineTransform.identity
            }
        }
        updateHerader()
    }
    func unstartMsganimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.start.tintColor = .label
            self.start.image = UIImage(systemName: "heart")
            self.start.transform = CGAffineTransform.identity
                .scaledBy(x: 1.5, y: 1.5)
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.start.transform = CGAffineTransform.identity
                    .scaledBy(x: 1, y: 1)
            }) { (Bool) in
                self.start.transform = CGAffineTransform.identity
                
            }
        }
         updateHerader()
    }
    @objc func msgStart(gesture:UITapGestureRecognizer){
        if model?.isStart ?? false {
            self.unStartRequest()
        }else{
            self.startRequest()
        }
    }
    
    /// 点赞
    func startRequest(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.msgId = model?.id
        MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.msgstart(k: body.toJSONString() ?? "")) { (data) in
            log.info("点赞\(data)")
            self.model?.isStart = true
            self.model?.messageStart = (self.model?.messageStart ?? 0) + 1
            self.startMsganimation()
        }
    }
    
    func unStartRequest(){
        let body = RequestBody()
        body.userId = user?.id ?? 0
        body.msgId = model?.id
        MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.msgunstart(k: body.toJSONString() ?? "")) { (data) in
            log.info("取消点赞\(data)")
            self.model?.isStart = false
            self.model?.messageStart = (self.model?.messageStart ?? 0) - 1
            self.unstartMsganimation()
        }
    }
    
    
}
