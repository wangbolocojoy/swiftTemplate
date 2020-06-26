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
        let context = AppDelegate.init().persistentContainer.viewContext
        return context
    }()
    // 更新数据
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    //    // 查询手机号是否存在
    //    func getUserbyphone(phone: String) -> [UserDO] {
    //        let fetchRequest: NSFetchRequest = UserDO.fetchRequest()
    //        fetchRequest.predicate = NSPredicate(format: "phone == %@", phone)
    //        do {
    //            let result: [UserDO] = try context.fetch(fetchRequest)
    //            return result
    //        } catch {
    //            fatalError();
    //        }
    //    }
    func saveStart(id:Int){
        let fetchRequest: NSFetchRequest = PostStartDO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId ==  %d", id)
        do {
            let result: [PostStartDO] = try context.fetch(fetchRequest)
            if result.count == 0{
                let p = NSEntityDescription.insertNewObject(forEntityName: "PostStartDO", into: context) as! PostStartDO
                p.postId = Int32(id)
                saveContext()
            }
        } catch {
            fatalError();
        }
    }
    func unStart(id:Int){
        let fetchRequest: NSFetchRequest = PostStartDO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId ==  %d", id)
        do {
            let result: [PostStartDO] = try context.fetch(fetchRequest)
            if result.count != 0{
                for value in result {
                    context.delete(value)
                }
            }
        } catch {
            fatalError();
        }
        saveContext()
    }
    func updateStartList(list:[PostStart],success successCallback: @escaping () -> Void){
        DispatchQueue.global().async {
                list.forEach { (pstr) in
                    let p = NSEntityDescription.insertNewObject(forEntityName: "PostStartDO", into: self.context) as! PostStartDO
                    p.postId = Int32(pstr.postId ?? 0)
                    self.saveContext()
                }
            DispatchQueue.main.async {
                successCallback()
            }
        }
    }
    func deleteStartList(success successCallback: @escaping () -> Void){
        DispatchQueue.global().async {
            let fetchRequest: NSFetchRequest = PostStartDO.fetchRequest()
            do {
                let result: [PostStartDO] = try self.context.fetch(fetchRequest)
                result.forEach { (p) in
                    self.context.delete(p)
                }
                self.saveContext()
                
            } catch  {
                fatalError()
            }
            DispatchQueue.main.async {
                successCallback()
            }
        }
    }
    func getStartList()->[Int]{
        let fetchRequest: NSFetchRequest = PostStartDO.fetchRequest()
        var list:[Int] = []
        do {
            let result: [PostStartDO] = try context.fetch(fetchRequest)
            result.forEach { (p) in
                list.append(Int(p.postId))
            }
        } catch  {
            fatalError()
        }
        return list
    }
    
    // 注册
    //    func saveandupdateNovel(item:NovelInfo?){
    //
    ////        let fetchRequest: NSFetchRequest = NovelModelDO.fetchRequest()
    //                    //String 才用%@
    //                    //int类型用 %d
    //        fetchRequest.predicate = NSPredicate(format: "novel_id ==  %d", item?.novel_id ?? 0)
    //        //数据库没有这条数据。新增
    //        if fetchRequest.fetchLimit == 0 || fetchRequest.fetchBatchSize == 0 {
    //            let novel = NSEntityDescription.insertNewObject(forEntityName: "NovelModelDO", into: context) as! NovelModelDO
    //            novel.id = Int16(item?.id ?? 0)
    //            novel.novel_id = Int64(item?.novel_id ?? 0)
    //            novel.novel_name = item?.novel_name ?? ""
    //            novel.novel_easyinfo = item?.novel_easyinfo ?? ""
    //            novel.novel_author = item?.novel_author ?? ""
    //            novel.novel_img = item?.novel_img ?? ""
    //            novel.novel_type = Int16(item?.novel_type ?? 0)
    //            novel.novel_typename = item?.novel_typename
    //            novel.novel_uptime = item?.novel_uptime ?? ""
    //            novel.novel_state = item?.novel_state ?? ""
    //            saveContext()
    //        }else{
    //            do {
    //                // 拿到符合条件的所有数据 修改
    //                let result = try context.fetch(fetchRequest)
    //                if  result.count >= 1 {
    //                    for novel in result {
    //                        novel.id = Int16(item?.id ?? 0)
    //                        novel.novel_id = Int64(item?.novel_id ?? 0)
    //                        novel.novel_name = item?.novel_name ?? ""
    //                        novel.novel_easyinfo = item?.novel_easyinfo ?? ""
    //                        novel.novel_author = item?.novel_author ?? ""
    //                        novel.novel_img = item?.novel_img ?? ""
    //                        novel.novel_type = Int16(item?.novel_type ?? 0)
    //                        novel.novel_typename = item?.novel_typename
    //                        novel.novel_uptime = item?.novel_uptime ?? ""
    //                        novel.novel_state = item?.novel_state ?? ""
    //                    }
    //
    //                }
    //
    //            } catch {
    //                fatalError();
    //            }
    //            saveContext()
    //        }
    //
    //
    //    }
    
    //    // 获取所有用户
    //    func getAllUser() -> [UserDO] {
    //        let fetchRequest: NSFetchRequest = UserDO.fetchRequest()
    //        do {
    //            let result = try context.fetch(fetchRequest)
    //            return result
    //        } catch {
    //            fatalError();
    //        }
    //    }
    
    //
    
    // 删除所有数据
    //    func deleteAllNovel(success successCallback: @escaping () -> Void) {
    //        // 这里直接调用上面获取所有数据的方法
    //        let result = getAlldeleteNovel()
    //        // 循环删除所有数据
    //        DispatchQueue.global().async {
    //            for (_,d) in result.enumerated()  {
    //                self.context.delete(d)
    //            }
    //            self.saveContext()
    //            DispatchQueue.main.async {
    //                  successCallback()
    //            }
    //
    //        }
    //
    //
    //    }
}
