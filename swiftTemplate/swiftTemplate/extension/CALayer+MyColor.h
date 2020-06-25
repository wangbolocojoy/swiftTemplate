//
//  CALayer+MyColor.h
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CALayer (MyColor)

 - (void)setBorderColorFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
