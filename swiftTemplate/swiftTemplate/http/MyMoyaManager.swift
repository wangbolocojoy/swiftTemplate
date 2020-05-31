//
//  MyMoyaManager.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper


private func endpointMapping<Target: TargetType>(target: Target) -> Endpoint {
    log.info("Moya请求连接：____   \(target.baseURL)/\(target.path)   ___________   \(target.method)")

    return MoyaProvider.defaultEndpointMapping(for: target)
}
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = 30
        // 打印请求参数
        if let requestData = request.httpBody {
            log.info("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
           log.info("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}
//不验证CA证书
private func moyaManager ()-> Manager{
    let manager: Manager = MoyaProvider<MultiTarget>.defaultAlamofireManager()
    manager.delegate.sessionDidReceiveChallenge = {
        session,challenge in
        return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
    }
    return manager
}
// MARK: - 请求管理
struct MyMoyaManager{
    //MARK: - 通用请求
    static func AllRequest<T:TargetType>(controller:UIViewController,_ target:T,success successCallback: @escaping (BaseResponse) -> Void) {
        let provider = MoyaProvider<T>(endpointClosure: endpointMapping ,requestClosure: requestClosure, manager:moyaManager(), plugins:[RequestAlertPlugin(viewController: controller)])
        provider.request(target) { (event) in
            switch event {
            case let .success(response):
                do {
                    let data = try response.mapJSON() as! [String:Any]
                        if let u = BaseResponse(JSON: data){
                            if u.status ?? 0 == 200{
                                 successCallback(u)
                            }else{
                                controller.ShowTip(Title: u.msg ?? "请求失败")
                            }
                               
                                log.info(u)
                        }else{
                            controller.ShowTip(Title: "解析失败")
                        }
                      log.error(data)
                } catch {
                    //可不做处理
                    
                    controller.ShowTip(Title: "请求失败，解析异常")
                }
                break
            case let .failure(error):
                log.error(error)
                break
            }
        }
    }
  
    
}
