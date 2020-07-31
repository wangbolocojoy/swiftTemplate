//
//  KtUploadIdCardViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/27.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class KtUploadIdCardViewController: BaseViewController {
    
    @IBOutlet weak var uploadstatus: UIImageView!
    @IBOutlet weak var img_idcounter: UIImageView!
    @IBOutlet weak var img_idname: UIImageView!
    @IBOutlet weak var userrelaseiuess: UILabel!
    @IBOutlet weak var userrelaseidnumber: UILabel!
    @IBOutlet weak var userrelasename: UILabel!
    var idcardmodel :UserIdCard?
    var uploadtype = 0
    var user = UserInfoHelper.instance.user
    private lazy var pickVC: UIImagePickerController = {
        let pickVC = UIImagePickerController()
        pickVC.allowsEditing = true
        return pickVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        
        if user?.authentication ?? false {
//            refresh()
        }else{
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapface))
            img_idname.isUserInteractionEnabled = true
            img_idname.addGestureRecognizer(tap1)
            let tap2 =  UITapGestureRecognizer(target: self, action: #selector(tapback))
            img_idcounter.isUserInteractionEnabled = true
            img_idcounter.addGestureRecognizer(tap2)
        }
         refresh()
        
    }
    @IBAction func upload(_ sender: Any) {
        
    }
    @objc func tapback(){
        showCheckAlre(type: 2)
        
    }
    @objc func tapface(){
        showCheckAlre(type: 1)
    }
    //上传头像方式弹框
    @objc func showCheckAlre(type:Int){
        uploadtype = type
        let iconActionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        iconActionSheet.addAction(UIAlertAction(title:"相册", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if PermissionHelper.instance.photoEnableDelegate(){
                self.openPhotoLibrary()
                //                      self.checkchange(change: false)
            }else{
                self.Showalert(Title: "照片访问受限")
            }
            
        }))
        iconActionSheet.addAction(UIAlertAction(title: "拍照", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if PermissionHelper.instance.cameraEnableDelegate(){
                self.openCamera()
            }else{
                self.Showalert(Title: "相机访问受限")
            }
        }))
        iconActionSheet.addAction(UIAlertAction(title:"取消", style: UIAlertAction.Style.cancel, handler:nil))
        self.present(iconActionSheet, animated: true, completion: nil)
        
    }
    
    //打开相机
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.pickVC.delegate = self
            self.pickVC.allowsEditing = true//允许用户裁剪移动缩放
            self.pickVC.sourceType = UIImagePickerController.SourceType.camera//设置图片来源为相机
            //设置图片拾取器导航条的前景色
            self.pickVC.navigationBar.barTintColor = UIColor.orange
            //设置图片拾取器标题颜色为白色
            self.pickVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            //设置导航条的着色颜色为白色
            self.pickVC.navigationBar.tintColor = UIColor.white
            //在当前视图控制器窗口展示图片拾取器
            self.present(self.pickVC, animated: true, completion : nil )
        }else{
            Showalert(Title : "相机不可用，您可能使用的是模拟器，请切换到真机调试")
        }
        
    }
    
    //打开相册
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            self.pickVC.delegate = self
            self.pickVC.allowsEditing = true//允许用户裁剪移动缩放
            self.pickVC.sourceType = UIImagePickerController.SourceType.photoLibrary//设置图片来源为图库
            //设置图片拾取器导航条的前景色
            self.pickVC.navigationBar.barTintColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            //设置图片拾取器标题颜色为白色
            self.pickVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            //设置导航条的着色颜色为白色
            self.pickVC.navigationBar.tintColor = UIColor.white
            //在当前视图控制器窗口展示图片拾取器
            self.present(self.pickVC, animated: true, completion : nil )
        }else{
            print("读取相册失败")
        }
        
        
    }
    func refresh(){
        let model = IDCardHelper.default.IDCardDTO
        log.verbose(model?.toJSONString() ?? "")
        if model?.name != nil || model?.authority != nil {
            if #available(iOS 13.0, *) {
                uploadstatus.image = UIImage(systemName: "circle.lefthalf.fill")
            } else {
                // Fallback on earlier versions
            }
            uploadstatus.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
        if model?.authentication ?? false {
            if #available(iOS 13.0, *) {
                uploadstatus.image = UIImage(systemName: "circle.fill")
            } else {
                // Fallback on earlier versions
            }
            uploadstatus.tintColor = .green
            img_idname.isUserInteractionEnabled = false
            img_idcounter.isUserInteractionEnabled = false
        }
        img_idname.setImageUrl(image: img_idname, string: model?.frontIdCard ?? "", proimage: #imageLiteral(resourceName: "身份证正面 (3)"))
        img_idcounter.setImageUrl(image: img_idcounter, string: model?.nationalIdCard ?? "", proimage: #imageLiteral(resourceName: "身份证背面 (1)"))
        userrelaseiuess.text = model?.authority ?? ""
        userrelaseidnumber.text = model?.idNum ?? ""
        userrelasename.text = model?.name ?? ""
    }
}
extension KtUploadIdCardViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.pickVC.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let imglist :NSArray = [img]
        var imagetype = "face"
        if uploadtype == 1 {
            imagetype = "face"
        }else{
            imagetype = "back"
        }
        let param = ["userId":"\(UserInfoHelper.instance.user?.id ?? 0)","uploadType":imagetype]
        MyMoyaManager.AllRequest(controller: self, NetworkService.uploadidcard(k: param, dataAry: imglist)) { (data) in
            IDCardHelper.default.IDCardDTO = data.useridcard
            if data.useridcard?.authentication ?? false {
                self.user?.authentication = data.useridcard?.authentication
                UserInfoHelper.instance.user = self.user
            }
            self.refresh()
            self.ShowTip(Title: data.msg)
            
        }
        
        self.pickVC.dismiss(animated: true, completion: nil)
        
        
    }
}
