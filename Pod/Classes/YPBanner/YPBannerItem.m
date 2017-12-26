//
//  YPBannerItem.m
//  YPBannerDemo
//
//  Created by yupao on 12/25/15.
//  Copyright © 2015 yupao. All rights reserved.
//

#import "YPBannerItem.h"
@interface YPBannerItem (){
    
}
@end

@implementation YPBannerItem

- (instancetype)initWithImage:(UIImage *)img data:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _itemImg = img;
        _itemImgUrl = nil;
        _itemData = data;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url
                       data:(NSDictionary *)data
             andPlaceholder:(UIImage *)placeholder{
    self = [super init];
    if (self) {
        _itemImgUrl = url;
        _itemData = data;
        _itemImg = placeholder;
    }
    return self;
}

@end
