//
//  RequestBody.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import ObjectMapper
class RequestBody: Mappable {
    var id:Int?
    var icon:String?
    var password:String?
    var phone:String?
    var msg:String?
    var page:Int?
    var pagesize:Int?
    var type:Int?
    var nickname:String?
    var likestarts:Int?
    var fances:Int?
    var relasename:String?
    var seayinfo:String?
    var address:String?
    var userSex:Bool?
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        phone <- map["phone"]
        password <- map["password"]
        msg <- map["msg"]
        page <- map["page"]
        pagesize <- map["pagesize"]
        type <- map["type"]
        id <- map["id"]
        icon <- map["icon"]
        nickname <- map["nickname"]
        likestarts <- map["likestarts"]
        fances <- map["fances"]
        relasename <- map["relasename"]
        seayinfo <- map["seayinfo"]
        address <- map["address"]
        userSex <- map["userSex"]
        
    }
    
    
}
