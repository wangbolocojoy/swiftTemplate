//
//  BTMUserInfoController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/7.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 个人信息
import UIKit

class BTMUserInfoController: BaseViewController{
    let list = ["账号","昵称","真实姓名","性别","生日"]
    //     let list = ["账号","昵称","真实姓名","个人简介","地区"]
    let list1 = ["个人简介","地区"]
    @IBOutlet weak var tableview: UITableView!
    var user :UserInfo? = nil
    private lazy var pickVC: UIImagePickerController = {
        let pickVC = UIImagePickerController()
        pickVC.allowsEditing = true
        return pickVC
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func initView(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: BTMUserIconCell.reuseID, bundle: nil), forCellReuseIdentifier: BTMUserIconCell.reuseID)
        tableview.register(UINib(nibName: BTMUserItemCell.reuseID, bundle: nil), forCellReuseIdentifier: BTMUserItemCell.reuseID)
        tableview.register(UINib(nibName: BTMCleanHeader.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: BTMCleanHeader.reuseID)
        refresh()
    }
    //上传头像方式弹框
    @objc func showCheckAlre(){
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
    
    func refresh(){
        user = UserInfoHelper.instance.user
        tableview.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
}
extension BTMUserInfoController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return list.count
        default:
            return list1.count
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showCheckAlre()
        case 1:
            switch indexPath.item {
            case 1,2:
                let vc = getVcByName(vc: .修改信息) as! BTMMineEdUserController
                vc.type = list[indexPath.item]
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                log.info("\(list[indexPath.item])")
            }
        case 2:
            switch indexPath.item {
            case 0:
                let vc = getVcByName(vc: .修改信息) as! BTMMineEdUserController
                vc.type = list1[indexPath.item]
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = getVcByName(vc: .我的地图) as! KtMyMapViewController
                vc.MyMapViewType = 1
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                log.info("\(list1[indexPath.item])")
            }
        default:
            log.info("")
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 5
        case 2:
            return 20
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BTMCleanHeader.reuseID) as! BTMCleanHeader
        return header
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        default:
            return 50
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: BTMUserIconCell.reuseID, for: indexPath) as! BTMUserIconCell
            cell.updateCell(user: user)
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: BTMUserItemCell.reuseID, for: indexPath) as! BTMUserItemCell
            cell.updateCell(name: list[indexPath.item], user: user)
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: BTMUserItemCell.reuseID, for: indexPath) as! BTMUserItemCell
            cell.updateCell(name: list1[indexPath.item], user: user)
            return cell
        }
    }
    
}
extension BTMUserInfoController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
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
            self.pickVC.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.7333333333, blue: 0.6117647059, alpha: 1)
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
    //    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        if let typeStr = info[UIImagePickerControllerMediaType] as? String {
    //            if typeStr == "public.image" {
    //                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
    //                    let smallImage = UIImage.imageClipToNewImage(image, newSize:CGSize(width: 90, height: 90 ))
    //                    if UIImagePNGRepresentation(smallImage) == nil {
    //                        avatarData = UIImageJPEGRepresentation(smallImage, 0.8)
    //                    } else {
    //                        avatarData = UIImagePNGRepresentation(smallImage)
    //                    }
    //                    if avatarData != nil {
    //                        //save to local
    //                        FileOP.archive(kAvatarFileName, object: avatarData!)
    //                        //设置avatar圆角边缘颜色及宽度
    //                        let image = UIImage.imageWithClipImage(UIImage(data: avatarData!)!, borderWidth: 2, borderColor: UIColor.whiteColor())
    //                        avatarBtn.setImage(image, forState: .Normal)
    //                    } else {
    //                        SVProgressHUD.showErrorWithStatus("save photo failure")
    //                    }
    //                }
    //            }
    //        } else {
    //            SVProgressHUD.showErrorWithStatus("get photo failure")
    //        }
    //        picker.dismissViewControllerAnimated(true, completion: nil)
    //    }
    //
    //
    //}
    
    //  取消图片选择操作
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.pickVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        let imglist :NSArray = [img]
        let param = ["id":"\(UserInfoHelper.instance.user?.id ?? 0)","uploadtype":"image"]
        MyMoyaManager.AllRequest(controller: self, NetworkService.uodateusericon(k: param, dataAry: imglist)) { (data) in
            UserInfoHelper.instance.user = data.userinfo
            self.refresh()
            self.ShowTip(Title: data.msg)
            
        }
        //            MoyaManager.updateusericon(controller: self, NetworkService.updateusericon(dataAry: imglist, USER_ID: String(describing: UserInfoHelper.instance.getUserId()), USER_TYPE: "USER_MEMBER", UP_TYPE: "MEMBER_HEAD_UPLOAD")) { (result) in
        //                if let date = result{
        //
        //                    self.imgmembericon.image = img
        //                    UserInfoHelper.instance.Userdata?.memberAvatar = date.url
        //                    self.imgurl = date.url
        //                    self.Showalert(Title: "上传头像成功")
        //                }
        //            }
        self.pickVC.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}

