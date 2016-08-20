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

typedef NS_ENUM(NSInteger, ImageType) {
    ImageOfLocal,
    ImageOfNetwork,
};

@property (nonatomic, weak) id<MYPageViewDelegate> delegate;



+ (instancetype)pageView;


- (void)addImageNames:(NSArray *)imageNames placeholderImageName:(NSString *)placeholderImageName imageType:(ImageType)imageType;
- (void)addView:(UIView *)view imageNum:(NSInteger)imageNum frame:(CGRect)frame;


@property (nonatomic, assign) BOOL isAutoScroll;
@property (nonatomic, assign) NSInteger scrollTime;


@property (nonatomic, strong) UIColor *pageCurrentColor;
@property (nonatomic, strong) UIColor *pageOtherColor;

@property (nonatomic, copy) NSString *pageCurrentImageName;
@property (nonatomic, copy) NSString *pageOtherImageName;

@property (nonatomic, assign) CGRect pageControlFrame;


@end
