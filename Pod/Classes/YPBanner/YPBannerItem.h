//
//  YPBannerItem.h
//  YPBannerDemo
//
//  Created by yupao on 12/25/15.
//  Copyright © 2015 yupao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YPBannerItem : NSObject

@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong, readonly) NSString *itemImgUrl;
@property (nonatomic, strong) UIImage *itemImg;
@property (nonatomic, strong, readonly) NSDictionary *itemData;


- (instancetype)initWithImage:(UIImage *)img
                         data:(NSDictionary *)data;
- (instancetype)initWithUrl:(NSString *)url
                       data:(NSDictionary *)data
             andPlaceholder:(UIImage *)placeholder;

@end
