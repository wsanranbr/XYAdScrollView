//
//  UIView+Extension.h
//  轮播图Demo
//
//  Created by Baolong Yan on 15/12/14.
//  Copyright © 2015年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CustomColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1]

#define RandomColor CustomColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface UIView (Extension)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@end
