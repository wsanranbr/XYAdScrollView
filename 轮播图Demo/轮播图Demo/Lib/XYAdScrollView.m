//
//  XYAdScrollView.m
//  轮播图Demo
//
//  Created by Baolong Yan on 15/12/14.
//  Copyright © 2015年 XY. All rights reserved.
//

#import "XYAdScrollView.h"
#import "UIView+Extension.h"
#import "XYAdModel.h"

@interface XYAdScrollView ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    BOOL _isTimeUp;
}

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;        //翻页
@property(nonatomic, assign) NSInteger number;      //总个数
@property(nonatomic, assign) NSInteger index;       //当前
@property(nonatomic, strong) NSTimer *timer;        //计时器

@end

@implementation XYAdScrollView

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.x = 0;
        self.scrollView.y = 0;
        self.scrollView.width = self.width;
        self.scrollView.height = self.height;
        self.scrollView.pagingEnabled = YES;        //分页显示
        self.scrollView.showsHorizontalScrollIndicator = NO;    //禁用水平滚动条
        self.scrollView.showsVerticalScrollIndicator = NO;  //禁用垂直滚动条
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.scrollView.backgroundColor = [UIColor blueColor];
        self.scrollTimeInterval = 2.0f;  //默认滚动时间为2秒
        self.autoScroll = YES;  //默认自动滚动
        self.titleAliment = XYTitleAlimentLeft;
        self.pageControlAliment = XYPageContolAlimentRight;
        self.titleBackgroundColor = [UIColor clearColor];
        self.titleColor = CustomColor(255, 255, 255);
        NSLog(@"self.height---> %f", self.height);
        
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.width = self.width;
        pageControl.height = 40;
        pageControl.y = self.height -30;
        pageControl.pageIndicatorTintColor = CustomColor(123, 123, 123);
        pageControl.currentPageIndicatorTintColor = CustomColor(255, 255, 255);
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return _pageControl;
}

- (void)setScrollTimeInterval:(CGFloat)scrollTimeInterval
{
    _scrollTimeInterval = scrollTimeInterval;
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
}

- (void)setTitleAliment:(XYTitleAliment)titleAliment
{
    _titleAliment = titleAliment;
}

- (void)setPageControlAliment:(XYPageContolAliment)pageControlAliment
{
    _pageControlAliment = pageControlAliment;
}

- (NSTimer *)timer
{
    if (!_timer) {
//        self.timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)scrollToNext
{
    NSLog(@"scrollToNext");
    
    //判断当前视图是否可见
    if (self.window) {
        NSLog(@"isViewLoaded, self.window--->%@", self.window);
    }
    else
    {
        NSLog(@"self.viewController is invisiable");
        return ;
    }
    
    NSInteger currentPage = self.pageControl.currentPage;
    currentPage += 1;
    CGFloat curOffset = self.scrollView.width * (currentPage+1);
    [self.scrollView setContentOffset:CGPointMake(curOffset, self.scrollView.contentOffset.y) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self.scrollView];
    });
    
    
    
}

#pragma mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollW = scrollView.width;
    int currentPage = (int) (scrollView.contentOffset.x/scrollW + 0.5);
    self.index = currentPage;
    if (currentPage < self.number) {
        currentPage--;
    }
    else if (currentPage == self.number+1)
    {
        currentPage = 0;
    }
    
    self.pageControl.currentPage = currentPage;
}

//结束后调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat maxW = self.scrollView.width;
    if (self.index == self.number+1)
    {
        self.scrollView.contentOffset = CGPointMake(maxW, 0);
    }
    else if (self.index == 0)
    {
        self.scrollView.contentOffset = CGPointMake(maxW *self.number, 0);
    }
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.scrollTimeInterval]];
}
//事件开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    
    if (self.autoScroll && self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]]; //给一个无限长的时间,达到timer暂停的效果
    }
}

/**
 *  设置数据源
 *
 *  @param localizationImagesGroup <#localizationImagesGroup description#>
 */
