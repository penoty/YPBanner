//
//  YPBannerManager.m
//  YPBannerDemo
//
//  Created by yupao on 12/25/15.
//  Copyright © 2015 yupao. All rights reserved.
//

#import "YPBannerManager.h"
#import "SDWebImageManager.h"

@interface YPBannerManager(){
    
}

@property (nonatomic, strong) NSMutableArray *itemQueue;
@property (nonatomic, strong) SDWebImageManager *imageManager;

@end

@implementation YPBannerManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemQueue = [[NSMutableArray alloc] init];
        _countOfItems = _itemQueue.count;
    }
    return self;
}

- (void)addItems:(NSArray<YPBannerItem *> *)itemArray {
    if (itemArray && (itemArray.count > 0)) {
        for (YPBannerItem *item in itemArray) {
            [self addItem:item];
        }
    }
}

- (void)addItem:(YPBannerItem *)item {
    if (!item) { return; }
    if (!_imageManager) {
        _imageManager = [SDWebImageManager sharedManager];
    }
    item.itemIndex = _itemQueue.count;
    [_itemQueue addObject:item];
    _countOfItems = _itemQueue.count;
    if (_delegate && [_delegate respondsToSelector:@selector(YPBannerManager:addItem:)]) {
        [_delegate YPBannerManager:self addItem:item];
    }

    if (item.itemImgUrl) {
        [_imageManager downloadImageWithURL:[NSURL URLWithString:item.itemImgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                item.itemImg = image;
                if (_delegate && [_delegate respondsToSelector:@selector(YPBannerManager:updateItem:)]) {
                    [_delegate YPBannerManager:self updateItem:item];
                }
            }
        }];
    }
}

- (void)deleteItem:(YPBannerItem *)item {
    if (!item) { return; }
    NSInteger itemIndex = [_itemQueue indexOfObject:item];
    if ((itemIndex >= 0) && (itemIndex < _itemQueue.count)) {
        [_itemQueue removeObject:item];
        _countOfItems = _itemQueue.count;
        for (NSInteger i = itemIndex; i < _itemQueue.count; i++) {
            ((YPBannerItem *)(_itemQueue[i])).itemIndex = i;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(YPBannerManager:deleteItem:)]) {
            [_delegate YPBannerManager:self deleteItem:item];
        }
    }
}

- (void)removeAllItemsWithPlaceholderItem:(BOOL)flag {
    [_itemQueue removeAllObjects];
    _countOfItems = _itemQueue.count;
    if (_delegate && [_delegate respondsToSelector:@selector(YPBannerManager:removeAllItemsWithPlaceholdItem:)]) {
        [_delegate YPBannerManager:self removeAllItemsWithPlaceholdItem:flag];
    }
}

- (YPBannerItem *)itemAtIndex:(NSInteger)index {
    return _itemQueue[index];
}
@end
