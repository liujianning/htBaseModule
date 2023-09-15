//
//  HTCommonConfiguration.h
//  PostTest
//
//  Created by 李雪健 on 2023/7/27.
//

#import <Foundation/Foundation.h>
//#import "ZQAccountModel.h"//测试

NS_ASSUME_NONNULL_BEGIN

@interface HTCommonConfiguration : NSObject

+ (HTCommonConfiguration *)lgjeropj_shared;

// vip状态
@property (nonatomic, copy) BOOL (^BLOCK_vipBlock) (void);
// baseURL
@property (nonatomic, copy) NSString * (^BLOCK_baseURLBlock) (void);
// 埋点URL
@property (nonatomic, copy) NSString * (^BLOCK_dataURLBlock) (void);
// app_id
@property (nonatomic, copy) NSString * (^BLOCK_appIdBlock) (void);
// appleId
@property (nonatomic, copy) NSString * (^BLOCK_appleIdBlock) (void);
// 用户信息
//@property (nonatomic, copy) ZQAccountModel * (^BLOCK_userBlock) (void);
// airDict
@property (nonatomic, copy) NSDictionary * (^BLOCK_airDictBlock) (void);
// 多语言
@property (nonatomic, copy) NSDictionary * (^BLOCK_mutilLanguageBlock) (void);
// 导量 gd_dictionary
@property (nonatomic, copy) NSDictionary * (^BLOCK_gdBlock) (void);

// 开关状态
@property (nonatomic, copy) BOOL (^BLOCK_switchStateBlock) (void);
// 保存用户数据
//@property (nonatomic, copy) void (^BLOCK_saveUserBlock) (ZQAccountModel *model);
// 深链
@property (nonatomic, copy) NSURL * (^BLOCK_deepLinkBlock) (NSDictionary *params);
// 深链公参
@property (nonatomic, copy) NSMutableDictionary * (^BLOCK_deepLinkParamsBlock) (void);
// 停止广告
@property (nonatomic, copy) void (^BLOCK_stopAdBlock) (BOOL stop);
// 是否广告
@property (nonatomic, copy) BOOL (^BLOCK_getStopAdBlock) (void);
// 检测强制登录
@property (nonatomic, copy) void (^BLOCK_checkLoginBlock) (void);
// 跳转登录
@property (nonatomic, copy) void (^BLOCK_toLoginBlock) (NSInteger source);
// 退出登录
@property (nonatomic, copy) void (^BLOCK_toLogoutBlock) (void);
// 订阅事件 KVAEvent
@property (nonatomic, copy) void (^BLOCK_subscribeEventBlock) (void);
// 订阅验证
@property (nonatomic, copy) void (^BLOCK_subscribeVerifyBlock) (void);
// 前往订阅页
@property (nonatomic, copy) void (^BLOCK_toPremiumBlock) (NSInteger source);
// 显示tabbar订阅红点
@property (nonatomic, copy) void (^BLOCK_showRedBlock) (void);
// applovin
@property (nonatomic, copy) id (^BLOCK_appLovinSDKBlock) (void);
// 引导页
@property (nonatomic, copy) void (^BLOCK_showGuidePageBlock) (void);

@end

NS_ASSUME_NONNULL_END
