//
//  YPBannerView.m
//  YPBannerDemo
//
//  Created by yupao on 1/8/16.
//  Copyright © 2016 yupao. All rights reserved.
//

#import "YPBannerView.h"

static const NSTimeInterval DefaultTimeInterval = 5.0f;

@interface YPBannerView(){
    NSArray *animationTypeArray;
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, strong) UIImageView *bannerView;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic, strong) UITapGestureRecognizer *onceTap;
@property (nonatomic, assign) NSInteger bannerIndex;
@property (nonatomic, strong) YPBannerManager *bannerManager;
@property (nonatomic, strong) NSTimer *bannerTimer;
@property (nonatomic, strong) CATransition *bannerAnimation;
@end
@implementation YPBannerView

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        animationTypeArray = @[kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal  //public
                               ,@"cube",@"oglFlip",@"suckEffect",@"rippleEffect",@"pageCurl",@"pageUnCurl"  //private
                               ];
        _scrollTimeInterval = DefaultTimeInterval;
        if (!_bannerManager) {
            _bannerManager = [[YPBannerManager alloc] init];
            [_bannerManager setDelegate:(id<YPBannerManagerDelegate> _Nullable)self];
        }
        [self initBannerView];
        [self initGestureView];
        [self initPageControl];
        [self initBannerTimer];
    }
    return self;
}

- (instancetype)initWithYPBannerItems:(NSArray<YPBannerItem *> *)itemArray {
    self = [super init];
    if (self) {
        if (!_bannerManager) {
            _bannerManager = [[YPBannerManager alloc] init];
            [_bannerManager setDelegate:(id<YPBannerManagerDelegate> _Nullable)self];
        }
        [_bannerManager addItems:(NSArray<YPBannerItem *> *)itemArray];
        _bannerIndex = 0;
        _bannerAnimation = [self createDefaultAnimation];
    }
    return self;
}

- (instancetype)initWithYPBannerItems:(NSArray<YPBannerItem *> *)itemArray
                        animationType:(YPBannerAnimationType)type
                 andAnimationDuration:(NSTimeInterval)duration {
    self = [self initWithYPBannerItems:itemArray];
    if (self) {
        _bannerAnimation = [self createAnimationByType:type
                                        beginDirection:kCATransitionFromLeft
                                        timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                  andAnimationDuration:duration
                            ];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
             andYPBannerItems:(NSArray<YPBannerItem *> *)itemArray {
    self = [self initWithFrame:frame];
    if (self) {
        [_bannerManager addItems:(NSArray<YPBannerItem *> *)itemArray];
        _bannerIndex = 0;
        _bannerAnimation = [self createDefaultAnimation];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                YPBannerItems:(NSArray<YPBannerItem *> *)itemArray
                animationType:(YPBannerAnimationType)type
         andAnimationDuration:(NSTimeInterval)duration {
    self = [self initWithFrame:(CGRect)frame andYPBannerItems:itemArray];
    if (self) {
        _bannerAnimation = [self createAnimationByType:type
                                        beginDirection:kCATransitionFromLeft
                                        timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                  andAnimationDuration:duration
                            ];
    }
    return self;
}

- (void)addBannerItems:(NSArray<YPBannerItem *> *)itemArray {
    [_bannerManager addItems:itemArray];
    [self resumeTimer];
}

- (void)resetBannerItems:(NSArray<YPBannerItem *> *)itemArray {
    if (itemArray && (itemArray.count > 0)) {
        [_bannerManager removeAllItemsWithPlaceholderItem:NO];
        [self addBannerItems:itemArray];
    }
}

- (void)dealloc {
    [_bannerTimer invalidate];
    [_bannerManager setDelegate:nil];
}

#pragma mark - subview init methods
- (void)initBannerView {
    _bannerView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_bannerView];
}

- (void)initGestureView {
    _gestureView = [[UIView alloc] initWithFrame:self.bounds];
    [_gestureView setUserInteractionEnabled:YES];
    [_gestureView setBackgroundColor:[UIColor clearColor]];
    [_gestureView setOpaque:NO];
    _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeOnBanner:)];
    _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeOnBanner:)];
    _onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnBanner:)];
    [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [_gestureView addGestureRecognizer:_leftSwipe];
    [_gestureView addGestureRecognizer:_rightSwipe];
    [_gestureView addGestureRecognizer:_onceTap];
    
    [self addSubview:_gestureView];
    [self bringSubviewToFront:_gestureView];
}

- (void)initPageControl {
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width/2.0f-20, self.bounds.size.height-20.f, 40, 20)];
    [_pageControl setNumberOfPages:[_bannerManager countOfItems]];
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_bannerView setFrame:self.bounds];
    [_gestureView setFrame:self.bounds];
    [_pageControl setFrame:CGRectMake(self.bounds.size.width/2.0f-20, self.bounds.size.height-20.f, 40, 20)];
    [self adjustImageIndex];
}

#pragma mark - setter and getter

- (void)setPlaceholderImg:(UIImage *)placeholderImg {
    _placeholderImg = placeholderImg;
    [_bannerManager setPlaceholderImg:placeholderImg];
}

