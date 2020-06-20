//
//  SendPostViewController.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 波王. All rights reserved.
//
// MARK: - 发帖
import UIKit

class SendPostViewController: BaseViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var lab_address: UILabel!
    @IBOutlet weak var btn_address: UIView!
    @IBOutlet weak var ev_detail: UITextView!
    
    var list:[UIImage] = [#imageLiteral(resourceName: "IMG_2507")]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func initView() {
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: UploadImageCollectionViewCell.reuseID, bundle: nil), forCellWithReuseIdentifier: UploadImageCollectionViewCell.reuseID)
        collectionview.collectionViewLayout = CollectionViewLeftFlowLayout()
    }
    
}

extension SendPostViewController:UICollectionViewDelegateFlowLayout{
    //设置itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3.1, height: collectionView.bounds.width/3.1)
    }
    //设置section内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
    }
    //设置minimumLineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //设置minimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
extension SendPostViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadImageCollectionViewCell.reuseID, for: indexPath) as! UploadImageCollectionViewCell
        return cell
    }
    
    
}
