//
//  AppDelegate.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/29.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit
import CoreData
import SwiftyBeaver
var log = SwiftyBeaver.self
import IQKeyboardManagerSwift
import AVKit
import Photos
import AuthenticationServices
import Bugly
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initConfigure()
        choosePermiss()
        return true
    }
    /// 初始化配置
    private func initConfigure(){
        let config = BuglyConfig()
        config.unexpectedTerminatingDetectionEnable = true
        config.delegate = self
        Bugly.start(withAppId: "718e25e42a", developmentDevice: true, config: config)
        AMapServices.shared().apiKey = ApiKey.default.AMapkey
        IQKeyboardManager.shared.enable = true
        if #available(iOS 13.0, *) {
            let backgroundColor = UIColor { (traitCollection) -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .light:
                    return Constant.BackGround
                case .dark:
                    return Constant.DarkBackGround
                default:
                    fatalError()
                }
            }
            window?.backgroundColor = backgroundColor
        } else {
            window?.backgroundColor = Constant.BackGround
        }
        
        let  file = FileDestination()
        file.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        file.levelString.debug   = "DEBUG "
        file.levelString.error   = "ERROR "
        file.levelString.info    = "INFO  "
        file.levelString.warning = "WARING"
        file.levelString.verbose = "verbose"
        file.levelColor.debug    = "😬😬  "
        file.levelColor.error    = "🍄🍄  "
        file.levelColor.info     = "♻️♻️  "
        file.levelColor.warning   = "⚠️⚠️  "
        file.levelColor.verbose   = "🍀🍀  "
        file.minLevel = .warning
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        console.levelString.debug   = "DEBUG "
        console.levelString.error   = "ERROR "
        console.levelString.info    = "INFO  "
        console.levelString.warning = "WARING"
        console.levelString.verbose = "verbose"
        console.levelColor.debug    = "😬😬  "
        console.levelColor.error    = "🍄🍄  "
        console.levelColor.info     = "♻️♻️  "
        console.levelColor.warning   = "⚠️⚠️  "
        console.levelColor.verbose   = "🍀🍀  "
        if ApiKey.default.版本环境 == "测试版本" {
            log.addDestination(file)
            log.addDestination(console)
        }else{
            log.addDestination(file)
        }
        log.verbose(ApiKey.default.版本环境)
        log.verbose(CoreDataManager.default.postlist?.count ?? 0)
        NotificationCenter.default.addObserver(self, selector: #selector(slentener), name: NSNotification.Name(rawValue: "POSTSUCESS"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(flentener), name: NSNotification.Name(rawValue: "POSTFAIL"), object: nil)
        
    }
    @objc func slentener(){
        UIApplication.shared.keyWindow?.rootViewController?.ShowTip(Title: "发送成功")
    }
    @objc func flentener(){
           UIApplication.shared.keyWindow?.rootViewController?.ShowTip(Title: "发送失败")
       }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /// 获取权限
    func choosePermiss(){
        if (AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    //用户首次允许
                    debugPrint("允许APP访问相机")
                } else {
                    //用户首次拒接
                    debugPrint("拒绝APP访问相机")
                }
            })
        }
        //MARK: APP启动时候，判断用户是否授权使用相册
        if (PHPhotoLibrary.authorizationStatus() == .notDetermined) {
            PHPhotoLibrary.requestAuthorization({ (firstStatus) in
                let result = (firstStatus == .authorized)
                if result {
                    
                    debugPrint("允许APP访问相册")
                } else {
                    debugPrint("拒绝APP访问相册")
                }
            })
        }
        
    }
    // MARK: - Core Data stack
    
   
    @available(iOS 13.0, *)
    func getpersistentContainer()->NSPersistentCloudKitContainer{
       
        let persistentContainer: NSPersistentCloudKitContainer = {
                /*
                 The persistent container for the application. This implementation
                 creates and returns a container, having loaded the store for the
                 application to it. This property is optional since there are legitimate
                 error conditions that could cause the creation of the store to fail.
                 */
                let container = NSPersistentCloudKitContainer(name: "swiftTemplate")
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        
                        /*
                         Typical reasons for an error here include:
                         * The parent directory does not exist, cannot be created, or disallows writing.
                         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                         * The device is out of space.
                         * The store could not be migrated to the current model version.
                         Check the error message to determine what the actual problem was.
                         */
                          log.error("Unresolved error \(error), \(error.userInfo)")
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
                return container
            }()
       
        return persistentContainer
    }
   
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "swiftTemplate")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                 log.error("Unresolved error \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
               
            }
        })
        
        return container
    }()
    // MARK: - Core Data Saving support
    
    func getcontext() -> NSManagedObjectContext{
        var  context : NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
               if #available(iOS 13.0, *) {
                context = getpersistentContainer().newBackgroundContext()
               } else {
                   context = persistentContainer.viewContext
               }
        return context
    }
    func saveContext () {
      if getcontext().hasChanges {
            do {
                try getcontext() .save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                 log.error("CoreData--Error----->>>  \(nserror.localizedFailureReason ?? "")")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate:BuglyDelegate{
    func attachment(for exception: NSException?) -> String? {
         log.error("App---崩溃原因----->>>  \(exception?.reason ?? "")")
        return exception?.reason
    }
    
}
extension NSManagedObjectContext {
    func update() throws {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self

        context.perform({
            do {
                try context.save()
            } catch {
                print(error)
            }
        })
    }
}
