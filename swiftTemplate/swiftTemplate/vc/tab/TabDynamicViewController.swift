//
//  TabDynamicViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/8.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//
// MARK: - 发现
import UIKit
import MJRefresh
class TabDynamicViewController: BaseTabViewController{
    
    let footer = MJRefreshBackFooter()
    let header = MJRefreshNormalHeader()
    lazy var list :[PostInfo]? = nil
    var pagebody = RequestBody()
    var type = 1
    var hasmore :Bool = false
    lazy var  countrySearchController:UISearchController? = UISearchController()
    @IBOutlet weak var collectionview: UICollectionView!
    let user = UserInfoHelper.instance.user
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.list = CoreDataManager.default.postlist
        self.collectionview.reloadData()
              
    }
    override func initView() {
//        self.countrySearchController = ({
//            let controller = UISearchController(searchResultsController: nil)
//            controller.searchResultsUpdater = self   //两个样例使用不同的代理
//            controller.hidesNavigationBarDuringPresentation = false
//            controller.dimsBackgroundDuringPresentation = true
//            controller.searchBar.barStyle = .default
//            //            controller.view.backgroundColor = .white
//            controller.view.backgroundColor = self.view.backgroundColor
//            controller.searchBar.placeholder = "输入关键词进行搜索"
//            return controller
//        })()
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        
        
        imageview.setImageUrl(image: imageview, string: user?.icon, proimage: #imageLiteral(resourceName: "IMG_2507"))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 18
        view.addSubview(imageview)
        let item = UIBarButtonItem(customView: view)
        self.navigationItem.leftBarButtonItem = item
//        self.navigationItem.searchController = self.countrySearchController
//        self.navigationItem.hidesSearchBarWhenScrolling = true
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.collectionViewLayout = CollectionViewLeftFlowLayout()
        collectionview.register(UINib(nibName: DynamicCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: DynamicCollectionViewCell.reuseID)
        header.setRefreshingTarget(self, refreshingAction: #selector(refresh))
        collectionview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
        collectionview.mj_footer = footer
        pagebody.pageSize = 20
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
//        getpost(json: pagebody.toJSONString() ?? "")
    }
    
    @objc func showUser(){
        
    }
    @objc func refresh(){
        footer.resetNoMoreData()
        type = 1
        pagebody.page = 0
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getpost(json: pagebody.toJSONString() ?? "")
    }
    @objc func getMore(){
        if !hasmore {
            return
        }
        type = 2
        pagebody.page = (pagebody.page ?? 0) + 1
        pagebody.userId = UserInfoHelper.instance.user?.id ?? 0
        getpost(json: pagebody.toJSONString() ?? "")
        
    }
    func getpost(json:String){
        MyMoyaManager.AllRequest(controller: self, NetworkService.getposts(k:json )) { (data) in
            CoreDataManager.default.postlist = data.postlist
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
extension TabDynamicViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  CoreDataManager.default.postlist?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicCollectionViewCell.reuseID, for: indexPath) as! DynamicCollectionViewCell
        cell.updateCell(list:  CoreDataManager.default.postlist?[indexPath.item].postImages)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.getVcByName(vc: .我的帖子) as! BTMMyPostViewController
        vc.vcname = list?[indexPath.item].author?.nickName ?? ""
        vc.userid = list?[indexPath.item].author?.id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension TabDynamicViewController:UICollectionViewDelegateFlowLayout{
    //设置itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3.01, height: collectionView.bounds.width/3)
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
extension TabDynamicViewController:UIScrollViewDelegate{
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
extension TabDynamicViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
