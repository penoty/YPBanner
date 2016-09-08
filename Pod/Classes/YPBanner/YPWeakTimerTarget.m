//
//  YPWeakTimerTarget.m
//  reocar_ios
//
//  Created by yupao on 9/8/16.
//  Copyright © 2016 reocar. All rights reserved.
//

#import "YPWeakTimerTarget.h"

@interface YPWeakTimerTarget ()
@property (nonatomic, weak) id fireTarget;
@property (nonatomic, assign) SEL fireSel;
@end

@implementation YPWeakTimerTarget

+ (instancetype)targetWithWeakTarget:(id)target fireSel:(SEL)sel {
    id timerTarget = [[YPWeakTimerTarget alloc] init];
    [timerTarget setFireTarget:target];
    [timerTarget setFireSel:sel];
    return timerTarget;
}

- (void)timerDidFire:(NSTimer *)timer {
    if (_fireTarget) {
        IMP fireIMP = method_getImplementation(class_getInstanceMethod([_fireTarget class], _fireSel));
        void (*timerFireUp)(id, SEL) = (void *)fireIMP;
        timerFireUp(_fireTarget, _fireSel);
    }
}

@end
