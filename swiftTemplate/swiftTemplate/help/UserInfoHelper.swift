//
//  UserInfoHelper.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
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
            KeychainManager.User.UpdataByIdentifier(data: _setuser?.toJSONString() ?? "", forKey: .UserInfo)
        }
    }

    private init() {
        let str = KeychainManager.User.ReadDataByIdentifier(forKey: .UserInfo) as? String
        do {
            _setuser = try UserInfo(JSONString: str ?? "")
        } catch  {
            
        }
        
    }
  
}
