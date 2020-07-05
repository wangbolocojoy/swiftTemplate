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
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(edComment))
        btn_sendmsg.isUserInteractionEnabled = true
        btn_sendmsg.addGestureRecognizer(tap)
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
