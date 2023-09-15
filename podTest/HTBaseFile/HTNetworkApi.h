//
//  HTNetworkApi.h
//  TalkFreely
//
//  Created by Apple on 2022/6/2.
//  Copyright © 2021 Apple. All rights reserved.
//

#ifndef HTNetworkApi_h
#define HTNetworkApi_h

// 视频类型
typedef NS_ENUM(NSUInteger, ENUM_HTVideoType) {
    ENUM_HTVideoTypeUnknow = 0,         //有多种类型需要过滤
    ENUM_HTVideoTypeMovie = 1,          //电影
    ENUM_HTVideoTypeTv = 3,             //电视剧
    ENUM_HTVideoTypePreview = 4,        //预告
    ENUM_HTVideoTypeAdvert = 5,         //广告
};

//api
static NSString * const STATIC_kAppHomeData = @"250";//影视首页
static NSString * const STATIC_kAppOpenSubject = @"253";//打开专题
static NSString * const STATIC_kAppHomeSubjectMore = @"358";//首页专题点击更多
static NSString * const STATIC_kAppMovieDetailPage = @"144";//电影播放页
static NSString * const STATIC_kAppTvList = @"202";//进入电视剧播放页_剧集列表
static NSString * const STATIC_kAppTvSectionList = @"203";//电视剧播放页_季获取集列表(切季)
static NSString * const STATIC_kAppTvPlay = @"151";//播放电视剧
static NSString * const STATIC_kAppHomePullDown = @"156";//首页无限下拉
static NSString * const STATIC_kAppSearch = @"148";//搜索
static NSString * const STATIC_kAppSearchHotWords = @"230";//搜索中间页热搜词
static NSString * const STATIC_kAppTvCaptions = @"163";//影视字幕
static NSString * const STATIC_kAppTakePart = @"78";//获取分享链接
static NSString * const STATIC_kAppGetAdSetting = @"84";//获取广告配置 ad_strategy
static NSString * const STATIC_kAppGetKaiguan = @"87";//开关
static NSString * const STATIC_kAppMutilang = @"192";//多语言
static NSString * const STATIC_kAppPulluserinfo = @"115";//获取用户信息
static NSString * const STATIC_kAppFeedBack = @"5";//意见反馈
static NSString * const STATIC_kAppAuthCode = @"318";//邀请码
static NSString * const STATIC_kAppUpgradeap = @"325";// upgrade_ap 订阅绑定
static NSString * const STATIC_kAppVipap = @"326";//vip_ap 订阅校验
static NSString * const STATIC_kAppStripProduct = @"300";//订阅产品 strip_product 订阅引导及相关配置

static NSString * const STATIC_kAddFamily = @"282";//添加成员
static NSString * const STATIC_kDeleteFamilyNumber = @"283";//删除
static NSString * const STATIC_kDeleteFamily = @"327";//删除
static NSString * const STATIC_kFamilyList = @"284";//删除


