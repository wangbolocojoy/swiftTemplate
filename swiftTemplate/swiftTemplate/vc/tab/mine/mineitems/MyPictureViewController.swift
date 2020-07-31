//
//  MyPictureViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/21.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 我的图片
import UIKit
class MyPictureViewController: BaseViewController {
    lazy var list :[PostImages]? = nil
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = false
    let user = UserInfoHelper.instance.user
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initView() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = CollectionViewLeftFlowLayout()
        collectionview.register(UINib(nibName: KtMyPuctureCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: KtMyPuctureCollectionViewCell.reuseID)
        self.header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        collectionview.mj_header = self.header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        collectionview.mj_footer = footer
        pagebody.pageSize = 20
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getAllImages(json: pagebody.toJSONString() ?? "")
    }
    func getAllImages(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getallimasges(k: json)) { (data) in
            if self.type == 1 {
                self.list = data.mypictures
            }else{
                self.list! += data.mypictures ?? []
            }
            if data.mypictures?.count == 20{
                self.hasmore = true
            }else{
                self.hasmore = false
                self.footer.endRefreshingWithNoMoreData()
            }
            self.collectionview.reloadData()
        }
        footer.endRefreshing()
        header.endRefreshing()
        
    }
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getAllImages(json: pagebody.toJSONString() ?? "")
    }
    @objc func getMore(){
        if !hasmore {
            return
        }
        type = 2
        pagebody.page = (pagebody.page ?? 0) + 1
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getAllImages(json: pagebody.toJSONString() ?? "")
        
    }
    
}
extension MyPictureViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KtMyPuctureCollectionViewCell.reuseID, for: indexPath) as! KtMyPuctureCollectionViewCell
        cell.setModel(md: list?[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.getVcByName(vc: .我的帖子) as! BTMMyPostViewController
        //        vc.vcname = list?[indexPath.item].author?.nickName ?? ""
        //        vc.userid = list?[indexPath.item].author?.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension MyPictureViewController:UICollectionViewDelegateFlowLayout{
    //设置itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.01, height: collectionView.bounds.width/2)
    }
    //设置section内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0.05 , bottom: 0, right: 0.05)
    }
    //设置minimumLineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.2
    }
    //设置minimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.2
    }
}
extension MyPictureViewController:UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(!decelerate){
            self.scrollLoadData()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollLoadData()
    }
    
    func scrollLoadData() {
        if !hasmore {
            return
        }
        let path = collectionview.indexPathsForVisibleItems  as [IndexPath]
        if ( path.count  > 0) {
            let lastPath = path[(path.count)-1]
            if  lastPath.item == (self.list?.count ?? 0) - 1{
                self.getMore()
            }
        }
    }
    
}
