//
//  HTCommonConfiguration.m
//  PostTest
//
//  Created by 李雪健 on 2023/7/27.
//

#import "HTCommonConfiguration.h"

@implementation HTCommonConfiguration

+ (HTCommonConfiguration *)lgjeropj_shared {

    static HTCommonConfiguration *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[HTCommonConfiguration alloc] init];
    });
    return config;
}

@end
