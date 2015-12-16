# XYAdScrollView





//------2.添加到当前视图  adScrollView
    [self.view addSubview:self.adScrollView];
    
    self.array = [[NSMutableArray alloc] init];
    for (int i = 0; i< 5; i++) {
        XYAdModel *model = [[XYAdModel alloc] init];
        model.imageName = [NSString stringWithFormat:@"bg_ad_default_0%d",i+1];
        model.imageUrl = temp[i];
        model.title = [NSString stringWithFormat:@"这是第%d条广告",i+1];
        [self.array addObject:model];
    }
    
    //模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //------3.设置第二个轮播图的数据源 adScrollView
        self.adScrollView.modelArray = self.array;
    });
