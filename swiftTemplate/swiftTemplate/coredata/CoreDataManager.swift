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
    // 增加数据
       func savePersonWith(name: String, age: Int16) {
           let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
           user.name = name
           user.age = age
           saveContext()
       }
    
        // 获取所有数据
        func getAllUser() -> [User] {
            let fetchRequest: NSFetchRequest = User.fetchRequest()
            do {
                let result = try context.fetch(fetchRequest)
                return result
            } catch {
                fatalError();
            }
        }
    
    // 根据姓名获取数据
    func getUserWith(name: String) -> [User] {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result: [User] = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    // 根据姓名修改数据
    func changeUserWith(name: String, newName: String, newAge: Int16) {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            // 拿到符合条件的所有数据
            let result = try context.fetch(fetchRequest)
            for person in result {
                // 循环修改
                person.name = newName
                person.age = newAge
            }
        } catch {
            fatalError();
        }
        saveContext()
    }
    // 根据姓名删除数据
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