- (void)setPageIndicatorColor:(UIColor *)indicatorColor andCurrentPageIndicatorColor:(UIColor *)currentIndicatorColor {
    _pageIndicatorTintColor = indicatorColor;
    _currentPageIndicatorColor = currentIndicatorColor;
    [_pageControl setPageIndicatorTintColor:_pageIndicatorTintColor];
    [_pageControl setCurrentPageIndicatorTintColor:_currentPageIndicatorColor];
}

- (void)setScrollTimeInterval:(CGFloat)scrollTimeInterval {
    _scrollTimeInterval = scrollTimeInterval;
    [self resumeTimer];
}

- (void)setAnimationType:(YPBannerAnimationType)animationType andAnimationDuration:(NSTimeInterval)animationDuration {
    _bannerAnimation = [self createAnimationByType:animationType
                                    beginDirection:kCATransitionFromLeft
                                    timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                              andAnimationDuration:animationDuration];
}

- (void)setIndicatorHidden:(BOOL)indicatorHidden {
    _indicatorHidden = indicatorHidden;
    [_pageControl setHidden:_indicatorHidden];
}

#pragma mark - move to new window callback
- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == (id)[NSNull null] || newWindow == nil) {
        [self pauseTimer];
    }else {
        [self resumeTimer];
    }
}

#pragma mark - NSTimer related
- (void)initBannerTimer {
    YPWeakTimerTarget *target = [YPWeakTimerTarget targetWithWeakTarget:self fireSel:@selector(timeUp)];
#pragma clang diagnostic ignored "-Wundeclared-selector"
    _bannerTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollTimeInterval
                                                    target:target
                                                  selector:@selector(timerDidFire:)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)pauseTimer {
    [_bannerTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    [_bannerTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollTimeInterval]];
}

- (void)stopTimer {
    [_bannerTimer invalidate];
}

- (void)timeUp {
    [self didSwipeOnBanner:_leftSwipe];
}

- (void)adjustImageIndex {
    NSInteger countOfItems = _bannerManager.countOfItems;
    if (countOfItems > 0) {
        NSInteger centerIndex= _bannerIndex;
        _pageControl.currentPage = centerIndex;
        _bannerView.image = [_bannerManager itemAtIndex:centerIndex].itemImg;
    } else {
        [_pageControl setNumberOfPages:0];
        _bannerIndex = 0;
        _pageControl.currentPage = 0;
        _bannerView.image = nil;
        [self pauseTimer];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self pauseTimer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resumeTimer];
}

#pragma mark - animation related
- (CATransition *)createAnimationByType:(YPBannerAnimationType)type
                         beginDirection:(NSString *)direction
                         timingFunction:(CAMediaTimingFunction *)function
                   andAnimationDuration:(NSTimeInterval)duration {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.subtype = direction;
    transition.timingFunction = function;
    transition.type = animationTypeArray[type];
    return transition;
}

- (CATransition *)createDefaultAnimation {
    CATransition * transition = [self createAnimationByType:YPBannerAnimationTypePush
                                             beginDirection:kCATransitionFromLeft
                                             timingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
                                       andAnimationDuration:0.7f];
    return transition;
}

#pragma mark - uiswipegesture
- (void)didSwipeOnBanner:(UISwipeGestureRecognizer *)reg {
    NSInteger countOfItems = _bannerManager.countOfItems;
    if (countOfItems > 0) {
        if (reg.direction == UISwipeGestureRecognizerDirectionLeft) {//scroll to right direction
            _bannerIndex = (_bannerIndex == (countOfItems - 1))? 0: (_bannerIndex+1)%countOfItems;
            if (_bannerAnimation) {
                _bannerAnimation.subtype = kCATransitionFromRight;
                [_bannerView.layer addAnimation:_bannerAnimation forKey:nil];
            }
        }
        if (reg.direction == UISwipeGestureRecognizerDirectionRight) {//scroll to left direction
            _bannerIndex = (_bannerIndex == 0)?(countOfItems -1):(_bannerIndex-1)%countOfItems;
            if (_bannerAnimation) {
                _bannerAnimation.subtype = kCATransitionFromLeft;
                [_bannerView.layer addAnimation:_bannerAnimation forKey:nil];
            }
        }
        [self adjustImageIndex];
        [self resumeTimer];
    } else {
        [self stopTimer];
    }
}

- (void)didTapOnBanner:(UITapGestureRecognizer *)reg {
    if (_bannerManager.countOfItems == 0) return;
    YPBannerItem *currentItem = [_bannerManager itemAtIndex:_bannerIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(didTapOnBannerItem:)]) {
        [_delegate didTapOnBannerItem:currentItem];
    }
    [self resumeTimer];
}

#pragma mark -YPBannerManagerDelegate
- (void)YPBannerManager:(YPBannerManager *)manager addItem:(YPBannerItem *)item {
    [_pageControl setNumberOfPages:manager.countOfItems];
    _bannerIndex = 0;
}

- (void)YPBannerManager:(YPBannerManager *)manager updateItem:(YPBannerItem *)item {
    [self adjustImageIndex];
}

@end
