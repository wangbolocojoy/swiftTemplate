//
//  SendPostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 发帖
import UIKit
import YPImagePicker
class SendPostViewController: BaseViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var lab_address: UILabel!
    @IBOutlet weak var btn_address: UIView!
    @IBOutlet weak var ev_detail: UITextView!
    lazy var picker = YPImagePicker()
    var list:[UIImage] = [#imageLiteral(resourceName: "添加图片")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: .done, target: self, action: #selector(sendPost))
    }
    override func initView() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: UploadImageCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: UploadImageCollectionViewCell.reuseID)
        collectionview.collectionViewLayout = CollectionViewLeftFlowLayout()
        
    }
    @objc func sendPost(){
        if list[0] == #imageLiteral(resourceName: "添加图片") {
            ShowTip(Title: "请至少选择一张图片")
            return
        }
        if ev_detail.text.count < 10 {
            ShowTip(Title: "请至少输入10个字的内容")
            return
        }
        let postbody = RequestBody()
        postbody.userId = UserInfoHelper.instance.user?.id ?? 0
        if lab_address.text != "请选择地址" {
             postbody.address = lab_address.text
        }
        postbody.postTitle = ""
        postbody.postDetail = ev_detail.text
        MyMoyaManager.AllRequest(controller: self, NetworkService.sendpost(k: postbody.toJSONString() ?? "")) { (data) in
            let param = ["postId":"\(data.sendpost?.id ?? 0)" ,"uploadtype":"image","id":"\(UserInfoHelper.instance.user?.id ?? 0)"]
            MyMoyaManager.AllRequest(controller: self, NetworkService.upLoadFiless(K: param, dataAry: self.list as NSArray)) { (data) in
                self.ShowTipsClose(tite: data.msg ?? "发布成功")
            }
        }
        
    }
    
    func showChooseImagePicker(){
        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 6
        picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if items.count != 0{
                 self.list.removeAll()
            }
            for item in items {
                   switch item {
                   case .photo(let photo):
                    self.list.append(photo.image)
                   case .video( _):
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
            log.info("items")
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
