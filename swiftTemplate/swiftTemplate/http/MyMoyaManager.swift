//
//  MyMoyaManager.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import Alamofire

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
private func moyascratyManager() -> Manager?{
  
    var manager :Manager
    
    if ApiKey.default.版本环境 == "测试版本" {
        manager = MoyaProvider<MultiTarget>.defaultAlamofireManager()
        manager.delegate.sessionDidReceiveChallenge = {
            session,challenge in
            return    (URLSession.AuthChallengeDisposition.useCredential,URLCredential(trust:challenge.protectionSpace.serverTrust!))
        }
    }else{
        let configuration = URLSessionConfiguration.default
          configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
          //    let path: String = Bundle.main.path(forResource: "apphttps", ofType: "cer") ?? ""
          let path:String = Bundle.main.path(forResource: "apphttps", ofType: ".cer") ?? ""
          guard  let certificationData = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData else {
              return nil
          }
          guard let certificate = SecCertificateCreateWithData(nil, certificationData) else { return nil }
          let certificates: [SecCertificate] = [certificate]
          
          let policies : [String:ServerTrustPolicy] = ["90btm": ServerTrustPolicy.pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: true)]
            manager = Manager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
    }
    return manager
}

// MARK: - 请求管理
struct MyMoyaManager{
    //MARK: - 通用请求
    static func AllRequest<T:TargetType>(controller:UIViewController,_ target:T,success successCallback: @escaping (BaseResponse) -> Void) {
        guard let manager = moyascratyManager() else { return
            controller.ShowTip(Title: "不能使用代理进行访问")
        }
        let provider = MoyaProvider<T>(endpointClosure: endpointMapping ,requestClosure: requestClosure, manager:manager, plugins:[RequestAlertPlugin(viewController: controller)])
        provider.request(target) { (event) in
            switch event {
            case let .success(response):
                do {
                    let data = try response.mapJSON() as! [String:Any]
                    if let u = BaseResponse(JSON: data){
                        log.info(u)
                        if u.status ?? 0 == 200{
                            successCallback(u)
                            
                        }else if u.status ?? 0 == 500{
                            controller.ShowTip(Title: u.message ?? u.msg ?? "请求失败")
                            //                                KeychainManager.User.DeleteByIdentifier(forKey: .UserInfo)
                            //                                UIView.animate(withDuration: 0.9, animations:{ }, completion: { (true) in
                            //                                               let tranststion =  CATransition()
                            //                                    tranststion.duration = 0.9
                            //                                               tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                            //                                                   UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
                            //                                                                  UIApplication.shared.keyWindow?.rootViewController = controller.getloginVc()
                            //
                            //
                            //                                           })
                        }else{
//                            controller.ShowTip(Title: u.msg ?? "请求失败")
                        }
                    }else{
                        controller.ShowTip(Title: "解析失败")
                    }
                    
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
    //MARK: - 通用请求透明菊花可以操作界面
    static func AllRequestNospinner<T:TargetType>(controller:UIViewController,_ target:T,success successCallback: @escaping (BaseResponse) -> Void) {
        guard let manager = moyascratyManager() else { return
            controller.ShowTip(Title: "不能使用代理进行访问")
        }
        let provider = MoyaProvider<T>(endpointClosure: endpointMapping ,requestClosure: requestClosure, manager:manager, plugins:[ClearRequestAlertPlugin(viewController: controller)])
        provider.request(target) { (event) in
            switch event {
            case let .success(response):
                do {
                    let data = try response.mapJSON() as! [String:Any]
                    if let u = BaseResponse(JSON: data){
                        log.info(u)
                        if u.status ?? 0 == 200{
                            successCallback(u)
                            
                        }else if u.status ?? 0 == 500{
                            //                                  controller.ShowTip(Title: u.message ?? u.msg ?? "请求失败")
                            //                                KeychainManager.User.DeleteByIdentifier(forKey: .UserInfo)
                            //                                UIView.animate(withDuration: 0.9, animations:{ }, completion: { (true) in
                            //                                               let tranststion =  CATransition()
                            //                                    tranststion.duration = 0.9
                            //                                               tranststion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                            //                                                   UIApplication.shared.keyWindow?.layer.add(tranststion, forKey: "animation")
                            //                                                                  UIApplication.shared.keyWindow?.rootViewController = controller.getloginVc()
                            //
                            //
                            //                                           })
                            log.error(u.msg ?? "")
                        }else{
                            //                                  controller.ShowTip(Title: u.msg ?? "请求失败")
                            log.error(u.msg ?? "")
                        }
                        
                    }else{
                        log.error(data )
                        controller.ShowTip(Title: "解析失败")
                    }
                    
                } catch {
                    //可不做处理
                    
                    //                      controller.ShowTip(Title: "请求失败，解析异常")
                }
                break
            case let .failure(error):
                log.error(error)
                break
            }
        }
    }
    
    
    
}
