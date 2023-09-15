//
//  HTAccountModel.h
// 
//
//  Created by Apple on 2023/2/22.
//  Copyright © 2023 Apple. All rights reserved.
//

#import "FLBaseModel.h"


UIKIT_EXTERN NSString *const STATIC_kUserInfoKey;


@interface HTAccountModel : FLBaseModel

//这几个字段需要和用户信息接口返回的字段一致
@property (nonatomic, copy) NSString *uid; //" : "3697938",
@property (nonatomic, copy) NSString *phone; //" : null,
@property (nonatomic, copy) NSString *user_face; //" : "http:\/\/www.baidu.com",
@property (nonatomic, copy) NSString *user_gender; //" : -1,
@property (nonatomic, copy) NSString *user_birth; //" : "2000-01-01",
@property (nonatomic, copy) NSString *email; //" : "huzhongkai66@gmail.com",
@property (nonatomic, copy) NSString *user_name; //" : "Apple",

//非服务端返回字段
@property (nonatomic, copy) NSString *var_fcmToken;
@property (nonatomic, copy) NSString *var_idfa;
@property (nonatomic, copy) NSString *var_apns_id;
@property (nonatomic, assign) BOOL var_isLogin; //是否登录
@property (nonatomic, assign) BOOL var_toolVip; //工具包订阅用户

// 绑定账号 -vip验证接口的返回的信息
@property (nonatomic, copy)NSString *var_bindPlanState;//绑定账号的VIP状态
@property (nonatomic, copy)NSString *var_bindStartTime;//开始时间
@property (nonatomic, copy)NSString *var_bindEndTime;//到期时间
@property (nonatomic, copy)NSString *var_bindRenewStatus;//续订状态
@property (nonatomic, copy)NSString *var_bindPid;//服务端绑定的产品ID;本地的产品在STATIC_kIsFinishSubscribe里面存着.
@property (nonatomic, copy)NSString *var_bindAppId;//绑定appId
@property (nonatomic, copy)NSString *var_bindAppName;//绑定项目
@property (nonatomic, copy)NSString *var_bindAppOs;//绑定系统 1:iOS
@property (nonatomic, copy)NSString *var_bindMail;//绑定用户
@property (nonatomic, copy)NSString *var_bindShelf;//绑定项目是否下架
@property (nonatomic, copy)NSString *var_bindUbt;//绑定用户是否有有效订单

// 家庭计划-登录/注册接口返回的信息
@property (nonatomic, copy)NSString *var_familyPlanState;//"val"//家庭计划的状态 0:不是家庭VIP |  1:是家庭vip
@property (nonatomic, copy)NSString *var_identity;//"master"身份 1:管理员 | 2:成员
@property (nonatomic, copy)NSString *var_fid;//"fid" 家庭ID
@property (nonatomic, copy)NSString *var_vipStartTime;//开始时间
@property (nonatomic, copy)NSString *var_vipEndTime;//到期时间
@property (nonatomic, copy)NSString *var_renewStatus;//续订状态
@property (nonatomic, copy)NSString *var_pid;//"pid" 产品ID


+ (HTAccountModel *)sharedInstance;

/// 存值
/// - Parameter userInfo: 用户信息
- (void)ht_setUserInfo:(id)userInfo;

//暂时不用
- (void)clearUserInfo;

- (BOOL)ht_isVip;

// 本地订阅的pid
- (NSString *)ht_pidByLocalVip;

// 是否为服务端vip yes:是
- (BOOL)ht_isServerVip;

// 家庭计划
- (BOOL)ht_isFamilyVip;

//是否为本地vip yes:是
- (BOOL)ht_isLocalVip;

// 设备vip
- (BOOL)ht_isDeviceVip;

//数据持久化
+ (void)ht_accountPersistence;

@end