- (void)setLocalizationImagesGroup:(NSArray *)localizationImagesGroup
{
    _localizationImagesGroup = localizationImagesGroup;
    self.number = localizationImagesGroup.count;
    
    for (id da in localizationImagesGroup) {
        if ([da isKindOfClass:[XYAdModel class]]) {
            NSLog(@"da--->%@", da);
        }
    }
    
    //self.scrollView.frame = self.bounds;
    self.scrollView.backgroundColor = CustomColor(255, 0, 0);
    
    //设置scrollView的页数，N+2个，用于循环
    self.scrollView.contentSize = CGSizeMake(self.width*(self.number+2), self.height);
    
    //设置pageController的个数
    if (self.pageControlAliment != XYPageContolAlimentNone) {
       self.pageControl.numberOfPages = self.number;
        if (self.pageControlAliment == XYPageContolAlimentLeft) {
            self.pageControl.x = 0;
            self.pageControl.width = self.width/4;
        }
        else if (self.pageControlAliment == XYPageContolAlimentRight) {
            self.pageControl.x = self.width*3/4;
            self.pageControl.width = self.width/4;
        }
    }
    
    //添加视图
    [self addImageView];
    
    //设置显示第一张图片
    [self.scrollView setContentOffset:CGPointMake(self.width, 0)];
    
    //如设置自动滚动，启动定时器
    if (self.autoScroll) {
        if (![self.timer isValid]) {
            [self.timer fire];
        }
    }
}

- (void)addImageView
{
    if (_localizationImagesGroup.count > 0)
    {
        CGFloat scrollW = self.scrollView.frame.size.width;
        CGFloat scrollH = self.scrollView.frame.size.height;
        
        //设置N+2张imageView，用于首尾循环
        for (int i = 0; i < self.number+2; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES; //允许接收交互信息
            
            //图片上添加点击事件
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleSingleFingerEvent:)];
            
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            singleFingerOne.delegate = self;
            [imageView addGestureRecognizer:singleFingerOne];
            
            XYAdModel *model;
            
            imageView.width = scrollW;
            imageView.height = scrollH;
            imageView.x = i*scrollW;
            imageView.y = 0;
            
            if (i == 0)
            {
                model = [self.localizationImagesGroup objectAtIndex:self.number-1];
            }
            else if (i == self.number+1)
            {
                model = [self.localizationImagesGroup objectAtIndex:0];
            }
            else
            {
                model = [self.localizationImagesGroup objectAtIndex:(i-1)];
            }
            
            NSString *name = model.imageName;
            imageView.image = [UIImage imageNamed:name];
            [self.scrollView addSubview:imageView];
            
            
            //        self.titleLabel.frame = CGRectMake(self.width/6, self.height*85/100, self.width*2/3, self.height*1/10);
            
            if (self.titleAliment != XYTitleAlimentNone) {
                
                UILabel *titleLabel;
                titleLabel = [[UILabel alloc] init];
                titleLabel.backgroundColor = self.titleBackgroundColor;
                titleLabel.font = self.titleFont;;
                titleLabel.textColor = self.titleColor;
                
                titleLabel.x = self.width*1/8;
                titleLabel.y = self.height*4/5;
                titleLabel.width = self.width*6/8;
                titleLabel.height = self.height/5;
                
                if (self.titleAliment == XYTitleAlimentLeft) {
                    titleLabel.textAlignment = NSTextAlignmentLeft;
                }
                else if (self.titleAliment == XYTitleAlimentRight) {
                    titleLabel.textAlignment = NSTextAlignmentRight;

                }
                else if (self.titleAliment == XYTitleAlimentCenter) {
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                }
                
                titleLabel.text = model.title;
                [imageView addSubview:titleLabel];
            }
            
        }
    }
}

/**
 *  处理手指点击事件
 *
 *  @param sender 手势事件
 */
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    //调用代理
    if ([self.delegate respondsToSelector:@selector(adScrollView:didSelectItemAtIndex:)])
    {
        [self.delegate adScrollView:self didSelectItemAtIndex:(self.index - 1)%self.number];
    }
    
}




@end