//
#define kFormat(text) [NSString stringWithFormat:@"%@",text]
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kself __weak typeof (self) weakSelf = self;
#define kDevice_Is_iPad [HTCommonUtils ht_getIsIpad]
#define kNetworkFormat(api) [HTNetworkManager lgjeropj_requestURL:api]
#define TransSuccess(result) [HTCommonUtils transIsSuccess:result]
#define AsciiString(object) [HTStringUtils ht_asciistring:object]
#define LocalString(string,comment) [[HTStringUtils sharedInstance] ht_stringWithKid:string]
#define LocalInt(index) [[HTStringUtils sharedInstance] ht_stringWithKid:@index]
#define kImageNumber(index) [HTStringUtils ht_imageUrlFromNumber:index]
#define HTScaleWidth(var_scale, var_height) var_height * var_scale
#define HTScaleHeight(var_scale, var_width) var_width / var_scale
#define kDevice_Is_iPhoneX  ([[UIApplication sharedApplication] statusBarFrame].size.height > 20.0)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_BOTTOM_SAFEAREA (kDevice_Is_iPhoneX ? 34.0 : 0)
#define SCREEN_BOTTOM_49 49
#define StatusBarHeight                     (IS_IPHONE_X_orMore ? 44.f : 20.f)
#define LR_StatusBarAndNavigationBarHeight  (StatusBarHeight +  44.f)
#define kBarHeight 44
#define kNavHeight (kDevice_Is_iPhoneX?(StatusBarHeight+kBarHeight):64) //灵动岛机型手机为54+44=98
#define SCREEN_BOTTOM (kDevice_Is_iPhoneX ? 83 : 49)     //底部tabbar高度
#define REAL_WIDTH      ((SCREEN_WIDTH < SCREEN_HEIGHT) ?SCREEN_WIDTH :SCREEN_HEIGHT)
#define kWidthScale(with)   ((with) * (kWidthCoefficientTo6S))
#define kWidthCoefficientTo6S (IS_IPAD ? (REAL_WIDTH / 768) : (REAL_WIDTH / 375.0))
#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define BottomBarHeight                  (IS_IPHONE_X_orMore ? (49.f+34.f) : (IS_IPAD ? 65.f : 49.f))

#define  DefaultBackColor  [UIColor colorWithRed:0.965 green:0.969 blue:0.949 alpha:1]
#define  DefaultBackColor2 [UIColor colorWithRed:0.831 green:0.737 blue:0.69 alpha:1]
#define  DefaultTextColor  [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:141.0/255.0 alpha:1]

#define IS_IPHONE_X_orMore ({\
    BOOL isxScreen = NO; \
    if (@available(iOS 11.0, *)) { \
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {\
            isxScreen = YES; \
        } \
    } \
    isxScreen; \
})

#define kTermsURL @"https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
#define kPrivacyPolicyURL @"https://sites.google.com/view/axcolly/privacypolicy"
#define  IAP_AppStore   @"https://buy.itunes.apple.com/verifyReceipt"
#define  IAP_SANDBOX    @"https://sandbox.itunes.apple.com/verifyReceipt"

//内购信息相关字段 //这三个字段不能混淆成数字
#define kSubscribeBuyDateKey AsciiString(@"purchase_date_ms")
#define kSubscribeExpireDateKey AsciiString(@"expires_date_ms")
#define kSubscribeProductIdKey AsciiString(@"product_id")
#define kSubscribeRenewStatusKey AsciiString(@"auto_renew_status")
#define kSubscribeProductReceiptKey AsciiString(@"product_receipt")
#define kSubscribeProductStatusKey AsciiString(@"product_status")
//订阅信息key，是否订阅
#define STATIC_kIsFinishSubscribe @"var_isSubscribe"
//购买成功通知，用于首次购买成功后去除广告显示
#define NTFCTString_FinishSubscribeNotification @"NTFCTString_FinishSubscribeNotification"
//页面标识，用于广告异步加载显示
#define kAdvertPageHome @"var_home_page"
#define kAdvertPageSearch @"var_search_result"
#define kAdvertPageTrending @"var_trending_more"
#define kAdvertPageHistory @"var_history_mrec"
#define kAdvertPageWatchLater @"var_watch_mrec"

/*
 测试
 */
#define HT_IPA_Week @"week"
#define HT_IPA_Month @"month"
#define HT_IPA_Year @"year"
#define HT_IPA_Family_Week    @"family_week"
#define HT_IPA_Family_Month    @"family_month"
#define HT_IPA_Family_Year    @"family_year"
#define HT_IPA_Free_Month    @"free_month"
#define IAP_ShareKey   @"e7486eea6edb43309cad765b4d0eaa92"
#define IP_Base @"http://54.187.6.80"
#define AppleID             @"6446979826"
#define FBAppId             @"fb1005459233456032"
#define KochavaAPPGUID      @"kowaibao-test-os03"
#define TP_App_Id           @"100"

#endif /* HTNetworkApi_h */
