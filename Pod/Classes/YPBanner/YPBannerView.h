//
//  YPBannerView.h
//  YPBannerDemo
//
//  Created by yupao on 1/8/16.
//  Copyright © 2016 yupao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPBannerManager.h"
#define PLACEHOLDER [UIImage imageWithContentsOfFile:\
                                [[NSBundle bundleWithURL:[[NSBundle bundleForClass:[YPBannerView classForCoder]] URLForResource:@"YPBanner" withExtension:@"bundle"]]\
                                 pathForResource:@"placeholder" ofType:@"jpg"]\
                    ]

typedef NS_OPTIONS(NSInteger, YPBannerAnimationType) {
    YPBannerAnimationTypeFade = 0,
    YPBannerAnimationTypeMoveIn,
    YPBannerAnimationTypePush,
    YPBannerAnimationTypeReveal,
    YPBannerAnimationTypeCube,
    YPBannerAnimationTypeOglFlip,
    YPBannerAnimationTypeSuckEffect,
    YPBannerAnimationTypeRippleEffect,
    YPBannerAnimationTypePageCurl,
    YPBannerAnimationTypePageUnCurl
};

@protocol YPBannerViewDelegate <NSObject>
- (void)didTapOnBannerItem:(YPBannerItem *)item;
@end

@interface YPBannerView : UIView <YPBannerManagerDelegate>
@property (nonatomic, weak) id<YPBannerViewDelegate> delegate;
@property (nonatomic, assign) CGFloat scrollTimeInterval;
@property (nonatomic, strong) UIImage *placeholderImg;
- (instancetype)initWithFrame:(CGRect)frame
             andYPBannerItems:(NSArray<YPBannerItem *> *)itemArray;
- (instancetype)initWithFrame:(CGRect)frame
                YPBannerItems:(NSArray<YPBannerItem *> *)itemArray
                animationType:(YPBannerAnimationType)type
              andTimeDuration:(NSTimeInterval)duration;
- (void)addBannerItems:(NSArray<YPBannerItem *> *)itemArray;
- (void)resetBannerItems:(NSArray<YPBannerItem *> *)itemArray;
@end
