//
//  RainbowRing.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/7/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import Foundation
@IBDesignable class RainbowRing: UIView, CAAnimationDelegate {
    //每次动画变化的时长
    let duration = 0.1
    var contentView :UIView!
    //圆环宽度
    let ringWidth:CGFloat = 2
    //渐变层
    var gradientLayer: CAGradientLayer!
    @IBOutlet weak var imageview: UIImageView!
    //遮罩层
    var maskLayer:CAShapeLayer!
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    //设置好xib视图约束
    func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView!, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView!, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView!, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }
    
    
    //初始化时将xib中的view添加进来
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //初始化属性配置
        initview()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView = loadViewFromNib()
        addSubview(contentView)
        addConstraints()
        //创建彩虹渐变层
        initview()
    }
    
    func  initview(){
        self.backgroundColor = .clear
        gradientLayer =  CAGradientLayer()
              gradientLayer.frame = bounds
              gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
              gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
              //设置渐变层的颜色
              var rainBowColors:[CGColor] = []
              var hue:CGFloat = 0
              while hue <= 360 {
                  let color = UIColor(hue: 1.0*hue/360.0, saturation: 1.0, brightness: 1.0,
                                      alpha: 1.0)
                  rainBowColors.append(color.cgColor)
                let vad = CGFloat(arc4random() % 15)
                hue += vad
              }
              gradientLayer.colors = rainBowColors
              imageview.layer.cornerRadius = self.bounds.width/2
              //添加渐变层
              self.layer.addSublayer(gradientLayer)
              //创建遮罩层（使用贝塞尔曲线绘制）
              maskLayer = CAShapeLayer()
              maskLayer.path = UIBezierPath(ovalIn:
                  bounds.insetBy(dx: ringWidth/2, dy: ringWidth/2)).cgPath
              maskLayer.strokeColor = UIColor.gray.cgColor
              maskLayer.fillColor = UIColor.clear.cgColor
              maskLayer.lineWidth = ringWidth
              //设置遮罩
              gradientLayer.mask = maskLayer
              //开始播放动画
              performAnimation()
    }
    func setimage(url:String){
        imageview.setImageUrl(image: imageview, string: url, proimage: #imageLiteral(resourceName: "IMG_2506"))
    }
    //动画播放结束后的响应
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //继续播放动画
        performAnimation()
    }
    
    //执行动画
    func performAnimation() {
        //更新渐变层的颜色
        let fromColors = gradientLayer.colors as! [CGColor]
        let toColors = self.shiftColors(colors: fromColors)
        gradientLayer.colors = toColors
        //创建动画实现渐变颜色从左上向右下移动的效果
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration =  duration
        animation.fromValue = fromColors
        animation.toValue = toColors
        //动画完成后是否要移除
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.linear)
        animation.delegate = self
        //将动画添加到图层中
        gradientLayer.add(animation, forKey: "colors")
    }
    
    //将颜色数组中的最后一个元素移到数组的最前面
    func shiftColors(colors:[CGColor]) -> [CGColor] {
        //复制一个数组
        var newColors: [CGColor] = colors.map{($0.copy()!) }
        //获取最后一个元素
        let last: CGColor = newColors.last!
        //将最后一个元素删除
        newColors.removeLast()
        //将最后一个元素插入到头部
        newColors.insert(last, at: 0)
        //返回新的颜色数组
        return newColors
    }
}
/**
 单精度的随机数
 */
public extension Float {
    static func randomFloatNumber(lower: Float = 0,upper: Float = 100) -> Float {
        return (Float(arc4random()) / Float(UInt32.max)) * (upper - lower) + lower
    }
}
