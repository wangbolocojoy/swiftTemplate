//
//  AliyunOssUtil.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/8/15.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation

class AliyunOssUtil {
    
    static let `default` = AliyunOssUtil()
    var ossclient : OSSClient?
    init() {
        //        OSSLog.enable()
        //        let cardkey =     OSSAuthCredentialProvider(authServerUrl: "http://90btm.com/back-1/swiftTemplate/Post/gettoken")
        //                                log.verbose(cardkey)
        //                          let config = OSSClientConfiguration()
        //                          config.maxRetryCount = 3
        //                          config.timeoutIntervalForRequest = 30
        //        config.isHttpdnsEnable = false
        //                          config.timeoutIntervalForResource = 30
        //        let pro = OSSFederationCredentialProvider(federationTokenGetter: gettoken())
        //        let por = OSSStsTokenCredentialProvider(accessKeyId: "STS.NTEEg5c5dHLPnsB1oxbhjiuYx", secretKeyId: "EWKcDCVP8VCPjhM6gY2w6nFcdpLGY3x1gDHeWuoFeQv", securityToken: "CAIS8QF1q6Ft5B2yfSjIr5fwDt2BjupF/467bFXz1W8tbudGhrDymjz2IH5Ie3RgAOgXsfwynGpW7vcalqB6U4deSFbaYNEoK2uPFdTnMeT7oMWQweEuqv/MQBq+aXPS2MvVfJ+KLrf0ceusbFbpjzJ6xaCAGxypQ12iN+/i6/clFKN1ODO1dj1bHtxbCxJ/ocsBTxvrOO2qLwThjxi7biMqmHIl0TgluP3kn53Ct0CP0g2l8IJP+dSteKrDRtJ3IZJyX+2y2OFLbafb2EZSkUMUqPgr3PUcqGif44nHXQEAuw/nOvLM6dB1MgJjdleZ0T3yKXqVGoABQNm2I5P/2TCdvY0xgriIxaMAsQYZcTAYDqK1htauftOgHCrQp0GJQsO3pnbmOIf/OTwrM9U9E5hH0BoMShmKcpwsPnSb92meh/QB2K/2Yl9bWUaSoYNLyFns7bwukoYWo9zIfemEnNmUkjPwJWXpQz35nl7ZXiJHYdZvKXWrCrA=")
        //
        
    }
    
    func uploadImages(body:RequestBody,token: Credentials?,dataAry:NSArray,waitUnitfinish:Bool = true){
        DispatchQueue.init(label: "SwiftKt.queue").async{
            let request = OSSPutObjectRequest()
            var list :[PostImageBody] = []
            let config = OSSClientConfiguration()
            config.maxRetryCount = 3
            config.timeoutIntervalForRequest = 3000
            config.isHttpdnsEnable = false
            config.timeoutIntervalForResource = 30
            let Oss = OSSStsTokenCredentialProvider(accessKeyId: token?.accessKeyId ?? "", secretKeyId: token?.accessKeySecret ?? "", securityToken: token?.securityToken ?? "")
            self.ossclient = OSSClient(endpoint: "oss-cn-shanghai.aliyuncs.com", credentialProvider: Oss ,clientConfiguration:config)
            for (index,image) in dataAry.enumerated() {
                let data:Data = (image as! UIImage).compressImageMid(maxLength: 2048) ?? Data()
                let date:Date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
                var dateStr:String = formatter.string(from: date as Date)
                dateStr = dateStr.appendingFormat("-%i.png", index)
                request.bucketName = "swiftktidcardinfo"
                request.contentMd5 = OSSUtil.base64Md5(for: data)
                request.objectKey = "home/picture/\(UserInfoHelper.instance.user?.id ?? 0)/\(dateStr)"
                log.verbose(request.objectKey)
                request.uploadingData = data
                request.uploadProgress = { byteSent,toolbyte,tosend in
                    // // 指定当前上传长度、当前已经上传总长度、待上传的总长度。
                    log.verbose("正在上传\(request.objectKey)\(Double(toolbyte))----\(Double(tosend))")
                }
                let puttask = self.ossclient?.putObject(request)
                let cancel = OSSCancellationToken()
                cancel.registerCancellationObserver {
                    log.verbose("取消")
                }
                puttask?.continue({ (task) -> Any? in
                    if task.error == nil{
                        let ibody = PostImageBody()
                        let str = "https://\(request.bucketName).oss-cn-shanghai.aliyuncs.com/\(request.objectKey)"
                        ibody.fileUrl = str
                        ibody.fileType = "image"
                        ibody.originalFileName = request.objectKey
                        ibody.userId = UserInfoHelper.instance.user?.id ?? 0
                        list.append(ibody)
                        
                    }else{
                        log.debug(task.error)
                    }
                    return nil
                },cancellationToken: cancel)
                if waitUnitfinish {
                    puttask?.waitUntilFinished()
                }
            }
            body.postimagelist = list
            //  DispatchQueue.main.async {
            MyMoyaManager.uploadPost(target: NetworkService.sendpost(k: body.toJSONString() ?? ""), success: { (sdata) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "POSTSUCESS"), object: nil)
                  }) { (fdata) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "POSTFAIL"), object: nil)
                  }
                  }
            }
      
        
    }
    

