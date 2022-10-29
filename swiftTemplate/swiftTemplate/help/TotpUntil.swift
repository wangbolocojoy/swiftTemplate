//
//  TotpUntil.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation

class TotpUntil {
    
    private static let DIGITS_POWER = [ 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000 ]
    
    
   static func generateTOTP(key:String,time:String,returnDigits:Int) ->String {
        return generateTOTP(key: key, time: time, returnDigits: returnDigits, crypto: "HmacSHA1")
    }
   static func generateTOTP256(key:String,time:String,returnDigits:Int) -> String  {
        return generateTOTP(key: key, time: time, returnDigits: returnDigits, crypto: "HmacSHA256")
    }
   static func generateTOTP512(key:String,time:String,returnDigits:Int) ->String {
        return generateTOTP(key: key, time: time, returnDigits: returnDigits, crypto: "HmacSHA512")
    }
   static func generateTOTP(key:String,time:String,returnDigits:Int,crypto:String) -> String {
    let codeDigits = Int(returnDigits)
    var result = ""
    var time = time
    while time.count < 16 { time = "0"+time }
    let msg = hexStr2Bytes(hex: time)
    let k = hexStr2Bytes(hex: key)
    let uh1 = hmac(algorithm: HMACAlgorithm.SHA1, key: k, text: msg)
    let hash = uh1.bytes
    var array: [Int]=[]
    for (_,k) in hash.enumerated(){
        array.append(Int(k))
    }
    let offset = (array[array.count - 1] & 0xf)
    let binary = ((array[offset] & 0x7f) << 24) | ((array[offset + 1] & 0xff) << 16) | ((array[offset + 2] & 0xff) << 8) | (array[offset + 3] & 0xff)
    let otp = binary % DIGITS_POWER[returnDigits]
        result = String(otp);
        while (result.count < codeDigits) {
            result = "0" + result;
        }
        return result;
    }
    //传现在的时间
    static func  generateOTP( key:String,  date:Date,  duration:Int , digits:Int) -> String{
        let datetime = Int(floor(date.timeIntervalSince1970*1000))
        let time = datetime / 1000  / duration ;
        let strtime = String(time)
        let strkey = hexString(from: key)!
        return generateTOTP(key: strkey,time: strtime,returnDigits: 6);
        
    }
    //直接传接口返回的值
    static func generateOTP(key:String,diff:Int,duration:Int ) -> String{
        
        let date = Date()
        let datetime = Int(floor(date.timeIntervalSince1970*1000))
        let steps = (datetime - diff) / 1000 / duration;
//        log.debug("steps\(steps)")
        let strkey = hexString(from: key)!
//         log.debug("strkey\(strkey)")
        return generateTOTP(key: strkey, time: String(steps), returnDigits: 6)
    }
    //获取进度值
    static func computeProgress(time:Int,duration:Int ) -> String{
        let date = Date()
        let datetime = Int(floor(date.timeIntervalSince1970*1000))-time
        let time = datetime  / 1000  % duration;
        return String(time)
    }

   
    
   static func hexString(from string: String?) -> String? {
        let myD: Data? = string?.data(using: .utf8)
        //    let bytes = myD?.withUnsafeBytes as? withunsafebytes
        var byte = [UInt8]((myD)!)
        //下面是Byte 转换为16进制。
        var hexStr = ""
        for i in 0..<(myD?.count ?? 0) {
            let newHexStr = String(format: "%x", Int(byte[i] ) & 0xff) ///16进制数
            if newHexStr.count == 1 {
                hexStr = "\(hexStr)0\(newHexStr)"
            } else {
                hexStr = "\(hexStr)\(newHexStr)"
            }
        }
        return hexStr
    }
   
    static func hexStr2Bytes(hex :String) -> [UInt8] {
        var byteArray = [UInt8]()
        let d = Strtodata(from: "10"+hex)
        for (_,v )in d.bytes.enumerated(){
            byteArray.append(v)
        }
        var ret = [UInt8](repeating: 0, count: byteArray.count-1)
        for (k,_) in ret.enumerated(){
            ret[k] = byteArray[k+1]
        }
        return ret
    }
    //将十六进制字符串转化为 Data
    static func Strtodata(from hexStr: String) -> Data {
        let bytes = self.bytes(from: hexStr)
        return Data(bytes: bytes)
    }
    // 将16进制字符串转化为 [UInt8]
    // 使用的时候直接初始化出 Data
    // Data(bytes: Array<UInt8>)
    static  func bytes(from hexStr: String) -> [UInt8] {
        assert(hexStr.count % 2 == 0, "输入字符串格式不对，8位代表一个字符")
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
   static func hmac(algorithm: HMACAlgorithm, key: [UInt8],text:[UInt8]) -> String {
        let cKey = key
        let cData = text
        var result = [UInt8](reserveCapacity: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey, cKey.count, cData, cData.count, &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options:.lineLength76Characters)
        
        return String(hmacBase64)
    }
 
}




enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension Data {
    
    public init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }

    public var bytes: Array<UInt8> {
        return Array(self)
    }
    
   
}
extension String {
public var bytes: Array<UInt8> {
    return data(using: String.Encoding.utf8, allowLossyConversion: true)?.bytes ?? Array(utf8)
}
}
extension Array {
    public init(reserveCapacity: Int) {
        self = Array<Element>()
        self.reserveCapacity(reserveCapacity)
    }

    var slice: ArraySlice<Element> {
        return self[self.startIndex ..< self.endIndex]
    }
    
}

public extension Array where Element == UInt8 {
    func toBase64() -> String? {
        return Data( self).base64EncodedString()
    }

    init(base64: String) {
        self.init()

        guard let decodedData = Data(base64Encoded: base64) else {
            return
        }

        append(contentsOf: decodedData.bytes)
    }
}

extension Array where Element == UInt8 {
    public init(hex: String) {
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0
        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }
            guard char.value >= 48 && char.value <= 102 else {
                removeAll()
                return
            }
            let v: UInt8
            let c: UInt8 = UInt8(char.value)
            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }
            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }
        if let b = buffer {
            append(b)
        }
    }

    public func toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}
