//
//  CALayer+MyColor.m
//  swiftTemplate
//
//  Created by tomcat on 2020/5/31.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//


#import "CALayer+MyColor.h"

@implementation CALayer (MyColor)

- (void)setBorderColorFromUIColor:(UIColor *)color{
        self.borderColor = color.CGColor;
    }
@end
