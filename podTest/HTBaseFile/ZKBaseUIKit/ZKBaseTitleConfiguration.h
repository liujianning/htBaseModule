//
//  ZKBaseTitleConfiguration.h
//
//
//  Created by dn on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKBaseTitleConfiguration : NSObject

@property (nonatomic, copy) NSString *text;

// default 18
@property (nonatomic, assign) CGFloat fontSize;

// default 0x000000
@property (nonatomic, strong) UIColor *textColor;

// default 15
@property (nonatomic, assign) CGFloat top;

// default 0
@property (nonatomic, assign) CGFloat bottom;

@end

NS_ASSUME_NONNULL_END
