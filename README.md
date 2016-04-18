# YPBanner
Just a few lines of code, you can easily add banner to your app. 
##Dependency
SDWebImage
##How to install?
        //support pod install,just do:
        pod 'YPBanner' 
        //if the repo is not updated,please try:
        pod "YPBanner", :git =>"https://github.com/penoty/YPBanner"
##How to use?
###Banner item init
        YPBannerItem *item_01 = [[YPBannerItem alloc] initWithImage:[UIImage imageNamed:@"placehold.png"] data:nil];
        YPBannerItem *item_02 = [[YPBannerItem alloc] initWithUrl:@"web_url" 
                                                             data:nil 
                                                   andPlaceholder:[UIImage imageNamed:@"placehold.png"]];
        ......
###default animation
        _bannerView = [[YPBannerView alloc] initWithYPBannerItems:@[item_01,item_02...]];     
###set animation type and duration
        _bannerView= [[YPBannerView alloc] initWithYPBannerItems:@[item_01,item_02...] 
                                                   animationType:YPBannerAnimationTypeCube 
                                            andAnimationDuration:1.5f];
###setup frame
        //you can setup frame any where you want by using setFrame or masonry
                //use setFrame:
                [_bannerView setFrame:...];
                //use Masonry
                [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make...
                 }];
###setup frame when init
                - (instancetype)initWithFrame:(CGRect)frame
                             andYPBannerItems:(NSArray<YPBannerItem *> *)itemArray;
                - (instancetype)initWithFrame:(CGRect)frame
                                YPBannerItems:(NSArray<YPBannerItem *> *)itemArray
                                animationType:(YPBannerAnimationType)type
                         andAnimationDuration:(NSTimeInterval)duration;

###YPBannerViewDelegate
        //If you want to have tap callback,just implement the YPBannerViewDelegate method:
        - (void)didTapOnBannerItem:(YPBannerItem *)item;
## Author
penoty, penoty@163.com
## License
YPBanner is available under the MIT license. See the LICENSE file for more info.
