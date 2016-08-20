//
//  ViewController.m
//  MYPageView-master
//
//  Created by mayan on 16/8/20.
//  Copyright © 2016年 mayan. All rights reserved.
//

#import "ViewController.h"
#import "MYPageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *imageNames = @[@"pic0", @"pic1", @"pic2", @"pic3", @"pic4"];

    MYPageView *pageView = [MYPageView pageView];
    pageView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);
    pageView.scrollTime = 3;
    pageView.pageCurrentColor = [UIColor orangeColor];
    pageView.pageOtherColor = [UIColor blueColor];
    [pageView addImageNames:imageNames placeholderImageName:@"pic_placeholder" imageType:ImageOfLocal];
    
    [self.view addSubview:pageView];
}

@end
