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
    override func awakeFromNib() {
           super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(edComment))
              btn_edmessage.isUserInteractionEnabled = true
               btn_edmessage.addGestureRecognizer(tap)
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
        startnum.text = "\(model?.messageStart ?? 0)"
        datetime.text = model?.postMsgCreatTime?.string2DateMMdd
        auther.text = model?.userNickName
        messagedetail.text = model?.message
        image.setImageUrl(image: image, string: model?.userIcon, proimage: #imageLiteral(resourceName: "IMG_2507"))
    }
}
