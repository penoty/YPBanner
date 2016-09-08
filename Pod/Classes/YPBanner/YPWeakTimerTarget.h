//
//  YPWeakTimerTarget.h
//  reocar_ios
//
//  Created by yupao on 9/8/16.
//  Copyright © 2016 reocar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface YPWeakTimerTarget : NSObject
+ (instancetype)targetWithWeakTarget:(id)target
                             fireSel:(SEL)sel;
@end
