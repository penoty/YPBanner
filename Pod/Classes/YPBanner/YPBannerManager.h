//
//  YPBannerManager.h
//  YPBannerDemo
//
//  Created by yupao on 12/25/15.
//  Copyright © 2015 yupao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBannerItem.h"
@class YPBannerManager;
@protocol YPBannerManagerDelegate<NSObject>
@required
- (void)YPBannerManager:(YPBannerManager *)manager addItem:(YPBannerItem *)item;
@optional
- (void)YPBannerManager:(YPBannerManager *)manager deleteItem:(YPBannerItem *)item;
- (void)YPBannerManager:(YPBannerManager *)manager removeAllItemsWithPlacehold:(UIImage *)placehold;
@end

@interface YPBannerManager : NSObject
@property (nonatomic, weak) id<YPBannerManagerDelegate> delegate;
@property (nonatomic, assign) NSInteger countOfItems;
- (void)addItem:(YPBannerItem *)item;
- (void)addItems:(NSArray <YPBannerItem *> *)itemArray;
- (void)deleteItem:(YPBannerItem *)item;
- (void)removeAllItems;
- (YPBannerItem *)itemAtIndex:(NSInteger)index;
@end
