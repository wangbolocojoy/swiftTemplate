//
//  BaseResponse.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import ObjectMapper
class BaseResponse: Mappable {
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
        userinfo <- map["data"]
    }
    var code:Int?
    var msg:String?
    var userinfo:UserInfo?
}
class UserInfo: Mappable {
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        token <- map["token"]
        phone <- map["phone"]
        id <- map["id"]
    }
    var token:String?
    var phone:String?
    var id:String?
}
