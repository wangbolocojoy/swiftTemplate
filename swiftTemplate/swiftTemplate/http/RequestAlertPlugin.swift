//
//  RequestAlertPlugin.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 波王. All rights reserved.
//

import Foundation
import Moya
import Result


final class RequestAlertPlugin: PluginType {
    
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
        self.spinner = UIActivityIndicatorView(style:  .white)
        self.spinner.color = .white
        self.spinner.center = CGPoint(x: viewController.view.bounds.width/2, y: viewController.view.bounds.height/2)
        self.vcBank = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: viewController.view.bounds.height))
        self.vcBank.backgroundColor = .clear
        self.spbank = UIView(frame: CGRect(x: viewController.view.bounds.maxX/2-40, y: viewController.view.bounds.maxY/2-40, width: 80, height: 80))
        self.spbank.backgroundColor = #colorLiteral(red: 0.3135129511, green: 0.3116548359, blue: 0.3149448037, alpha: 0.3621842894)
        self.spbank.layer.cornerRadius = 8
        self.spbank.addSubview(self.spinner)
        self.vcBank.addSubview(self.spbank)
        
    }
    
    //开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {
        //请求时在界面中央显示一个活动状态指示器
        viewController.view.addSubview(vcBank)
        spinner.startAnimating()
    }
    
    //收到请求
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        //移除界面中央的活动状态指示器
        vcBank.removeFromSuperview()
        spinner.stopAnimating()
        
        //只有请求错误时会继续往下执行
        guard case let Result.failure(error) = result else { return }
        
        //弹出并显示错误信息
        var message = error.failureReason ?? "未知错误"
        log.debug(error.errorCode)

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
