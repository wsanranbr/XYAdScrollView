//
//  ViewController.m
//  轮播图Demo
//
//  Created by Baolong Yan on 15/12/14.
//  Copyright © 2015年 XY. All rights reserved.
//

#import "ViewController.h"

#import "XYAdScrollView.h"
#import "XYAdModel.h"
#import "UIView+Extension.h"

@interface ViewController ()<XYAdDelegate>

@property(nonatomic, strong) XYAdScrollView *adScrollView;
@property(nonatomic, strong) XYAdScrollView *adScrollView2;
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (XYAdScrollView *)adScrollView
{
    //------1.初始化控件
    if (!_adScrollView) {
        self.adScrollView = [[XYAdScrollView alloc] init];
        [self.adScrollView setFrame:CGRectMake(0, 64, self.view.width, 200)];
        self.adScrollView.delegate = self;
        self.adScrollView.placeholderImageName = @"bg_ad_default";
        self.adScrollView.adScrollViewStyle = XYAdScrollViewStyleRemote;//使用网络图片
        self.adScrollView.pageControlAliment = XYPageContolAlimentCenter;
        self.adScrollView.titleAliment = XYTitleAlimentNone;
        
    }
    return _adScrollView;
}

- (XYAdScrollView *)adScrollView2
{
    //------1.初始化控件 - (XYAdScrollView *)adScrollView2
    if (!_adScrollView2) {
        self.adScrollView2 = [[XYAdScrollView alloc] init];
        [self.adScrollView2 setFrame:CGRectMake(0, 64+200+20, self.view.width, 200)];
        self.adScrollView2.delegate = self;
        self.adScrollView2.placeholderImageName = @"bg_ad_default";
        self.adScrollView2.adScrollViewStyle = XYAdScrollViewStyleLocal;//使用本地图片
        self.adScrollView2.pageControlAliment = XYPageContolAlimentRight;
        self.adScrollView2.titleAliment = XYTitleAlimentLeft;
//        self.adScrollView2.autoScroll = NO;
    }
    return _adScrollView2;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;//取消scroll的自动留白  iOS7以后
    self.title = @"轮播图";
    self.view.backgroundColor = CustomColor(200, 200, 200);
    
    NSArray *temp = @[@"http://sinastorage.com/storage.zone.photo.sina.com.cn/zone/1000_0/20151216/5a38f201e23600a8c41538fe1d6010dd_3616_2279.jpg?&ssig=3oFPbUJ4aN&KID=sina,slidenews&Expires=1450263682",
                      @"http://sinastorage.com/storage.zone.photo.sina.com.cn/zone/1000_0/20151214/a8e5bb0e22594a2b8799c6f0cce9e019_5616_3744.jpg?&ssig=FUotR79snJ&KID=sina,slidenews&Expires=1450257382",
                      @"http://n.sinaimg.cn/news/transform/20151216/2jFO-fxmpxnx5203658.jpg",
                      @"http://sinastorage.com/storage.zone.photo.sina.com.cn/zone/1000_0/20151214/e0c67e0e17e8a4c688300b39a3fc6cbc_1024_682.jpg?&ssig=qLI%2Bx3CxHT&KID=sina,slidenews&Expires=1450257537",
                      @"http://www.sinaimg.cn/dy/slidenews/5_img/2015_47/30939_1297424_727600.jpg"];
    
    self.array = [[NSMutableArray alloc] init];
    for (int i = 0; i< 5; i++) {
        XYAdModel *model = [[XYAdModel alloc] init];
        model.imageName = [NSString stringWithFormat:@"bg_ad_default_0%d",i+1];
        model.imageUrl = temp[i];
        model.title = [NSString stringWithFormat:@"这是第%d条广告",i+1];
        [self.array addObject:model];
    }
    
    //------2.添加到当前视图  adScrollView
    [self.view addSubview:self.adScrollView];

    //模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //------3.设置第二个轮播图的数据源 adScrollView
        self.adScrollView.modelArray = self.array;
    });
    
    //------2.设置第二个轮播图的数据源 adScrollView2
    self.adScrollView2.modelArray = self.array;
    //------3.添加到当前视图上 adScrollView2
    [self.view addSubview:self.adScrollView2];
}

/**
 *  轮播图代理事件
 *
 *  @param scrollView
 *  @param index      点击的索引
 */
- (void)adScrollView:(XYAdScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index
{
    XYAdModel *model = [scrollView.modelArray objectAtIndex:index];
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController setHidesBottomBarWhenPushed:YES];
    viewController.view.backgroundColor = [UIColor lightGrayColor];
    viewController.title = model.title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
