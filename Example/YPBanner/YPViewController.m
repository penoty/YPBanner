//
//  YPViewController.m
//  YPBanner
//
//  Created by penoty on 04/13/2016.
//  Copyright (c) 2016 penoty. All rights reserved.
//
#import "YPViewController.h"

@interface YPViewController ()
@property (nonatomic, strong) YPBannerView *bannerView;
@end

@implementation YPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initBannerView];
}

- (void)initBannerView {
    YPBannerItem *item_01 = [[YPBannerItem alloc] initWithImage:[UIImage imageNamed:@"placehold.png"] data:nil];
    YPBannerItem *item_02 = [[YPBannerItem alloc] initWithUrl:@"http://img2.3lian.com/img2007/19/33/005.jpg" data:nil andPlaceholder:[UIImage imageNamed:@"placehold.png"]];
    YPBannerItem *item_03 = [[YPBannerItem alloc] initWithUrl:@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg" data:nil andPlaceholder:[UIImage imageNamed:@"placehold.png"]];
    //不设置动画，使用默认动画
    _bannerView = [[YPBannerView alloc] initWithFrame:self.view.bounds andYPBannerItems:@[item_01,item_02,item_03]];
    //设置动画
    //    _bannerView= [[YPBannerView alloc] initWithFrame:_frameView.bounds YPBannerItems:@[item_01,item_02,item_03] animationType:YPBannerAnimationTypePageCurl andTimeDuration:1.5f];
    [self.view addSubview:_bannerView];
    [_bannerView setDelegate:(id<YPBannerViewDelegate> _Nullable)self];
    [self.view bringSubviewToFront:_bannerView];
}

- (void)didTapOnBannerItem:(YPBannerItem *)item {
    NSLog(@"%@",item);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
