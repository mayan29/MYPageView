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



#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageView];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    }
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    CGFloat pageW = self.pageView.frame.size.width;
    CGFloat pageH = self.pageView.frame.size.height;
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(scrollW * self.imageNames.count, 0);
    
    if (CGRectEqualToRect(self.pageControlFrame, CGRectZero)) {
        self.pageView.frame = CGRectMake((scrollW - pageW) * 0.5, scrollH - pageH, pageW, pageH);
    } else {
        self.pageView.frame = self.pageControlFrame;
    }
    
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        
        UIImageView *imgView = self.scrollView.subviews[i];
        imgView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
    }
}


- (void)dealloc
{
    [self stopTimer];
}



#pragma mark - set


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



- (void)setPageCurrentImage:(UIImage *)pageCurrentImage
{
    _pageCurrentImage = pageCurrentImage;
    [self.pageView setValue:pageCurrentImage forKeyPath:@"currentPageImage"];
}
- (void)setPageOtherImage:(UIImage *)pageOtherImage
{
    _pageOtherImage = pageOtherImage;
    [self.pageView setValue:pageOtherImage forKeyPath:@"pageImage"];
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
    
    if (scrollTime <= 0) {
        
        NSLog(@"%s error : scrollTime不能小于或等于0", __PRETTY_FUNCTION__);
        return;
    }
    
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
    if (imageNum >= self.scrollView.subviews.count || imageNum < 0) {
        
        NSLog(@"%s error : 请输入正确的imageNum", __PRETTY_FUNCTION__);
        return;
    }
    
    UIImageView *imageView = self.scrollView.subviews[imageNum];
    view.frame = frame;
    [imageView addSubview:view];
}

- (void)addImageNames:(NSArray *)imageNames placeholder:(id)placeholder
{
    _imageNames = imageNames;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    for (id img in imageNames) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        
        if ([img isKindOfClass:[NSString class]]) {
            
            if ([UIImage imageNamed:img]) {
                imgView.image = [UIImage imageNamed:img];
            } else {
                
                if ([placeholder isKindOfClass:[NSString class]]) {
                    [imgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:placeholder]];
                } else if ([placeholder isKindOfClass:[UIImage class]]) {
                    [imgView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:placeholder];
                } else if (placeholder == nil) {
                    [imgView sd_setImageWithURL:[NSURL URLWithString:img]];
                } else {
                    NSLog(@"%s error : placeholder只能为NSString或UIImage格式", __PRETTY_FUNCTION__);
                    [imgView sd_setImageWithURL:[NSURL URLWithString:img]];
                } 
            }
   
        } else if ([img isKindOfClass:[UIImage class]]) {
            
            imgView.image = img;
        } else {
            NSLog(@"%s error : img只能为NSString或UIImage格式", __PRETTY_FUNCTION__);
        }
        
        imgView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:imgView];
    }
    self.pageView.numberOfPages = imageNames.count;
    [self.pageView sizeToFit];
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageView.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
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



#pragma mark - TapDelegate

- (void)tapClick:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(pageView:didSelectNum:)]) {
        [self.delegate pageView:self didSelectNum:self.pageView.currentPage];
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



#pragma mark - lazy

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


@end
