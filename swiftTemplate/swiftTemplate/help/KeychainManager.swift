//
//  KeychainManager.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
class KeychainManager: NSObject {
    // TODO  创建查询条件
       class func crtateQuarMutableDictionary(indetifier: String) ->NSMutableDictionary{
           // 创建一个条件字典
           let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
           // 设置条件存储的类型
           keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
           // 设置存储数据的标记
           keychainQuaryMutableDictionary.setValue(indetifier, forKey: kSecAttrService as String)
           // 设置数据访问属性
           keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
           // 返回创建条件字典
           return keychainQuaryMutableDictionary
           
       }
       
       
       
       // TODO: 存储数据
       class func keyChainSaveData(data:Any ,withIdentifier identifier:String)->Bool {
           // 获取存储数据的条件
           let keyChainSaveMutableDictionary = self.crtateQuarMutableDictionary(indetifier: identifier)
           // 删除旧的存储数据
           SecItemDelete(keyChainSaveMutableDictionary)
           // 设置数据
           keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
           // 进行存储数据
           let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
           if saveState == noErr  {
               return true
           }
           return false
       }
       
       // TODO: 更新数据
       class func keyChainUpdata(data:Any ,withIdentifier identifier:String)->Bool {
           // 获取更新的条件
           let keyChainUpdataMutableDictionary = self.crtateQuarMutableDictionary(indetifier: identifier)
           // 创建数据存储字典
           let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
           // 设置数据
           updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
           // 更新数据
           let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
           if updataStatus == noErr {
               return true
           }
           return false
       }
       
       
       // TODO: 获取数据
       class func keyChainReadData(identifier:String)-> Any {
           var idObject:Any?
           // 获取查询条件
           let keyChainReadmutableDictionary = self.crtateQuarMutableDictionary(indetifier: identifier)
           // 提供查询数据的两个必要参数
           keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
           keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
           // 创建获取数据的引用
           var queryResult: AnyObject?
           // 通过查询是否存储在数据
           let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
           if readStatus == errSecSuccess {
               if let data = queryResult as! NSData? {
                   idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
               }
           }
           return idObject as Any
       }
       
       
       
       // TODO: 删除数据
       class func keyChianDelete(identifier:String)->Void{
           // 获取删除的条件
           let keyChainDeleteMutableDictionary = self.crtateQuarMutableDictionary(indetifier: identifier)
           // 删除数据
           SecItemDelete(keyChainDeleteMutableDictionary)
       }
}
extension UserDefaults{
    struct User: UserDefaultsSettable {
        enum defaultKeys:String,CaseIterable{
            case 手机号
            case 密码
            case 公钥
            case 私钥
            case token
            case userid
        }
    }
}
extension KeychainManager{
    struct User: KeychainManagerSettable {
           enum defaultKeys:String,CaseIterable{
               case 手机号
               case 密码
               case 公钥
               case 私钥
               case token
               case userid
           }
       }
}

protocol KeychainManagerSettable {
    associatedtype defaultKeys:RawRepresentable
}

extension KeychainManagerSettable where defaultKeys.RawValue == String{
    // TODO: 存储数据
    static func SaveByIdentifier(data:Any ,forKey key :defaultKeys)->Bool {
           let akey = key.rawValue
        // 获取存储数据的条件
        return KeychainManager.keyChainSaveData(data: data, withIdentifier: akey)
    }
    // TODO: 更新数据
    static func UpdataByIdentifier(data:Any ,forKey key :defaultKeys)->Bool {
           let akey = key.rawValue
        return KeychainManager.keyChainUpdata(data: data, withIdentifier: akey)
    }
    
    // TODO: 获取数据
    static func ReadDataByIdentifier(forKey key :defaultKeys)-> Any {
      let akey = key.rawValue
      return KeychainManager.keyChainReadData(identifier: akey)
    }
    // TODO: 删除数据
    static func DeleteByIdentifier(forKey key :defaultKeys)->Void{
         let akey = key.rawValue
        KeychainManager.keyChianDelete(identifier: akey)
    }
    
}


protocol UserDefaultsSettable {
    associatedtype defaultKeys:RawRepresentable
}
extension UserDefaultsSettable where defaultKeys.RawValue == String{
    static func set(value:Any,forKey key :defaultKeys){
        let akey = key.rawValue
        UserDefaults.standard.set(value, forKey: akey)
        
    }
    static func getvalue(forKey key :defaultKeys) -> Any{
        let akey = key.rawValue
        return UserDefaults.standard.value(forKey: akey) as Any
        
    }
   static func clearAllUserDefaultsData(){
        let userDefaults = UserDefaults.standard
    let dics = userDefaults.dictionaryRepresentation()
    for key in dics {
        userDefaults.removeObject(forKey: key.key)
        }
    userDefaults.synchronize()
    }
}
