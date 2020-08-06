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
    var postmsgs:[PostMessage]?
    var postmsg:PostMessage?
    var mypictures:[PostImages]?
    var developer:DeveloperInfo?
    var feekbacklist:[FeekBackInfo]?
    var ret:Int?
    var txdata:TxData?
    var useridcard:UserIdCard?
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
        postmsgs <- map["data"]
        postmsg <- map["data"]
        mypictures <- map["data"]
        developer <- map["data"]
        feekbacklist <- map["data"]
        ret <- map["ret"]
        txdata <- map["data"]
        useridcard <- map["data"]
    }
    
}

class UserIdCard: Mappable {
    var id: Int?
    var userId: Int?
    var name:String?  //姓名（人像面）
    var sex:String?  //性别（人像面）
    var nation:String? //    民族（人像面）
    var birth:String?  //出生日期（人像面）
    var address:String?  //地址（人像面）
    var idNum:String? //身份证号（人像面）
    var authority:String?  //发证机关（国徽面）
    var startDate:String?  //证件有效期（国徽面）
    var endDate:String?  //证件有效期（国徽面）
    var frontIdCard:String? //身份证正面
    var nationalIdCard:String? //身份证反面
    var authentication :Bool?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        name <- map["name"]
        sex <- map["sex"]
        nation <- map["nation"]
        birth <- map["birth"]
        address <- map["address"]
        idNum <- map["idNum"]
        authority <- map["authority"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        frontIdCard <- map["frontIdCard"]
        nationalIdCard <- map["nationalIdCard"]
        authentication <- map["authentication"]
        
    }
    
    
}
class TxData: Mappable {
    var tag_list :[TxTagInfo]?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        tag_list <- map["tag_list"]
    }
    
    
}
class TxTagInfo: Mappable {
    var tag_confidence :Int?
    var tag_confidence_f:Float?
    var tag_name:String?
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        tag_confidence <- map["tag_confidence"]
        tag_confidence_f <- map["tag_confidence_f"]
        tag_name <- map["tag_name"]
    }
    
    
}

class FeekBackInfo: Mappable {
    var id:Int?
    var userId:Int?
    var userMsg:String?
    var backTime:String?
    var userNickName:String?
    var userIcon:String?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        userId <- map["userId"]
        userMsg <- map["userMsg"]
        backTime <- map["backTime"]
        userNickName <- map["userNickName"]
        userIcon <- map["userIcon"]
    }
    
    
}
class DeveloperInfo:Mappable{
    var id: Int?
    var developerName: String?
    var developerQQ_: String?
    var developerWechat_: String?
    var developerEmail_: String?
    var developerIcon_: String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        developerName <- map["developerName"]
        developerQQ_ <- map["developerQQ_"]
        developerWechat_ <- map["developerWechat_"]
        developerEmail_ <- map["developerEmail_"]
        developerIcon_ <- map["developerIcon_"]
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
    var replyUserId:Int?
    var replyNickName:String?
    var isStart:Bool?
    required init?(map: Map) {
        
    }
    init() {
        
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
        replyUserId <- map["replyUserId"]
        replyNickName <- map["replyNickName"]
        isStart <- map["isStart"]
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
    var postPublic:Bool?
    var postStarts:Int?
    var author:PostAuthor?
    var postImages:[PostImages]?
    var postMessageNum:Int?
    var creatTime:String?
    var latitude:String?
    var longitude:String?
    var isStart:Bool?
    var isCollection:Bool?
    var msgNum:Int?
    var postState:Int?
    var postReport:Int?
    var postisselectid:Bool?
    required init?(map: Map) {
        
    }
    init() {
        
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
        postMessageNum <- map["postMessageNum"]
        creatTime <- map["creatTime"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        isStart <- map["isStart"]
        isCollection <- map["isCollection"]
        msgNum <- map["msgNum"]
        postState <- map["postState"]
        postReport <- map["postReport"]
        postisselectid <- map ["postisselectid"]
    }
    
    
}
class PostAuthor: Mappable {
    var id:Int?
    var nickName:String?
    var icon:String?
    var address:String?
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        nickName <- map["nickName"]
        icon <- map["icon"]
        address <- map["address"]
    }
    
    
}
class PostImages: Mappable {
    var id:Int?
    var userId:Int?
    var fileUrl:String?
    var fileType:String?
    
    required init?(map: Map) {
        
    }
    init() {
        
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
    var birthDay:String?
    var constellation:String?
    var creatTime:Date?
    var province:String?
    var city:String?
    var isbanned:Bool?
    var administrators:Bool?
    var authentication:Bool?
    var isselectid:Bool?
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
        birthDay <- map["birthDay"]
        constellation <- map["constellation"]
        creatTime <- map["creatTime"]
        province <- map["province"]
        city <- map["city"]
        isbanned <- map["isbanned"]
        administrators <- map["administrators"]
        authentication <- map["authentication"]
        isselectid <- map["isselectid"]
    }
    
}
