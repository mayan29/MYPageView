# MYPageView
封装图片轮播图，支持定时轮播，点击交互，添加其他控件等功能



##### 添加图片名称数组

传入图片类型支持本地图片名称（NSString）、网络图片地址（NSString）和本地图片（UIImage）
占位图类型支持本地图片名称（NSString）和本地图片（UIImage）

``` objc
- (void)addImageNames:(NSArray *)imageNames placeholder:(id)placeholder;
```

##### 在指定图片上添加控件
``` ojbc
- (void)addView:(UIView *)view imageNum:(NSInteger)imageNum frame:(CGRect)frame;
```

##### 是否自动轮播和轮播时间
``` ojbc
@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) NSInteger scrollTime;
```

##### 设置pageControl颜色
``` ojbc
@property (nonatomic, strong) UIColor *pageCurrentColor;
@property (nonatomic, strong) UIColor *pageOtherColor;
```

##### 设置pageControl图片
``` ojbc
@property (nonatomic, copy) UIImage *pageCurrentImage;
@property (nonatomic, copy) UIImage *pageOtherImage;
```

##### 设置pageControl位置
``` ojbc
@property (nonatomic, assign) CGRect pageControlFrame;
```

##### 监听点击事件
``` ojbc
- (void)pageView:(MYPageView *)pageView didSelectNum:(NSInteger)num;
```
