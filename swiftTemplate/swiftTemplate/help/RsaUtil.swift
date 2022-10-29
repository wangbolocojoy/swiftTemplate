//
//  RsaUtil.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
import SwiftyRSA
class RsaUtil {
    static let `default` = RsaUtil()
    
    typealias KeyPair = (publicKey: SecKey, privateKey: SecKey)
    //签名请求体
     public func signature(json:String)->String?{
        let prk = KeychainManager.User.ReadDataByIdentifier(forKey: .私钥) as! String
        let privateKey = try? PrivateKey(base64Encoded: prk )
          let clear = try? ClearMessage(string: json, using: .utf8)
          if (privateKey == nil){
              return nil
          }
          let signature = try? clear?.signed(with: privateKey! , digestType: .sha1)
          let base64String = signature?.base64String
          
          return base64String
      }
      private  func appendPrefixSuffixTo(_ string: String, prefix: String, suffix: String) -> String {
       return string
      }
      private func generateKeyPair(_ publicTag: String, privateTag: String, keySize: Int) -> KeyPair? {
       var sanityCheck: OSStatus = noErr
       var publicKey: SecKey?
       var privateKey: SecKey?
      //Container dictionaries
       var privateKeyAttr = [AnyHashable : Any]()
       var publicKeyAttr = [AnyHashable: Any]()
       var keyPairAttr = [AnyHashable : Any]()
      //Set top level dictionary for the keypair
       keyPairAttr[(kSecAttrKeyType ) as AnyHashable] = (kSecAttrKeyTypeRSA as Any)
       keyPairAttr[(kSecAttrKeySizeInBits as AnyHashable)] = Int(keySize)
      //Set private key dictionary
          privateKeyAttr[(kSecAttrIsPermanent as AnyHashable)] = Int(truncating: true)
       privateKeyAttr[(kSecAttrApplicationTag as AnyHashable)] = privateTag
          publicKeyAttr[(kSecAttrIsPermanent as AnyHashable)] = Int(truncating: true)
       publicKeyAttr[(kSecAttrApplicationTag as AnyHashable)] = publicTag
       keyPairAttr[(kSecPrivateKeyAttrs as AnyHashable)] = privateKeyAttr
       keyPairAttr[(kSecPublicKeyAttrs as AnyHashable)] = publicKeyAttr
       sanityCheck = SecKeyGeneratePair((keyPairAttr as CFDictionary), &publicKey, &privateKey)
       if sanityCheck == noErr && publicKey != nil && privateKey != nil {
          print("RSA key pair generation Successful")
          return KeyPair(publicKey: publicKey!, privateKey: privateKey!)
       }
       return nil
      }
      
      public  func creatPublicAndPrivateKey(publicKeyTag:String,privateKeyTag:String){
              var pukkeyString:String? = nil
              var prakeyString:String? = nil
          
              let keyPair = generateKeyPair(publicKeyTag, privateTag: privateKeyTag, keySize: 1024)
              var pbError:Unmanaged<CFError>?
              var prError:Unmanaged<CFError>?
              guard let pbData = SecKeyCopyExternalRepresentation((keyPair?.publicKey)!, &pbError) as Data? else {
              print("error:", pbError!.takeRetainedValue() as Error)
              return
              }
              guard let prData = SecKeyCopyExternalRepresentation((keyPair?.privateKey)!, &prError) as Data? else {
              print("private key error:")
              return
              }
              pukkeyString = appendPrefixSuffixTo(pbData.base64EncodedString(), prefix:"-----BEGIN RSA PUBLIC KEY-----n", suffix:"n-----END RSA PUBLIC KEY-----")
              log.debug(pukkeyString ?? "")
        let savepuk = KeychainManager.User.SaveByIdentifier(data: pukkeyString ?? nil ?? "", forKey: .公钥)
                  if savepuk {
                      log.verbose("KeyChain保存公钥成功\(pukkeyString!)")
                  }
                         
              prakeyString = appendPrefixSuffixTo(prData.base64EncodedString(), prefix:"-----BEGIN RSA PRIVATE KEY-----n", suffix:"n-----END RSA PRIVATE KEY-----")
           
              log.debug(prakeyString ?? "")
        let saveprk =   KeychainManager.User.SaveByIdentifier(data: prakeyString ?? nil ?? "", forKey: .私钥)
                  if saveprk {
                       log.verbose("KeyChain保存私钥成功\(prakeyString!)")
                  }
              }
          func getTime() -> Int{
              return Int(Date().timeIntervalSince1970*1000)
          }
}
