# MYPageView
封装图片轮播图，支持定时轮播，点击跳转，添加其他控件等功能

##### 初始化
``` objc
+ (instancetype)pageView;
```

##### 添加图片名称数组
``` objc
- (void)addImageNames:(NSArray *)imageNames placeholderImageName:(NSString *)placeholderImageName imageType:(ImageType)imageType;
```

##### 在指定图片上添加控件
``` ojbc
- (void)addView:(UIView *)view imageNum:(NSInteger)imageNum frame:(CGRect)frame;
```

##### 是否自动轮播和轮播时间
```
@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) NSInteger scrollTime;
```

##### 设置pageControl颜色
```
@property (nonatomic, strong) UIColor *pageCurrentColor;
@property (nonatomic, strong) UIColor *pageOtherColor;
```

##### 设置pageControl图片
```
@property (nonatomic, copy) NSString *pageCurrentImageName;
@property (nonatomic, copy) NSString *pageOtherImageName;
```

##### 设置pageControl位置
```
@property (nonatomic, assign) CGRect pageControlFrame;
```
