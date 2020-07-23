//
//  NetworkService.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import Moya
import CommonCrypto
public enum NetworkService{
    //登录
    case login(k:String)
    //注册
    case register(k:String)
    //验证码
    case getmsg(k:String)
    //重置密码
    case respsd(k:String)
    //我的首页
    case tabhome(K:String)
    //搜索小说
    case searchnovel(k:String)
    //更新用户头像
    case uodateusericon(k:Any,dataAry:NSArray)
    //更新用户信息
    case updateuserinfo(k:String)
    //获取用户信息
    case getuserinfo(k:String)
    //关注用户
    case followuser(k:String)
    //取消关注用户
    case unfollowuser(k:String)
    //获取关注用户列表
    case getfollowlist(k:String)
    //获取粉丝列表
    case getfancelist(k:String)
    //查找用户
    case finduser(k:String)
    //我的所有帖子
    case getmyallposts(k:String)
    //管理员或用户批量更新帖子状态
    case updateposts(k:String)
    //举报帖子
    case reportpostbypostd(k:String)
    //获取被举报的帖子列表
    case getreportlist(k:String)
    //管理员获取待审核中的所有帖子
    case getexamineList(k:String)
    //发帖
    case sendpost(k:String)
    //获取用户的所有帖子
    case getuserposts(k:String)
    //首页获取推荐帖子
    case getposts(k:String)
    //删除帖子
    case deletspost(K:String)
    //获取推荐关注列表
    case findrecommendlist(k:String)
    //上传多张图片
    case upLoadFiles(K:Any,dataAry:NSArray)
    //点赞
    case poststart(K:String)
    //取消点赞
    case postunstart(K:String)
    //获取点赞列表
    case getpoststartlist(K:String)
    //收藏
    case collection(K:String)
    //取消收藏
    case cancelcollection(K:String)
    //获取收藏列表
    case getcollectionlist(K:String)
    //获取用户所有点赞的帖子
    case getuserstartlist(k:String)
    //发评论
    case sendcomment(k:String)
    //获取评论列表
    case commentlist(k:String)
    //删除评论
    case deletecomment(k:String)
    //获取我的图片
    case getallimasges(k:String)
    //我的所有评论
    case getusermsgs(k:String)
    //点赞评论
    case msgstart(k:String)
    //取消点赞评论
    case msgunstart(k:String)
    //获取开发者信息
    case developerinfo
    //意见反馈
    case sendfeekback(k:String)
    //获取意见反馈列表
    case getfeekbacklist(k:String)
    //获取是否有最新的数据
    case getisnewpost(k:String)
        
