//
//  ClearRequestAlertPlugin.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/26.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//


import Foundation
import Moya
import Result


final class ClearRequestAlertPlugin: PluginType {
    
    //当前的视图控制器
    private let viewController: UIViewController
    
    //活动状态指示器（菊花进度条）
    private var spinner: UIActivityIndicatorView!
    private var vcBank:UIView!
    private var spbank:UIView!
    //插件初始化的时候传入当前的视图控制器
    init(viewController: UIViewController) {
        self.viewController = viewController
        //初始化活动状态指示器
        self.spinner = UIActivityIndicatorView(style:  .medium)
        self.spinner.color = .clear
        
    }
    
    //开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {
        //请求时在界面中央显示一个活动状态指示器
        viewController.view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    //收到请求
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        //移除界面中央的活动状态指示器
        spinner.removeFromSuperview()
        spinner.stopAnimating()
        
        //只有请求错误时会继续往下执行
        guard case let Result.failure(error) = result else { return }
        
        //弹出并显示错误信息
        var message = error.failureReason ?? "未知错误"
        log.error(error.failureReason ?? "")
        log.error(error.localizedDescription)
        switch error.errorCode {
        case 6:
            message = "该次请求超时...\n请您稍后再试"
        default:
            message = "远程服务异常"
        }
        let alertViewController = UIAlertController(title: "请求失败",
                                                    message: "\(message)",
            preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "确定", style: .default,
                                                    handler: nil))
        viewController.present(alertViewController, animated: true)
    }
}
