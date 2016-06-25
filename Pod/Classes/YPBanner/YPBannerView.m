//
//  YPBannerView.m
//  YPBannerDemo
//
//  Created by yupao on 1/8/16.
//  Copyright © 2016 yupao. All rights reserved.
//

#import "YPBannerView.h"
#define VIEW_WIDTH self.bounds.size.width
#define VIEW_HEIGHT self.bounds.size.height
#define LEFT_IMAGE_ORGIN CGPointMake(VIEW_WIDTH*0, 0)
#define CENTER_IMAGE_ORGIN CGPointMake(VIEW_WIDTH*1, 0)
#define RIGHT_IMAGE_ORGIN CGPointMake(VIEW_WIDTH*2, 0)
#define TIMERINTERVAL 5.0f

@interface YPBannerView(){
    NSArray *animationTypeArray;
}
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *bannerView;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic, strong) UITapGestureRecognizer *onceTap;
@property (nonatomic, assign) NSInteger centerImageIndex;
@property (nonatomic, strong) YPBannerManager *bannerManager;
@property (nonatomic, strong) NSTimer *bannerTimer;
@property (nonatomic, strong) CATransition *bannerAnimation;
@end
@implementation YPBannerView
#pragma mark - init methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        animationTypeArray = @[kCATransitionFade,kCATransitionMoveIn,kCATransitionPush,kCATransitionReveal  //公开动画
                               ,@"cube",@"oglFlip",@"suckEffect",@"rippleEffect",@"pageCurl",@"pageUnCurl"  //私有动画
                               ];
        _scrollTimeInterval = TIMERINTERVAL;
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
        _centerImageIndex = 0;
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
        _centerImageIndex = 0;
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
    [self ajustImageIndex];
    [self resumeTimer];
}

- (void)resetBannerItems:(NSArray<YPBannerItem *> *)itemArray {
    [_bannerManager removeAllItemsWithPlaceholderItem:NO];
    [self addBannerItems:itemArray];
}

#pragma mark - subview init methods
- (void)initBannerView {
    _bannerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [_bannerView setBounces:NO];
    [_bannerView setShowsHorizontalScrollIndicator:NO];
    [_bannerView setShowsVerticalScrollIndicator:NO];
    [_bannerView setPagingEnabled:YES];
    [_bannerView setContentOffset:CENTER_IMAGE_ORGIN];
    [_bannerView setContentSize:CGSizeMake(VIEW_WIDTH*3.0f, VIEW_HEIGHT)];
    [_bannerView setDelegate:(id<UIScrollViewDelegate> _Nullable)self];
    [_bannerView setOpaque:YES];
    [self addSubview:_bannerView];
    [self bringSubviewToFront:_bannerView];
    
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_IMAGE_ORGIN.x, LEFT_IMAGE_ORGIN.y, VIEW_WIDTH, VIEW_HEIGHT)];
    _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CENTER_IMAGE_ORGIN.x, CENTER_IMAGE_ORGIN.y, VIEW_WIDTH, VIEW_HEIGHT)];
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(RIGHT_IMAGE_ORGIN.x, RIGHT_IMAGE_ORGIN.y, VIEW_WIDTH, VIEW_HEIGHT)];
    [_bannerView addSubview:_leftImageView];
    [_bannerView addSubview:_centerImageView];
    [_bannerView addSubview:_rightImageView];
}