    case checkimages(K:Any,dataAry:NSArray)
    //
    case getallusers(k:String)
    
}
extension NetworkService:Moya.TargetType{
    //MARK: - APISERVICE
    public var baseURL: URL {
        switch self {
        case .checkimages:
            let api = ApiKey.default.TXAiApi
                   return URL(string: api )!
        default:
            let api = ApiKey.default.BaseApi
                              return URL(string: api )!
        }
       
    }
    //MARK: - 请求地址
    public var path: String {
        switch self {
        case .login:
            return "swiftTemplate/User/login"
        case .register:
            return "swiftTemplate/User/register"
        case .getmsg:
            return "swiftTemplate/User/sendMsg"
        case .tabhome:
            return "myApplication/cas/getPageNovelList"
        case .searchnovel:
            return "myApplication/cas/searchNovel"
        case .uodateusericon:
            return "swiftTemplate/User/uploadusericon"
        case .updateuserinfo:
            return "swiftTemplate/User/updateUser"
        case .followuser:
            return "swiftTemplate/Follow/followuser"
        case .unfollowuser:
            return "swiftTemplate/Follow/unfollowuser"
        case .getfollowlist:
            return "swiftTemplate/Follow/getfollowlist"
        case .getfancelist:
            return "swiftTemplate/Follow/getfancelist"
        case .finduser:
            return "swiftTemplate/User/searchfollow"
        case .findrecommendlist:
            return "swiftTemplate/Follow/getrecommendlist"
        case .sendpost:
            return "swiftTemplate/Post/sendPost"
        case .getuserposts:
            return "swiftTemplate/Post/getPostsByUserId"
        case .getposts:
            return "swiftTemplate/Post/getPosts"
        case .deletspost:
            return "swiftTemplate/Post/deletePost"
        case .upLoadFiles:
            return "swiftTemplate/file/upLoadFiles"
        case .getuserinfo:
            return "swiftTemplate/User/getUseInfo"
        case .poststart:
            return "swiftTemplate/PostStart/start"
        case .postunstart:
            return "swiftTemplate/PostStart/unStart"
        case .getpoststartlist:
            return "swiftTemplate/PostStart/getPostStartList"
        case .collection:
            return "swiftTemplate/PostStart/collection"
        case .cancelcollection:
            return "swiftTemplate/PostStart/cancelCollection"
        case .getcollectionlist:
            return "swiftTemplate/PostStart/getCollectionList"
        case .getuserstartlist:
            return "swiftTemplate/PostStart/getUserAllStartList"
        case .sendcomment:
            return "swiftTemplate/Message/sendMessage"
        case .commentlist:
            return "swiftTemplate/Message/getMessages"
        case .deletecomment:
            return "swiftTemplate/Message/deleteMessage"
        case .getallimasges:
            return "swiftTemplate/file/getMyAllImages"
        case .getusermsgs:
            return "swiftTemplate/Message/getUserMessages"
        case .respsd:
           return "swiftTemplate/User/updatePassWord"
        case .msgstart:
             return "swiftTemplate/Message/startMassage"
        case .msgunstart:
             return "swiftTemplate/Message/unStartMassage"
        case .developerinfo:
             return "swiftTemplate/User/getDeveloperInfo"
        case .sendfeekback:
             return "swiftTemplate/User/sendFeedBack"
        case .getfeekbacklist:
            return "swiftTemplate/User/getFeedBack"
        case .getisnewpost:
            return "swiftTemplate/Post/isHaveNewPost"
        case .checkimages:
            return "fcgi-bin/vision/vision_porn"
        case .getmyallposts:
             return "swiftTemplate/Post/getMyPosts"
        case .updateposts:
             return "swiftTemplate/Post/updatePosts"
        case .reportpostbypostd:
             return "swiftTemplate/Post/reportPostByPostId"
        case .getreportlist:
             return "swiftTemplate/Post/getReportList"
        case .getexamineList:
             return "swiftTemplate/Post/getExamineList"
        case .getallusers:
            return "swiftTemplate/User/getAllUser"
        }
        
    }
    //MARK: - 请求方式
    public var method: Moya.Method {
        return .post
    }
    //MARK: - 测试数据
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    //MARK: - 请求参数
    public var task: Moya.Task {
        switch self {
        case .login(let data),.register(let data),.getmsg(let data),.tabhome(let data),.searchnovel(let data),.updateuserinfo(let data),.followuser(let data),.unfollowuser(let data),.getfancelist(let data),.getfollowlist(let data),.finduser(let data),.findrecommendlist(let data),.sendpost(let data),.getposts(let data),.getuserposts(let data),.deletspost(let data),.getuserinfo(let data),.poststart(let data),.postunstart(let data),.getpoststartlist(let data),.collection(let data),.cancelcollection(let data),.getcollectionlist(let data),.getuserstartlist(let data),.sendcomment(let data),.commentlist(let data),.deletecomment(let data),.getallimasges(let data),.getusermsgs(let data),.respsd(let data),.msgstart(let data),.msgunstart(let data),.sendfeekback(let data),.getfeekbacklist(let data),.getisnewpost(let data),.getmyallposts(let data),.updateposts(let data),.reportpostbypostd(let data),.getreportlist(let data),.getexamineList(let data),.getallusers(let data):
            return  .requestData(data.utf8Encoded)
            
        case .uodateusericon(let param, let uploadImages):
            let formDataAry:NSMutableArray = NSMutableArray()
            for (index,image) in uploadImages.enumerated() {
                let data:Data = (image as! UIImage).compressImageMid(maxLength: 2048) ?? Data()
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                dateStr = dateStr.appendingFormat("-%i.png", index)
                let formData = MultipartFormData(provider: .data(data), name: "uploadFile", fileName: dateStr, mimeType: "image/jpeg")
                formDataAry.add(formData)
            }
            guard let p1 = param as? [String:String] else { return .requestPlain}
            return .uploadCompositeMultipart(formDataAry as! [MultipartFormData], urlParameters: p1)
        case .upLoadFiles(let param, let uploadImages):
            let formDataAry:NSMutableArray = NSMutableArray()
            for (index,image) in uploadImages.enumerated() {
                let data:Data = (image as! UIImage).compressImageMid(maxLength: 1024) ?? Data()
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                dateStr = dateStr.appendingFormat("-%i.png", index)
                let formData = MultipartFormData(provider: .data(data), name: "uploadFiles", fileName: dateStr, mimeType: "image/jpeg")
                formDataAry.add(formData)
            }
            let p1 = param as? [String:String]
            p1?.forEach({ (arg0) in
                let (key, value) = arg0
                let strData = value.data(using: .utf8)
                let formData = MultipartFormData(provider:.data(strData!), name: key)
                formDataAry.add(formData)
            })
            return .uploadMultipart(formDataAry as! [MultipartFormData])
        case .checkimages(let param, let uploadImages):
            let formDataAry:NSMutableArray = NSMutableArray()
                       for (index,image) in uploadImages.enumerated() {
                           let data:Data = (image as! UIImage).compressImageMid(maxLength: 1024) ?? Data()
                           let date:Date = Date()
                           let formatter = DateFormatter()
                           formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                           var dateStr:String = formatter.string(from: date as Date)
                           dateStr = dateStr.appendingFormat("-%i.png", index)
                           let formData = MultipartFormData(provider: .data(data), name: "uploadFiles", fileName: dateStr, mimeType: "image/jpeg")
                           formDataAry.add(formData)
                       }
                       let p1 = param as? [String:String]
                       p1?.forEach({ (arg0) in
                           let (key, value) = arg0
                           let strData = value.data(using: .utf8)
                           let formData = MultipartFormData(provider:.data(strData!), name: key)
                           formDataAry.add(formData)
                       })
                       return .uploadMultipart(formDataAry as! [MultipartFormData])
        case .developerinfo:
            return .requestPlain
            
        }
        
        
    }
    
