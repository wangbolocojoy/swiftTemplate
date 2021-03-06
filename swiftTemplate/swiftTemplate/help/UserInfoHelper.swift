//
//  UserInfoHelper.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
class UserInfoHelper {
    static let instance = UserInfoHelper()
    var _setuser:UserInfo?
    var user:UserInfo? {
        get{
            return _setuser
        }
        set{
            _setuser = newValue
           let _ = KeychainManager.User.UpdataByIdentifier(data: _setuser?.toJSONString() ?? "", forKey: .UserInfo)
        }
    }

    private init() {
        let str = KeychainManager.User.ReadDataByIdentifier(forKey: .UserInfo) as? String
            _setuser =  UserInfo(JSONString: str ?? "")
       
        
    }
    
    
  
}
class IDCardHelper {
    static let `default` = IDCardHelper()
    var _IDCardDTO:UserIdCard?
    var IDCardDTO:UserIdCard? {
           get{
               return _IDCardDTO
           }
           set{
               _IDCardDTO = newValue
              let _ = KeychainManager.User.UpdataByIdentifier(data: _IDCardDTO?.toJSONString() ?? "", forKey: .IDCARD)
           }
       }
    private init() {
           let str = KeychainManager.User.ReadDataByIdentifier(forKey: .IDCARD) as? String
               _IDCardDTO =  UserIdCard(JSONString: str ?? "")
       }
}