- (void)initGestureView {
    _gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
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
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(VIEW_WIDTH/2.0f-20, VIEW_HEIGHT-20.f, 40, 20)];
    [_pageControl setNumberOfPages:[_bannerManager countOfItems]];
    [self addSubview:_pageControl];
    [self bringSubviewToFront:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_bannerView setFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [_leftImageView setFrame:CGRectMake(LEFT_IMAGE_ORGIN.x, LEFT_IMAGE_ORGIN.y, VIEW_WIDTH, VIEW_HEIGHT)];
    [_centerImageView setFrame:CGRectMake(CENTER_IMAGE_ORGIN.x, CENTER_IMAGE_ORGIN.y, VIEW_WIDTH, VIEW_HEIGHT)];
    [_rightImageView setFrame:CGRectMake(RIGHT_IMAGE_ORGIN.x, RIGHT_IMAGE_ORGIN.y, VIEW_WIDTH, VIEW_HEIGHT)];
    [_gestureView setFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [_pageControl setFrame:CGRectMake(VIEW_WIDTH/2.0f-20, VIEW_HEIGHT-20.f, 40, 20)];
    [self ajustImageIndex];
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
#pragma mark - NSTimer related
- (void)initBannerTimer {
    _bannerTimer = [NSTimer scheduledTimerWithTimeInterval:_scrollTimeInterval
                                                    target:self
                                                  selector:@selector(timeUp)
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
    _bannerTimer = nil;
}

- (void)timeUp {
    [self didSwipeOnBanner:_leftSwipe];
}

- (void)ajustImageIndex {
    NSInteger countOfItems = _bannerManager.countOfItems;
    if (countOfItems > 0) {
        NSInteger centerIndex= _centerImageIndex;
        NSInteger leftIndex= (centerIndex == 0)?((countOfItems-1)):(centerIndex-1);
        NSInteger rightIndex= (centerIndex == countOfItems-1)?(0):(centerIndex+1)%(countOfItems);
        _pageControl.currentPage = centerIndex;
        _leftImageView.image = [_bannerManager itemAtIndex:leftIndex].itemImg;
        _centerImageView.image = [_bannerManager itemAtIndex:centerIndex].itemImg;
        _rightImageView.image = [_bannerManager itemAtIndex:rightIndex].itemImg;
    } else {
        [_pageControl setNumberOfPages:0];
        _centerImageIndex = 0;
        _pageControl.currentPage = 0;
        _leftImageView.image = nil;
        _centerImageView.image = nil;
        _rightImageView.image = nil;
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
    if (reg.direction == UISwipeGestureRecognizerDirectionLeft) {//scroll to right direction
        _centerImageIndex = (_centerImageIndex == countOfItems)? 0: (_centerImageIndex+1)%countOfItems;
        if (_bannerAnimation) {
            _bannerAnimation.subtype = kCATransitionFromRight;
            [self.layer addAnimation:_bannerAnimation forKey:nil];
        }
        [_bannerView setContentOffset:RIGHT_IMAGE_ORGIN animated:NO];
    }
    if (reg.direction == UISwipeGestureRecognizerDirectionRight) {//scroll to left direction
        _centerImageIndex = (_centerImageIndex == 0)?(countOfItems -1):(_centerImageIndex-1)%countOfItems;
        if (_bannerAnimation) {
            _bannerAnimation.subtype = kCATransitionFromLeft;
            [self.layer addAnimation:_bannerAnimation forKey:nil];
        }
        [_bannerView setContentOffset:LEFT_IMAGE_ORGIN animated:NO];
    }
    [self ajustImageIndex];
    _pageControl.currentPage = _centerImageIndex;
    [_bannerView setContentOffset:CENTER_IMAGE_ORGIN];
    [self resumeTimer];
}

- (void)didTapOnBanner:(UITapGestureRecognizer *)reg {
    if (_bannerManager.countOfItems == 0) {
        return;
    }
    YPBannerItem *currentItem = [_bannerManager itemAtIndex:_centerImageIndex];
    if (_delegate && [_delegate respondsToSelector:@selector(didTapOnBannerItem:)]) {
        [_delegate didTapOnBannerItem:currentItem];
    }
    [self resumeTimer];
}

#pragma mark -YPBannerManagerDelegate
- (void)YPBannerManager:(YPBannerManager *)manager addItem:(YPBannerItem *)item {
    [_pageControl setNumberOfPages:manager.countOfItems];
    _centerImageIndex = 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
