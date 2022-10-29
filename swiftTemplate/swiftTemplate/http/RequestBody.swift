//
//  RequestBody.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import ObjectMapper
class RequestBody: Mappable {
    var id:Int?
    var postId:Int?
    var backId: Int?
    var postMsgId:Int?
    var userId:Int?
    var followId:Int?
    var postPublic:Bool?
    var msgId:Int?
    var icon:String?
    var feedMsg:String?
    var password:String?
    var phone:String?
    var msgcode:String?
    var page:Int?
    var pageSize:Int?
    var postState:Int?
    var type:Int?
    var nickName:String?
    var likeStarts:Int?
    var fances:Int?
    var realName:String?
    var easyInfo:String?
    var address:String?
    var userSex:Bool?
    var postTitle:String?
    var postDetail:String?
    var postAddress:String?
    var postMessage:String?
    var birthDay:String?
    var constellation:String?
    var replyNickName:String?
    var replyUserId:Int?
    var province:String?
    var city:String?
    var msgType:Int?
    var postimagelist:[PostImageBody]?
    var longitude:String?
    var latitude:String?
    init() {
        
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        postId <- map["postId"]
        msgId <- map["msgId"]
        backId <- map["backId"]
        feedMsg <- map["feedMsg"]
        postMsgId <- map["postMsgId"]
        phone <- map["phone"]
        password <- map["password"]
        msgcode <- map["msgcode"]
        page <- map["page"]
        pageSize <- map["pageSize"]
        postState <- map["postState"]
        type <- map["type"]
        id <- map["id"]
        icon <- map["icon"]
        nickName <- map["nickName"]
        likeStarts <- map["likeStarts"]
        fances <- map["fances"]
        realName <- map["realName"]
        easyInfo <- map["easyInfo"]
        address <- map["address"]
        userSex <- map["userSex"]
        userId <- map["userId"]
        followId <- map["followId"]
        postTitle <- map["postTitle"]
        postDetail <- map["postDetail"]
        postAddress <- map["postAddress"]
        postMessage <- map["postMessage"]
        birthDay <- map["birthDay"]
        constellation <- map["constellation"]
        replyNickName <- map["replyNickName"]
        replyUserId <- map["replyUserId"]
        province <- map["province"]
        city <- map["city"]
        msgType <- map["msgType"]
        postimagelist <- map["postimagelist"]
        longitude <- map["longitude"]
        latitude <- map["latitude"]
    }
    
    
}
class PostImageBody: Mappable {
    var userId: Int?
    var postId:Int?
    var fileType: String?
    var originalFileName: String?
    var fileUrl:String?
    var fileLikes:Int?
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        userId <- map["userId"]
        postId <- map["postId"]
        fileType <- map["fileType"]
        originalFileName <- map["originalFileName"]
        fileUrl <- map["fileUrl"]
        fileLikes <- map["fileLikes"]
        
    }
    
    
}
class QrCodeBody: Mappable{
    var phone:String?
    var id:Int?
    var nickName:String?
    var account:String?
    var icon:String?
    var postNum:Int?
    var likeStarts:Int?
    var fances:Int?
    var easyInfo:String?
    var address:String?
    var userSex:Bool?
    var birthDay:String?
    var creatTime:Date?
    var province:String?
    var city:String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        phone <- map["phone"]
        id <- map["id"]
        nickName <- map["nickName"]
        account <- map["account"]
        icon <- map["icon"]
        likeStarts <- map["likeStarts"]
        fances <- map["fances"]
        easyInfo <- map["easyInfo"]
        address <- map["address"]
        userSex <- map["userSex"]
        postNum <- map["postNum"]
        birthDay <- map["birthDay"]
        creatTime <- map["creatTime"]
        province <- map["province"]
        city <- map["city"]
    }
    
    
}
class updatePos: Mappable{
    var userId:Int?
    var postList:[pstInfo]?
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        userId <- map["userId"]
        postList <- map["postList"]
    }
    
}
class pstInfo: Mappable{
    var postId: Int?
    var postState: Int?
    var postPublic:Bool?
    init() {
        
    }
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        postId <- map["postId"]
        postPublic <- map["postPublic"]
        postState <- map["postState"]
        
    }
    
}
