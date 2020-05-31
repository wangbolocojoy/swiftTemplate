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
    func getUser() -> UserInfo? {
        let str = KeychainManager.User.ReadDataByIdentifier(forKey: .UserInfo) as? String
        do {
            let user = try UserInfo(JSONString: str ?? "")
            return user
        } catch  {
            return nil
        }
    }
}
