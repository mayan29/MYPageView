//
//  MYPageView.m
//  MYPageView
//
//  Created by mayan on 16/8/20.
//  Copyright © 2016年 mayan. All rights reserved.
//

#import "MYPageView.h"
#import "UIImageView+WebCache.h"

@interface MYPageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSArray *imageNames;

@end


@implementation MYPageView



#pragma mark - Initialization

+ (instancetype)pageView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageView];
    }
    return self;
}



- (void)setPageCurrentColor:(UIColor *)pageCurrentColor
{
    _pageCurrentColor = pageCurrentColor;
    self.pageView.currentPageIndicatorTintColor = pageCurrentColor;
}
- (void)setPageOtherColor:(UIColor *)pageOtherColor
{
    _pageOtherColor = pageOtherColor;
    self.pageView.pageIndicatorTintColor = pageOtherColor;
}



- (void)setPageCurrentImageName:(NSString *)pageCurrentImageName
{
    _pageCurrentImageName = pageCurrentImageName;
    [self.pageView setValue:[UIImage imageNamed:pageCurrentImageName] forKeyPath:@"currentPageImage"];
}
- (void)setPageOtherImageName:(NSString *)pageOtherImageName
{
    _pageOtherImageName = pageOtherImageName;
    [self.pageView setValue:[UIImage imageNamed:pageOtherImageName] forKeyPath:@"pageImage"];
}



- (void)setIsAutoScroll:(BOOL)isAutoScroll
{
    _isAutoScroll = isAutoScroll;
    
    if (isAutoScroll) {
        
        if (self.timer) {
            [self stopTimer];
        }
        [self startTimer];
    }
}

- (void)setScrollTime:(NSInteger)scrollTime
{
    _scrollTime = scrollTime;
    
    self.isAutoScroll = YES;
}



- (void)setDelegate:(id<MYPageViewDelegate>)delegate
{
    _delegate = delegate;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}



- (void)addView:(UIView *)view imageNum:(NSInteger)imageNum frame:(CGRect)frame
{
    if (imageNum >= self.scrollView.subviews.count) return;
    
    UIImageView *imageView = self.scrollView.subviews[imageNum];
    view.frame = frame;
    [imageView addSubview:view];
}

- (void)addImageNames:(NSArray *)imageNames placeholderImageName:(NSString *)placeholderImageName imageType:(ImageType)imageType
{
    _imageNames = imageNames;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (NSString *imgName in imageNames) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        
        if (imageType == ImageOfLocal) {
            
            imgView.image = [UIImage imageNamed:imgName];
        } else if (imageType == ImageOfNetwork) {
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:placeholderImageName]];
        }
        
        imgView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:imgView];
    }
    self.pageView.numberOfPages = imageNames.count;
    [self.pageView sizeToFit];
}



#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([NSStringFromCGRect(self.frame) isEqualToString:@"{{0, 0}, {0, 0}}"]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    }
    
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat scrollH = self.scrollView.frame.size.height;
    CGFloat pageW = self.pageView.frame.size.width;
    CGFloat pageH = self.pageView.frame.size.height;
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(scrollW * self.imageNames.count, 0);
    
    if ([NSStringFromCGRect(self.pageControlFrame) isEqualToString:@"{{0, 0}, {0, 0}}"]) {
        self.pageView.frame = CGRectMake((scrollW - pageW) * 0.5, scrollH - pageH, pageW, pageH);
    } else {
        self.pageView.frame = self.pageControlFrame;
    }
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        
        UIImageView *imgView = self.scrollView.subviews[i];
        imgView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageView.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoScroll) {
        [self stopTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoScroll) {
        [self startTimer];
    }
}



#pragma mark - TimerControl

- (void)startTimer
{
    NSInteger time = (self.scrollTime == 0) ? 2 : self.scrollTime;
    self.timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextPage
{
    NSInteger page = self.pageView.currentPage + 1;
    if (page == self.pageView.numberOfPages) {
        page = 0;
    }
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = page * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}



#pragma mark - TapDelegate

- (void)tapClick:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectNum:)]) {
        [self.delegate pageView:self didSelectNum:self.pageView.currentPage];
    }
}



#pragma mark - LazyLoad

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageView
{
    if (!_pageView) {
        _pageView = [[UIPageControl alloc] init];
    }
    return _pageView;
}



#pragma mark - Other

- (void)dealloc
{
    [self stopTimer];
}


@end
