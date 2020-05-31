# Swift项目快速开发框架

## 集成该项目可以快速开发ios  app

### 网络请求加解析框架 基于 [Moya](https://github.com/Moya/Moya) [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) 基础上进行封装 使用  UIViewController.  ```AllRequest``` 进行使用
```swift
struct MyMoyaManager{
    //MARK: - 通用请求
    static func AllRequest<T:TargetType>(controller:UIViewController,_ target:T,success successCallback: @escaping (BaseResponse) -> Void,failed failedCallback: @escaping (BaseResponse?) -> Void ) {
        let provider = MoyaProvider<T>(endpointClosure: endpointMapping ,requestClosure: requestClosure, manager:moyaManager(), plugins:[RequestAlertPlugin(viewController: controller)])
        provider.request(target) { (event) in
            switch event {
            case let .success(response):
                do {
                    let data = try response.mapJSON() as! [String:Any]
                        if let u = BaseResponse(JSON: data){
                                successCallback(u)
                                log.info(u)
                        }else{
                            controller.ShowTip(Title: "解析失败")
                        }
                      log.error(data)
                } catch {
                    //可不做处理
                    failedCallback(nil)
                    controller.ShowTip(Title: "请求失败，解析异常")
                }
                break
            case let .failure(error):
                 failedCallback(nil)
                log.error(error)
                break
            }
        }
    }
  
    
}
```
### KeychainManager 封装

```swift
extension KeychainManager{
    struct User: KeychainManagerSettable {
           enum defaultKeys:String,CaseIterable{
               case 手机号
               case 密码
               case 公钥
               case 私钥
               case token
               case userid
           }
       }
}

protocol KeychainManagerSettable {
    associatedtype defaultKeys:RawRepresentable
}

extension KeychainManagerSettable where defaultKeys.RawValue == String{
    // TODO: 存储数据
    static func SaveByIdentifier(data:Any ,forKey key :defaultKeys)->Bool {
           let akey = key.rawValue
        // 获取存储数据的条件
        return KeychainManager.keyChainSaveData(data: data, withIdentifier: akey)
    }
    // TODO: 更新数据
    static func UpdataByIdentifier(data:Any ,forKey key :defaultKeys)->Bool {
           let akey = key.rawValue
        return KeychainManager.keyChainUpdata(data: data, withIdentifier: akey)
    }
    
    // TODO: 获取数据
    static func ReadDataByIdentifier(forKey key :defaultKeys)-> Any {
      let akey = key.rawValue
      return KeychainManager.keyChainReadData(identifier: akey)
    }
    // TODO: 删除数据
    static func DeleteByIdentifier(forKey key :defaultKeys)->Void{
         let akey = key.rawValue
        KeychainManager.keyChianDelete(identifier: akey)
    }
    
}

```
#### KeychainManager 使用
```swift
        //保存数据 Any
       if KeychainManager.User.SaveByIdentifier(data: "1398784645", forKey: .手机号) {
           //保存成功
       }else{
           //保存失败
       }
       //获取数据
       let phone = KeychainManager.User.ReadDataByIdentifier(forKey: .手机号) as? String
       //删除数据
       KeychainManager.User.DeleteByIdentifier(forKey: .手机号)
```
#### UserDefaults 扩展使用
```swift
       //保存数据
       UserDefaults.User.set(value: "1355024547", forKey: .手机号)
       //获取数据
       let phone = UserDefaults.User.getvalue(forKey: .手机号) as? String
```

#### app首页适配Dark模式，接入注册登录，[后台地址](https://github.com/wangbolocojoy/KotlinSpringBootBack)

#### app首页
![image](https://myiosandroidkotlinapplication.oss-cn-chengdu.aliyuncs.com/home/picture/IMG_2472.PNG)
![image](https://myiosandroidkotlinapplication.oss-cn-chengdu.aliyuncs.com/home/picture/IMG_2473.PNG)
