//
//  YPViewController.m
//  YPBanner
//
//  Created by penoty on 04/13/2016.
//  Copyright (c) 2016 penoty. All rights reserved.
//
#import "YPViewController.h"
#import "Masonry.h"
#define PLACEHOLDER [UIImage imageNamed:@"placeholder.jpg"]

@interface YPViewController ()
@property (nonatomic, strong) YPBannerView *bannerView;
@property (nonatomic, strong) UIButton *addItemBtn;
@property (nonatomic, strong) UIButton *deleteItemBtn;
@end

@implementation YPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self initBannerViewWithFrame];
    [self initBannerViewWithMasonry];
    [self initFuncBtns];
}

- (void)dealloc {
    NSLog(@"YPViewController dealloc");
}

- (void)initBannerViewWithFrame {
    CGRect frame = self.view.bounds;
    YPBannerItem *item_01 = [[YPBannerItem alloc] initWithImage:PLACEHOLDER data:nil];
    YPBannerItem *item_02 = [[YPBannerItem alloc] initWithUrl:@"http://img2.3lian.com/img2007/19/33/005.jpg"
                                                         data:nil
                                               andPlaceholder:PLACEHOLDER];
    YPBannerItem *item_03 = [[YPBannerItem alloc] initWithUrl:@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg"
                                                         data:nil
                                               andPlaceholder:PLACEHOLDER];
    
    //YPBannerView init method
    _bannerView = [[YPBannerView alloc] initWithYPBannerItems:@[item_01,item_02,item_03]];
    //YPBannerView init method with animation setting
    //    _bannerView = [[YPBannerView alloc] initWithYPBannerItems:@[item_01,item_02,item_03]
    //                                                animationType:YPBannerAnimationTypeCube
    //                                              andTimeDuration:1.5f];
    [_bannerView setScrollTimeInterval:2.0f];
    [_bannerView setPageIndicatorColor:[UIColor blackColor] andCurrentPageIndicatorColor:[UIColor whiteColor]];
    //set the animation type and duration
    //[_bannerView setAnimationType:YPBannerAnimationTypeCube andAnimationDuration:0.7f];
    [self.view addSubview:_bannerView];
    [_bannerView setDelegate:(id<YPBannerViewDelegate> _Nullable)self];

    //use frame
    [_bannerView setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*0.5)];
}

- (void)initBannerViewWithMasonry {
    YPBannerItem *item_01 = [[YPBannerItem alloc] initWithImage:PLACEHOLDER data:nil];
    YPBannerItem *item_02 = [[YPBannerItem alloc] initWithUrl:@"http://img2.3lian.com/img2007/19/33/005.jpg"
                                                         data:nil
                                               andPlaceholder:PLACEHOLDER];
    YPBannerItem *item_03 = [[YPBannerItem alloc] initWithUrl:@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg"
                                                         data:nil
                                               andPlaceholder:PLACEHOLDER];
    
    //YPBannerView init method
    _bannerView = [[YPBannerView alloc] initWithYPBannerItems:@[item_01,item_02,item_03]];
    //YPBannerView init method with animation setting
    //    _bannerView = [[YPBannerView alloc] initWithYPBannerItems:@[item_01,item_02,item_03]
    //                                                animationType:YPBannerAnimationTypeCube
    //                                              andTimeDuration:1.5f];
    [_bannerView setScrollTimeInterval:2.0f];
    [_bannerView setPageIndicatorColor:[UIColor blackColor] andCurrentPageIndicatorColor:[UIColor whiteColor]];
    //set the animation type and duration
    //[_bannerView setAnimationType:YPBannerAnimationTypeCube andAnimationDuration:0.7f];
    
    [self.view addSubview:_bannerView];
    [_bannerView setDelegate:(id<YPBannerViewDelegate> _Nullable)self];
    
    //use masonry
    [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
}

- (void)initFuncBtns {
    _addItemBtn = [[UIButton alloc] init];
    [_addItemBtn setBackgroundColor:[UIColor whiteColor]];
    [_addItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addItemBtn setTitle:@"Add" forState:UIControlStateNormal];
    [_addItemBtn addTarget:self  action:@selector(addItemToBanner:) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteItemBtn = [[UIButton alloc] init];
    [_deleteItemBtn setBackgroundColor:[UIColor whiteColor]];
    [_deleteItemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_deleteItemBtn setTitle:@"Reset" forState:UIControlStateNormal];
    [_deleteItemBtn addTarget:self  action:@selector(resetItemToBanner:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addItemBtn];
    [self.view addSubview:_deleteItemBtn];
    [self layoutFuncBtns];
}

- (void)layoutFuncBtns {
    [_addItemBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.equalTo(self.view);
        make.width.and.height.equalTo(self.view).multipliedBy(0.5);
    }];
    
    [_deleteItemBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(self.view);
        make.width.and.height.equalTo(self.view).multipliedBy(0.5);
    }];
    
    [self.view layoutIfNeeded];
}

- (void)didTapOnBannerItem:(YPBannerItem *)item {
    NSLog(@"%@",item);
}

- (void)addItemToBanner:(UIButton *)sender {
    YPBannerItem *item_03 = [[YPBannerItem alloc] initWithUrl:@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg" data:nil andPlaceholder:PLACEHOLDER];
    [_bannerView addBannerItems:@[item_03]];
}

- (void)resetItemToBanner:(UIButton *)sender {
    YPBannerItem *item_03 = [[YPBannerItem alloc] initWithUrl:@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg" data:nil andPlaceholder:PLACEHOLDER];
    [_bannerView resetBannerItems:@[item_03]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
