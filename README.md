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

