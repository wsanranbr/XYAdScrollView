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
@property(nonatomic, strong) NSMutableArray *array;
@end

@implementation ViewController

- (XYAdScrollView *)adScrollView
{
    if (!_adScrollView) {
        self.adScrollView = [[XYAdScrollView alloc] init];
        [self.adScrollView setFrame:CGRectMake(0, 64, self.view.width, 240)];
        self.adScrollView.delegate = self;
        self.adScrollView.localizationImagesGroup = self.array;
        
        self.adScrollView.pageControlAliment = XYPageContolAlimentRight;
        
    }
    return _adScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationController.navigationBar.translucent = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//取消scroll的自动留白  iOS7以后
    self.title = @"轮播图";
    
    
    self.array = [[NSMutableArray alloc] init];
    for (int i = 0; i< 5; i++) {
        XYAdModel *model = [[XYAdModel alloc] init];
        model.imageName = [NSString stringWithFormat:@"bg_ad_default_0%d",i+1];
        model.imageUrl = @"";
        model.skipUrl = @"";
        model.title = [NSString stringWithFormat:@"这是第%d条广告",i+1];
        
        [self.array addObject:model];
    }
    
    [self.view addSubview:self.adScrollView];
    
}

- (void)adScrollView:(XYAdScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"%@", [scrollView.localizationImagesGroup objectAtIndex:index]);
    XYAdModel *model = [scrollView.localizationImagesGroup objectAtIndex:index];
    NSLog(@"%@, %@", model.imageName, model.title);
    NSLog(@"select %ld", index);
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController setHidesBottomBarWhenPushed:YES];
    viewController.view.backgroundColor = [UIColor lightGrayColor];
    viewController.title = model.title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
