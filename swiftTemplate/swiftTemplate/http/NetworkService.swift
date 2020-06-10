//
//  NetworkService.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
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
    //我的首页
    case tabhome(K:String)
    //搜索小说
    case searchnovel(k:String)
    //更新用户头像
    case uodateusericon(k:Any,dataAry:NSArray)
    //更新用户信息
    case updateuserinfo(k:String)
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
    
    case findrecommendlist(k:String)
}
extension NetworkService:Moya.TargetType{
    //MARK: - APISERVICE
    public var baseURL: URL {
        let api = Constant.instance.BaseApi
        return URL(string: api )!
    }
    //MARK: - 请求地址
    public var path: String {
        switch self {
        case .login:
            return "back-1/swiftTemplate/User/login"
        case .register:
            return "back-1/swiftTemplate/User/register"
        case .getmsg:
            return "getmsg"
        case .tabhome:
            return "back-1/myApplication/cas/getPageNovelList"
        case .searchnovel:
            return "back-1/myApplication/cas/searchNovel"
        case .uodateusericon:
            return "back-1/swiftTemplate/User/uploadusericon"
        case .updateuserinfo:
            return "back-1/swiftTemplate/User/updateUser"
        case .followuser:
            return "back-1/swiftTemplate/Follow/followuser"
        case .unfollowuser:
            return "back-1/swiftTemplate/Follow/unfollowuser"
        case .getfollowlist:
            return "back-1/swiftTemplate/Follow/getfollowlist"
        case .getfancelist:
            return "back-1/swiftTemplate/Follow/getfancelist"
        case .finduser:
            return "back-1/swiftTemplate/User/searchfollow"
        case .findrecommendlist:
            return "back-1/swiftTemplate/Follow/getrecommendlist"
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
        case .login(let data),.register(let data),.getmsg(let data),.tabhome(let data),.searchnovel(let data),.updateuserinfo(let data),.followuser(let data),.unfollowuser(let data),.getfancelist(let data),.getfollowlist(let data),.finduser(let data),.findrecommendlist(let data):
            return  .requestData(data.utf8Encoded)
            
        case .uodateusericon(let param, let uploadImages):
            let formDataAry:NSMutableArray = NSMutableArray()
            for (index,image) in uploadImages.enumerated() {
                let data:Data = (image as! UIImage).jpegData(compressionQuality: 0.8)!
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
        }
        
        
    }
    // MARK: - 请求HEADER
    public var headers: [String : String]? {
        return ["Content-type":"application/json","token":UserDefaults.User.getvalue(forKey: .token) as? String ?? ""]
    }
    
}
// MARK: - Helpers
private extension String {
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

