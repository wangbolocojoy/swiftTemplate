//
//  SendPostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 发帖
import UIKit
import YPImagePicker
import AMapSearchKit
class SendPostViewController: BaseViewController {
    
    @IBOutlet weak var postispublic: UISwitch!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var lab_address: UILabel!
    @IBOutlet weak var btn_address: UIView!
    @IBOutlet weak var ev_detail: UITextView!
    lazy var picker = YPImagePicker()
    var list:[UIImage] = [#imageLiteral(resourceName: "addimages")]
     var listvideo:[YPMediaVideo] = []
    let  user = UserInfoHelper.instance.user
    var amappoi:AMapPOI? = nil
    var credentials :Credentials?
    var rightbut : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         rightbut = UIBarButtonItem.init(title: "发布", style: .done, target: self, action: #selector(sendPost))
        self.navigationItem.rightBarButtonItem = rightbut
        let tap = UITapGestureRecognizer(target: self, action: #selector(toAddress))
        btn_address.isUserInteractionEnabled = true
        btn_address.addGestureRecognizer(tap)
    }
    override func initView() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: UploadImageCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: UploadImageCollectionViewCell.reuseID)
        collectionview.collectionViewLayout = CollectionViewLeftFlowLayout()

    }
    
   
    @IBAction func switchpostpublic(_ sender: UISwitch) {
        postispublic.isOn = sender.isOn
    }
    @objc func toAddress(){
        let vc =  getVcByName(vc: .我的地图) as! KtMyMapViewController
        vc.MyMapViewType = 2
        vc.callBackBlock { (POI) in
            if let info = POI{
//                let address = "\(info.province ?? "")\(info.city ?? "")\(info.district ?? "")\(info.address ?? "")\(info.name ?? "")"
                self.amappoi = info
                 let address = "\(info.name ?? "")"
                self.lab_address.text = address
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func sendPost(){
        if list[0] == #imageLiteral(resourceName: "addimages") {
            ShowTip(Title: "请至少选择一张图片")
            return
        }
//        if ev_detail.text.count < 10 {
//            ShowTip(Title: "请至少输入10个字的内容")
//            return
//        }
        var address = ""
        if lab_address.text == "请选择地址" {
            address = ""
        }else{
            address = lab_address.text ?? ""
        }
        let detail = ev_detail.text ?? ""
        rightbut?.isEnabled = false
            MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getosstoken(k: "" )) { (datatoken) in
                      log.verbose(datatoken)
                let param = RequestBody()
                param.userId = UserInfoHelper.instance.user?.id ?? 0
                param.postAddress = address
                param.postDetail = detail
                param.postPublic = self.postispublic.isOn
                param.longitude = "\(self.amappoi?.location.longitude ?? 0.0)"
                param.latitude  = "\(self.amappoi?.location.latitude ?? 0.0)"
                AliyunOssUtil.default.uploadImages(body: param,token: datatoken.osstoken?.credentials, dataAry: self.list as NSArray)
                self.ShowTipsClose(tite: "发送中")
        }
        
       //以前实现上传
        //body: <#RequestBody#>,         let param = ["postDetail": detail  ,"postAddress": address,"latitude":"\(amappoi?.location.latitude ?? 0.0)","longitude":"\(amappoi?.location.longitude ??                            0.0)","postPublic":"\(postispublic.isOn)"
//            ,"uploadType":"image","userId":"\(UserInfoHelper.instance.user?.id ?? 0)"]
//            MyMoyaManager.AllRequest(controller: self, NetworkService.upLoadFiles(K: param, dataAry: self.list as NSArray)) { (data) in
//                self.user?.postNum =  (self.user?.postNum ?? 0) + 1
//                UserInfoHelper.instance.user = self.user
//                self.ShowTipsClose(tite: data.msg ?? "发布成功")
//
//            }
        
    }
    deinit {
          NotificationCenter.default.removeObserver(self)
    }
    func showChooseImagePicker(){
        var config = YPImagePickerConfiguration()
        config.screens = [.photo,.library]
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 6
        picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if items.count != 0{
                 self.list.removeAll()
                self.listvideo.removeAll()
            }
            for item in items {
                   switch item {
                   case .photo(let photo):
                    self.list.append(photo.image)
                   case .video(let video):
                    self.listvideo.append(video)
                    print()
                }
               }
            
            self.collectionview.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func showChooseVideoPicker(){
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .video]
        config.library.mediaType = .video
        picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            log.verbose("items")
            if let video = items.singleVideo {
                print(video.fromCamera)
                print(video.thumbnail)
                print(video.url)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
}

extension SendPostViewController:UICollectionViewDelegateFlowLayout{
    //设置itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3.4, height: collectionView.bounds.width/3.1)
    }
    //设置section内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15 , bottom: 0, right: 15)
    }
    //设置minimumLineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    //设置minimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}
extension SendPostViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if list.count == 6{
            showChooseImagePicker()
        }else if list.count < 6{
            showChooseImagePicker()
        }else{
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadImageCollectionViewCell.reuseID, for: indexPath) as! UploadImageCollectionViewCell
        cell.updateCell(image: list[indexPath.item])
        return cell
    }
    
    
}
