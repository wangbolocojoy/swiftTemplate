//
//  FancesInfoViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 粉丝详情
import UIKit
import MJRefresh
class FancesInfoViewController: BaseViewController {
    
    var userId :Int? = nil
    var otherId :Int? = 0
    var userinfo :UserInfo? = nil
    lazy var list :[PostInfo]? = nil
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = false
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = userinfo?.nickName ?? "粉丝信息"
        
    }
    override func initView() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = CollectionViewLeftFlowLayout()
        collectionview.register(UINib(nibName: FanceInfoHeaderCell.reuseID, bundle: nil), forCellWithReuseIdentifier: FanceInfoHeaderCell.reuseID)
        collectionview.register(UINib(nibName: DynamicCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: DynamicCollectionViewCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        collectionview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        collectionview.mj_footer = footer
        getuserInfo()
        pagebody.pageSize = 20
        pagebody.page = 0
        pagebody.userId = userinfo?.id ?? 0
        getpost(json: pagebody.toJSONString() ?? "")
    }
    
    func getuserInfo(){
        let body = RequestBody()
        body.id = userId
        MyMoyaManager.AllRequestNospinner(controller: self, NetworkService.getuserinfo(k: body.toJSONString() ?? "")) { (data) in
            self.userinfo = data.userinfo
            self.collectionview.reloadData()
            
        }
        
    }
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.userId = userinfo?.id ?? 0
        getpost(json: pagebody.toJSONString() ?? "")
    }
    @objc func getMore(){
        if !hasmore {
            return
        }
        type = 2
        pagebody.page = (pagebody.page ?? 0) + 1
        pagebody.userId = userinfo?.id ?? 0
        getpost(json: pagebody.toJSONString() ?? "")
        
    }
    func getpost(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getuserposts(k:json )) { (data) in
            log.verbose("getuserposts \(data.postlist?.toJSONString() ?? "")")
            if self.type == 1 {
                self.list = data.postlist
            }else{
                self.list! += data.postlist ?? []
            }
            if data.postlist?.count == 20{
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
    
    
}
extension FancesInfoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return list?.count ?? 0
        default:
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            log.verbose("")
        case 1:
             let vc = self.getVcByName(vc: .我的帖子) as! BTMMyPostViewController
                   vc.vcname = list?[indexPath.item].author?.nickName ?? ""
                   vc.userid = list?[indexPath.item].author?.id ?? 0
                   self.navigationController?.pushViewController(vc, animated: true)
        default:
            log.verbose("")
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FanceInfoHeaderCell.reuseID, for: indexPath) as! FanceInfoHeaderCell
            cell.updateCell(info: userinfo)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicCollectionViewCell.reuseID, for: indexPath) as! DynamicCollectionViewCell
            cell.updateCell(list: list?[indexPath.item].postImages)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicCollectionViewCell.reuseID, for: indexPath) as! DynamicCollectionViewCell
            cell.updateCell(list: list?[indexPath.item].postImages)
            return cell
        }
    }
    
}
extension FancesInfoViewController:UICollectionViewDelegateFlowLayout{
    //设置itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 150)
        case 1:
            return CGSize(width: collectionView.bounds.width/3.01, height: collectionView.bounds.width/3)
        default:
            return CGSize(width: collectionView.bounds.width/3.01, height: collectionView.bounds.width/3)
        }
        
    }
    //设置section内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
        case 1:
            return UIEdgeInsets(top: 0, left: 0.05 , bottom: 0, right: 0.05)
        default:
            return UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
        }
        
    }
    //设置minimumLineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0.2
        default:
            return 0
        }
        
    }
    //设置minimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0.2
        default:
            return 0
        }
        
    }
}
extension FancesInfoViewController:UIScrollViewDelegate{
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
