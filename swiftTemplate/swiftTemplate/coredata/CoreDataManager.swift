//
//  CoreDataManager.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/29.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // 单例
    static let `default` = CoreDataManager()
    
    // 拿到AppDelegate中创建好了的NSManagedObjectContext
    lazy var context: NSManagedObjectContext = {
        let context = AppDelegate.init().getcontext()
        return context
    }()
    let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
   
 
    var _postlist:[PostInfo]?
    var postlist:[PostInfo]?{
        get {
            return _postlist
        }
        set{
            if newValue == nil || newValue?.count ?? 0 == 0 {
                return
            }
            saveandupdateNovel(list: newValue) {
                self.getCoreDataPost(success: { (polist) in
                    self._postlist = polist
                })
            }
        }
    }
    init() {
        getCoreDataPost(success: { (polist) in
            self._postlist = polist
        })
    }
    private func saveContext() {
       if context.hasChanges {
                   do {
                       try context.save()
                   } catch {
                       // Replace this implementation with code to handle the error appropriately.
                       // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                       let nserror = error as NSError
                        log.error("CoreData--Error----->>>  \(nserror.localizedFailureReason ?? "")")
                       fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                      
                       
                   }
               }
    }
    
    /// 缓存帖子
    /// - Parameters: 参数
    ///   - list: 帖子集合
    ///   - savesuccessCallback: 返回状态
    func saveandupdateNovel(list:[PostInfo]?,savesuccess savesuccessCallback: @escaping () -> Void){
        let fetchRequest: NSFetchRequest  = PostModelDO.fetchRequest()
         DispatchQueue.init(label: "CoreData.queue").async{
            log.verbose("数据库--->\(fetchRequest.fetchBatchSize) 条","新增-->\(list?.count ?? 0)条")
            var a = 0
            list?.forEach({ (item) in
                //String 才用%@
                //int类型用 %d
                a += 1
                log.verbose("循环帖子----\(a) 次")
                fetchRequest.predicate = NSPredicate(format: "id == %d ", item.id ?? 0)
                do {
                    
                    let result = try self.context.fetch(fetchRequest)
                    
                    if result.count == 0 {
                        
                        let postModel = NSEntityDescription.insertNewObject(forEntityName: "PostModelDO", into: self.context) as! PostModelDO
                        let authorModel = NSEntityDescription.insertNewObject(forEntityName: "AuthorDO", into: self.context) as! AuthorDO
                        authorModel.id = item.author?.id?.int32 ?? 0
                        authorModel.nickName = item.author?.nickName ?? ""
                        authorModel.icon = item.author?.icon ?? ""
                        authorModel.address = item.author?.address ?? ""
                        postModel.id = item.id?.int32 ?? 0
                        postModel.userId = item.userId?.int32 ?? 0
                        postModel.postDetail = item.postDetail ?? ""
                        postModel.postAddress = item.postAddress ?? ""
                        postModel.postPublic = item.postPublic ?? false
                        postModel.creatTime = item.creatTime ?? ""
                        postModel.author = authorModel
                        postModel.latitude = item.latitude ?? ""
                        postModel.postStarts = item.postStarts?.int32 ?? 0
                        postModel.longitude = item.longitude ?? ""
                        postModel.isStart = item.isStart ?? false
                        postModel.isCollection = item.isCollection ?? false
                        postModel.postMessageNum = item.postMessageNum?.int32 ?? 0
                        postModel.msgNum = item.msgNum?.int32 ?? 0
                        item.postImages?.forEach({ (PostImages) in
                            let postimageModel = NSEntityDescription.insertNewObject(forEntityName: "PostImagesDO", into: self.context) as! PostImagesDO
                            postimageModel.id = PostImages.id?.int32 ?? 0
                            postimageModel.fileUrl = PostImages.fileUrl ?? ""
                            postimageModel.fileType = PostImages.fileType ?? "image/jpeg"
                            postimageModel.userId = PostImages.userId?.int32 ?? 0
                            postModel.addToPostImages(postimageModel)
                            
                        })
                        log.verbose("新增帖子")
                        self.saveContext()
                    }else{
                        result.forEach { (postModel) in
                            log.verbose("更新--->   \(postModel.postDetail ?? "")")
                            postModel.isStart = item.isStart ?? false
                            postModel.isCollection = item.isCollection ?? false
                            postModel.postMessageNum = item.postMessageNum?.int32 ?? 0
                            postModel.msgNum = item.msgNum?.int32 ?? 0
                            postModel.postStarts = item.postStarts?.int32 ?? 0
                            self.saveContext()
                        }
                    }
                } catch  {
                    log.error(error.localizedDescription)
                    fatalError()
                }
                
                
                
            })
            DispatchQueue.main.async {
                savesuccessCallback()
            }
        }
    }
    
    
    func deletePost(id:Int,successCallback:  @escaping () -> Void){
        let fetchRequest: NSFetchRequest  = PostModelDO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d ",id)
          DispatchQueue.init(label: "CoreData.queue").async{
            do {
                let result = try self.context.fetch(fetchRequest)
                if result.count != 0 {
                    result.forEach { (PostModelDO) in
                        self.context.delete(PostModelDO)
                    }
                }
            } catch {
                log.error(error.localizedDescription)
                fatalError(error.localizedDescription)
            }
            
        }
    }
    /// 获取缓存的帖子
    /// - Parameter successCallback: 返回缓存的帖子集合
    func getCoreDataPost(success successCallback:  @escaping ( [PostInfo]?) -> Void){
        let fetchRequest: NSFetchRequest  = PostModelDO.fetchRequest()
        DispatchQueue.init(label: "CoreData.queue") .async{
            do {
                var list :[PostInfo]? = []
                let result = try self.context.fetch(fetchRequest)
                log.verbose("开始获取缓存--->  \(result.count) 条")
                result.forEach { (item) in
                    let postModel = PostInfo()
                    let authorModel = PostAuthor()
                    var images :[PostImages]? = []
                    item.postImages?.forEach({ (obj) in
                        let imgdo = obj as! PostImagesDO
                        let img = PostImages()
                        img.fileType = imgdo.fileType
                        img.fileUrl = imgdo.fileUrl
                        img.id = imgdo.id.int32
                        images?.append(img)
                    })
                    authorModel.id = item.author?.id.int32 ?? 0
                    authorModel.nickName = item.author?.nickName ?? ""
                    authorModel.icon = item.author?.icon ?? ""
                    authorModel.address = item.author?.address ?? ""
                    postModel.id = item.id.int32
                    postModel.userId = item.userId.int32
                    postModel.postDetail = item.postDetail ?? ""
                    postModel.postAddress = item.postAddress ?? ""
                    postModel.postPublic = item.postPublic
                    postModel.creatTime = item.creatTime ?? ""
                    postModel.postStarts = item.postStarts.int32
                    postModel.author = authorModel
                    postModel.latitude = item.latitude ?? ""
                    postModel.longitude = item.longitude ?? ""
                    postModel.isStart = item.isStart
                    postModel.isCollection = item.isCollection
                    postModel.postMessageNum = item.postMessageNum.int32
                    postModel.msgNum = item.msgNum.int32
                    postModel.postImages = images
                    list?.append(postModel)
                }
                list?.sort(by: { (po1
                    , po2) -> Bool in
                    let bo = (po1.id ?? 0 > po2.id ?? 0)
                    return bo
                })
                if list?.count ?? 0 == 0 {
                    UserDefaults.User.set(value: 0 , forKey: .MAXPostId)
                    
                }else{
                    UserDefaults.User.set(value: list?[0].id ?? 0 , forKey: .MAXPostId)
                    log.verbose("获取\(list?.count ?? 0) 条。  最新的帖子id\( list?[0].id ?? 0)")
                }
                DispatchQueue.main.async {
                    successCallback(list)
                }
            } catch  {
                log.error("获取缓存出错--->  \(error.localizedDescription)")
                fatalError()
            }
            //
        }
    }
    
    
    // 删除所有数据
    /// 删除所有数据
    /// - Parameter successCallback: 返回删除缓存帖子状态
    func deleteAllPost(success successCallback: @escaping () -> Void) {
        // 这里直接调用上面获取所有数据的方法
        let fetchRequest: NSFetchRequest  = PostModelDO.fetchRequest()
         DispatchQueue.init(label: "CoreData.queue").async {
            do {
                let result = try self.context.fetch(fetchRequest)
                result.forEach { (PostModelDO) in
                    self.context.delete(PostModelDO)
                }
                self.saveContext()
            } catch  {
                log.error("删除缓存出错\(error.localizedDescription)")
                fatalError()
            }
            // 循环删除所有数据
            
            DispatchQueue.main.async {
                log.verbose("删除完成 --->  \(fetchRequest.fetchBatchSize)条")
                successCallback()
            }
            
        }
    }
}
