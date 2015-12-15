//
//  XYAdScrollView.h
//  轮播图Demo
//
//  Created by Baolong Yan on 15/12/14.
//  Copyright © 2015年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYAdModel;
@class XYAdScrollView;

@protocol XYAdDelegate <NSObject>

- (void)adScrollView:(XYAdScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end

typedef enum {
    XYPageContolAlimentNone,
    XYPageContolAlimentLeft,
    XYPageContolAlimentRight,
    XYPageContolAlimentCenter
} XYPageContolAliment;

typedef enum {
    XYPageContolStyleClassic,        // 系统自带经典样式
    XYPageContolStyleAnimated,       // 动画效果pagecontrol
    XYPageContolStyleNone            // 不显示pagecontrol
} XYPageContolStyle;

typedef enum
{
    XYTitleAlimentNone,
    XYTitleAlimentLeft,
    XYTitleAlimentCenter,
    XYTitleAlimentRight,
} XYTitleAliment;

@interface XYAdScrollView : UIView

// 是否自动滚动,默认Yes
@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;

//滚动间隔时间
@property (nonatomic, assign) CGFloat scrollTimeInterval;

//pagecontrol布局样式，默认为居中显示
@property (nonatomic, assign) XYPageContolAliment pageControlAliment;

//pagecontrol样式，默认为动画样式
@property (nonatomic, assign) XYPageContolStyle pageContolStyle;

//文字布局样式，默认为左边显示
@property (nonatomic, assign) XYTitleAliment titleAliment;

//占位图，用于网络未加载到图片时
@property (nonatomic, strong) NSString *placeholderImageName;

//数据源
@property(nonatomic, strong) NSArray *localizationImagesGroup;

//文字颜色
@property (nonatomic, strong) UIColor *titleColor;

//文字背景
@property (nonatomic, strong) UIColor *titleBackgroundColor;

//文字字体
@property (nonatomic, strong) UIFont  *titleFont;

//代理
@property (nonatomic, weak) id <XYAdDelegate> delegate;




@end
