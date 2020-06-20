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
    var message:String?
    var status:Int?
    var msg:String?
    var userinfo:UserInfo?
    var novellist:[NovelInfo]?
    var imageurl:String?
    var fancefollowlist:[UserInfo]?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        msg <- map["msg"]
        status <- map["status"]
        userinfo <- map["data"]
        novellist <- map["data"]
        message <- map["message"]
        imageurl <- map["data"]
        fancefollowlist <- map["data"]
    }
    
}
class NovelInfo: Mappable {
    var id:Int?
    var novel_id:Int?
    var novel_name:String?
    var novel_easyinfo:String?
    var novel_author:String?
    var novel_img:String?
    var novel_type:Int?
    var novel_typename:String?
    var novel_uptime:String?
    var novel_state:String?
    init() {
        
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        id <- map["id"]
        novel_id <- map["novel_id"]
        novel_name <- map["novel_name"]
        novel_easyinfo <- map["novel_easyinfo"]
        novel_author <- map["novel_author"]
        novel_img <- map["novel_img"]
        novel_type <- map["novel_type"]
        novel_typename <- map["novel_typename"]
        novel_uptime <- map["novel_uptime"]
        novel_state <- map["novel_state"]
        
    }
    
}
class UserInfo: Mappable {
    var relaseName:String?
    var phone:String?
    var id:Int?
    var nickName:String?
    var account:String?
    var password:String?
    var icon:String?
    var likeStarts:Int?
    var fances:Int?
    var token:String?
    var easyInfo:String?
    var address:String?
    var userSex:Bool?
    var isFollow:Bool?
    var follows:Int?
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        relaseName <- map["relaseName"]
        phone <- map["phone"]
        id <- map["id"]
        nickName <- map["nickName"]
        account <- map["account"]
        password <- map["password"]
        icon <- map["icon"]
        likeStarts <- map["likeStarts"]
        fances <- map["fances"]
        token <- map["token"]
        easyInfo <- map["easyInfo"]
        address <- map["address"]
        userSex <- map["userSex"]
        isFollow <- map["isFollow"]
        follows <- map["follows"]
    }
    
}
