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
            return "back-1/myApplication/cas/login"
        case .register:
            return "back-1/myApplication/cas/register"
        case .getmsg:
            return "getmsg"
        case .tabhome:
            return "back-1/myApplication/cas/getPageNovelList"
            //novelName
        case .searchnovel:
            return "back-1/myApplication/cas/searchNovel"
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
        case .login(let data),.register(let data),.getmsg(let data),.tabhome(let data),.searchnovel(let data):
            return  .requestData(data.utf8Encoded)
//        case .GetToken:
//            return  .requestPlain
//        case .login(let data)):
//             guard let p1 = data as? [String:String] else { return .requestPlain}
//                      return .requestParameters(parameters: p1, encoding: URLEncoding.default)
            break
        }
            
        
    }
    // MARK: - 请求HEADER
    public var headers: [String : String]? {
      return ["Content-type":"application/json"]
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

