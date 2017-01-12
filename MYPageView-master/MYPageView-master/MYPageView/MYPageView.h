//
//  MYPageView.h
//  MYPageView
//
//  Created by mayan on 16/8/20.
//  Copyright © 2016年 mayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYPageView;
@protocol MYPageViewDelegate <NSObject>

- (void)pageView:(MYPageView *)pageView didSelectNum:(NSInteger)num;

@end


@interface MYPageView : UIView


@property (nonatomic, weak) id<MYPageViewDelegate> delegate;



- (void)addImageNames:(NSArray *)imageNames placeholder:(id)placeholder;
- (void)addView:(UIView *)view imageNum:(NSInteger)imageNum frame:(CGRect)frame;


@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) NSInteger scrollTime;


@property (nonatomic, strong) UIColor *pageCurrentColor;
@property (nonatomic, strong) UIColor *pageOtherColor;

@property (nonatomic, copy) UIImage *pageCurrentImage;
@property (nonatomic, copy) UIImage *pageOtherImage;

@property (nonatomic, assign) CGRect pageControlFrame;


@end