    // MARK: - 请求HEADER
    public var headers: [String : String]? {
        switch self {
        case .upLoadFiles,.uodateusericon:
            let boundary = String(format: "boundary.%08x%08x", arc4random(), arc4random())
            let contentType = String(format: "multipart/form-data;boundary=%@", boundary)
            return ["Content-type":contentType,"token":UserInfoHelper.instance.user?.token  ?? ""]
        default:
            return ["Content-type":"application/json","token":UserInfoHelper.instance.user?.token   ?? ""]
        }
    }
    
}
public extension Date{
    var date2String: String {
        let dateFormat:String = "yyyy-MM-dd HH:mm:ss"
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
    var calculateWithDate:String {
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return ""
        }
        let components = calendar.components([.month, .day], from: self)
        let month = components.month!
        let day = components.day!
        
        // 月以100倍之月作为一个数字计算出来
        let mmdd = month * 100 + day;
        var result = ""
        
        if ((mmdd >= 321 && mmdd <= 331) ||
            (mmdd >= 401 && mmdd <= 419)) {
            result = "白羊座"
        } else if ((mmdd >= 420 && mmdd <= 430) ||
            (mmdd >= 501 && mmdd <= 520)) {
            result = "金牛座"
        } else if ((mmdd >= 521 && mmdd <= 531) ||
            (mmdd >= 601 && mmdd <= 621)) {
            result = "双子座"
        } else if ((mmdd >= 622 && mmdd <= 630) ||
            (mmdd >= 701 && mmdd <= 722)) {
            result = "巨蟹座"
        } else if ((mmdd >= 723 && mmdd <= 731) ||
            (mmdd >= 801 && mmdd <= 822)) {
            result = "狮子座"
        } else if ((mmdd >= 823 && mmdd <= 831) ||
            (mmdd >= 901 && mmdd <= 922)) {
            result = "处女座"
        } else if ((mmdd >= 923 && mmdd <= 930) ||
            (mmdd >= 1001 && mmdd <= 1023)) {
            result = "天秤座"
        } else if ((mmdd >= 1024 && mmdd <= 1031) ||
            (mmdd >= 1101 && mmdd <= 1122)) {
            result = "天蝎座"
        } else if ((mmdd >= 1123 && mmdd <= 1130) ||
            (mmdd >= 1201 && mmdd <= 1221)) {
            result = "射手座"
        } else if ((mmdd >= 1222 && mmdd <= 1231) ||
            (mmdd >= 101 && mmdd <= 119)) {
            result = "摩羯座"
        } else if ((mmdd >= 120 && mmdd <= 131) ||
            (mmdd >= 201 && mmdd <= 218)) {
            result = "水瓶座"
        } else if ((mmdd >= 219 && mmdd <= 229) ||
            (mmdd >= 301 && mmdd <= 320)) {
            //考虑到2月闰年有29天的
            result = "双鱼座"
        }else{
            print(mmdd)
            result = "日期错误"
        }
        return result
    }
    
    
    
}
// MARK: - Helpers
public extension String {
    //日期 -> 字符串
    //字符串 -> 日期
    var string2DateString : String {
        let formatter1 = DateFormatter()
        formatter1.locale = Locale.init(identifier: "en_US")
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        let date = formatter1.date(from: self) ?? Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年MM月dd日 HH时:mm分:ss秒"
        return formatter.string(from: date)
    }
    var string2DateMMdd : String {
           let formatter1 = DateFormatter()
           formatter1.locale = Locale.init(identifier: "en_US")
           formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
           let date = formatter1.date(from: self) ?? Date()
           let formatter = DateFormatter()
           formatter.locale = Locale.init(identifier: "zh_CN")
           formatter.dateFormat = "MM-dd HH:mm:ss"
           return formatter.string(from: date)
       }
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 32)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}

