//
//  CoreDataManager.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/29.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // 单例
    static let shared = CoreDataManager()
    
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
    // 注册
    func registerUser(body:User) {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user.phone = body.phone
        user.password = body.password
        saveContext()
    }
    
    // 获取所有用户
    func getAllUser() -> [User] {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    
    // 查询手机号是否存在
    func getUserbyphone(phone: String) -> [User] {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "phone == %@", phone)
        do {
            let result: [User] = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    // 修改用户信息
    func changeUserinfo(body:User) {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "phone == %@", body.phone ?? "")
        do {
            // 拿到符合条件的所有数据
            let result = try context.fetch(fetchRequest)
            for person in result {
                // 循环修改
                person.name = body.name
                person.age = body.age
                person.address = body.address
                person.bridthday = body.bridthday
                person.latitude = body.latitude
                person.autograph = body.autograph
                person.longitude = body.longitude
                person.gender = body.gender
                person.nation = body.nation
                person.openid = body.openid
                person.qq = body.qq
                person.token = body.token
                person.usericon = body.usericon
            }
        } catch {
            fatalError();
        }
        saveContext()
    }
    // 根据手机号删除用户
    func deleteWith(name: String) {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for person in result {
                context.delete(person)
            }
        } catch {
            fatalError();
        }
        saveContext()
    }
    
    // 删除所有数据
    func deleteAllPerson() {
        // 这里直接调用上面获取所有数据的方法
        let result = getAllUser()
        // 循环删除所有数据
        for person in result {
            context.delete(person)
        }
        saveContext()
    }
}
