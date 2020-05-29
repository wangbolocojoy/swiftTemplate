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
    
    
}
