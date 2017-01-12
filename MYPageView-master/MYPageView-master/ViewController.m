//
//  ViewController.m
//  MYPageView-master
//
//  Created by mayan on 16/8/20.
//  Copyright © 2016年 mayan. All rights reserved.
//

#import "ViewController.h"
#import "MYPageView.h"

@interface ViewController () <MYPageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageNames = @[@"pic0", @"pic1", @"pic2", @"pic3", @"pic4"];

    
    MYPageView *pageView = [[MYPageView alloc] init];
    pageView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);
    pageView.delegate = self;
    pageView.scrollTime = 3;
    pageView.pageCurrentColor = [UIColor orangeColor];
    pageView.pageOtherColor = [UIColor blueColor];
    [pageView addImageNames:imageNames placeholder:@"pic_placeholder"];
    
    [self.view addSubview:pageView];
}

- (void)pageView:(MYPageView *)pageView didSelectNum:(NSInteger)num
{
    NSLog(@"点击了第 %ld 幅图",num);
}

@end
