//
//  KtMessageCell.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/27.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtMessageCell: UITableViewCell {
    static let reuseID =  "KtMessageCell"
    
    func callBackBlock(block : @escaping swiftblock)  {
        callBack = block
    }
    var callBack :swiftblock?
    typealias swiftblock = (_ btntag : PostMessage? ) -> Void
    @IBOutlet weak var relu_massage: UILabel!
    @IBOutlet weak var rely_show: UIView!
    @IBOutlet weak var rely_nickname: UILabel!
    @IBOutlet weak var btn_sendmsg: UIView!
    @IBOutlet weak var msgstartnum: UILabel!
    @IBOutlet weak var btn_heart: UIImageView!
    @IBOutlet weak var usericon: UIImageView!
    @IBOutlet weak var time: UILabel!
    var msgModel : PostMessage? = nil
    @IBOutlet weak var antuername: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var auther: UILabel!
    var postinfo : PostInfo? = nil
    let user = UserInfoHelper.instance.user
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(edComment))
        btn_sendmsg.isUserInteractionEnabled = true
        btn_sendmsg.addGestureRecognizer(tap)
        let starttap = UITapGestureRecognizer(target: self, action: #selector(msgStart(gesture: )))
              starttap.numberOfTapsRequired = 2
              btn_heart.isUserInteractionEnabled = true
              btn_heart.addGestureRecognizer(starttap)
    }
    
    @objc func msgStart(gesture:UITapGestureRecognizer){
          if msgModel?.isStart ?? false {
              self.unStartRequest()
          }else{
              self.startRequest()
          }
      }
      
      /// 点赞
      func startRequest(){
          let body = RequestBody()
          body.userId = user?.id ?? 0
          body.msgId = msgModel?.id
          MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.msgstart(k: body.toJSONString() ?? "")) { (data) in
              log.info("点赞\(data)")
              self.msgModel?.isStart = true
              self.msgModel?.messageStart = (self.msgModel?.messageStart ?? 0) + 1
              self.startMsganimation()
          }
      }
      
      func unStartRequest(){
          let body = RequestBody()
          body.userId = user?.id ?? 0
          body.msgId = msgModel?.id
          MyMoyaManager.AllRequest(controller: self.parentViewController()!, NetworkService.msgunstart(k: body.toJSONString() ?? "")) { (data) in
              log.info("取消点赞\(data)")
              self.msgModel?.isStart = false
              self.msgModel?.messageStart = (self.msgModel?.messageStart ?? 0) - 1
              self.unstartMsganimation()
          }
      }
      func startMsganimation(){
            UIView.animate(withDuration: 0.3, animations: {
                self.btn_heart.tintColor = .red
                self.btn_heart.image = UIImage(systemName: "heart.fill")
                self.btn_heart.transform = CGAffineTransform.identity
                    .scaledBy(x: 1.5, y: 1.5)
            }) { (Bool) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.btn_heart.transform = CGAffineTransform.identity
                        .scaledBy(x: 1, y: 1)
                }) { (Bool) in
                    self.btn_heart.transform = CGAffineTransform.identity
                }
            }
            updateCell()
        }
        func unstartMsganimation(){
            UIView.animate(withDuration: 0.3, animations: {
                self.btn_heart.tintColor = .label
                self.btn_heart.image = UIImage(systemName: "heart")
                self.btn_heart.transform = CGAffineTransform.identity
                    .scaledBy(x: 1.5, y: 1.5)
            }) { (Bool) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.btn_heart.transform = CGAffineTransform.identity
                        .scaledBy(x: 1, y: 1)
                }) { (Bool) in
                    self.btn_heart.transform = CGAffineTransform.identity
                    
                }
            }
             updateCell()
        }
    @objc func edComment(){
        if callBack != nil {
            callBack!(msgModel)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    func setModel(info:PostMessage?,pinf:PostInfo?){
        msgModel = info
        postinfo = pinf
        log.info(msgModel?.toJSONString() ?? "")
        updateCell()
    }
    
    func setModel(info:PostMessage?,type:Int){
        msgModel = info
        log.info(msgModel?.toJSONString() ?? "")
        updateCell(type:type)
    }
    func updateCell(){
        if msgModel?.userId ?? 0 == postinfo?.userId ?? 0{
            auther.isHidden = false
        }else{
            auther.isHidden = true
        }
        if msgModel?.replyNickName != nil {
            rely_show.isHidden = false
            message.isHidden = true
        }else{
            rely_show.isHidden = true
            message.isHidden = false
        }
        if msgModel?.isStart ?? false {
                   btn_heart.image = UIImage(systemName: "heart.fill")
                   btn_heart.tintColor = .red
        }else{
                   btn_heart.image = UIImage(systemName: "heart")
                   btn_heart.tintColor = .label
        }
        rely_nickname.text = msgModel?.replyNickName ?? ""
        relu_massage.text = msgModel?.message ?? ""
        antuername.text = msgModel?.userNickName ?? ""
        msgstartnum.text = "\(msgModel?.messageStart ?? 0)"
        usericon.setImageUrl(image: usericon, string: msgModel?.userIcon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        message.text = msgModel?.message ?? ""
        time.text = msgModel?.postMsgCreatTime?.string2DateMMdd  ?? Date().date2String
    }
    func updateCell(type:Int){
        if msgModel?.userId ?? 0 == postinfo?.userId ?? 0{
            auther.isHidden = false
        }else{
            auther.isHidden = true
        }
        if msgModel?.replyNickName != nil {
            rely_show.isHidden = false
            message.isHidden = true
        }else{
            rely_show.isHidden = true
            message.isHidden = false
        }
        rely_nickname.text = msgModel?.replyNickName ?? ""
        relu_massage.text = msgModel?.message ?? ""
        btn_heart.isHidden = true
        msgstartnum.isHidden = true
        antuername.text = msgModel?.userNickName ?? ""
        msgstartnum.text = "\(msgModel?.messageStart ?? 0)"
        usericon.setImageUrl(image: usericon, string: msgModel?.userIcon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        message.text = msgModel?.message ?? ""
        time.text = msgModel?.postMsgCreatTime?.string2DateMMdd  ?? Date().date2String
    }
    
}
