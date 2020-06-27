//
//  BaseResponse.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
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
    var sendpost:PostInfo?
    var fancefollowlist:[UserInfo]?
    var postlist:[PostInfo]?
    var poststartlist:[PostStart]?
    var userlist :[UserInfo]?
    var postmsg:[PostMessage]?
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
        postlist <- map["data"]
        sendpost <- map["data"]
        poststartlist <- map["data"]
        userlist <- map["data"]
        postmsg <- map["data"]
    }
    
}
class PostMessage: Mappable {
    var id: Int?
    var userId: Int?
    var postId:Int?
    var userIcon:String?
    var userNickName:String?
    var chiledMessage:[PostMessage]?
    var message: String?
    var messageStart:Int?
    var postMsgCreatTime: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        postId <- map["postId"]
        userIcon <- map["userIcon"]
        userNickName <- map["userNickName"]
        chiledMessage <- map["chiledMessage"]
        message <- map["message"]
        messageStart <- map["messageStart"]
        postMsgCreatTime <- map["postMsgCreatTime"]
    }
    
    
}
class PostStart: Mappable {
    var postId:Int?
    var userId:Int?
    var id:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        postId <- map["postId"]
        userId <- map["userId"]
    }
    
    
}
class PostInfo: Mappable {
    var id:Int?
    var userId:Int?
    var postTitle:String?
    var postDetail:String?
    var postAddress:String?
    var postPublic:String?
    var postStarts:Int?
    var author:PostAuthor?
    var postImages:[PostImages]?
    var latitude:String?
    var longitude:String?
    var isStart:Bool?
    var isCollection:Bool?
    var msgNum:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        postTitle <- map["postTitle"]
        postDetail <- map["postDetail"]
        postAddress <- map["postAddress"]
        postPublic <- map["postPublic"]
        postStarts <- map["postStarts"]
        author <- map["author"]
        postImages <- map["postImages"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        isStart <- map["isStart"]
        isCollection <- map["isCollection"]
        msgNum <- map["msgNum"]
    }
    
    
}
class PostAuthor: Mappable {
    var id:Int?
    var nickName:String?
    var icon:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nickName <- map["nickName"]
        icon <- map["icon"]
    }
    
    
}
class PostImages: Mappable {
    var id:Int?
    var userId:Int?
    var fileUrl:String?
    var fileType:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        fileUrl <- map["fileUrl"]
        fileType <- map["fileType"]
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
    var realName:String?
    var phone:String?
    var id:Int?
    var nickName:String?
    var account:String?
    var password:String?
    var icon:String?
    var postNum:Int?
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
        realName <- map["realName"]
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
        postNum <- map["postNum"]
    }
    
}
