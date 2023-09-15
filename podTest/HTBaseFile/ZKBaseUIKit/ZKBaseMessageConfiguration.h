//
//  ZKBaseMessageConfiguration.h
//
//
//  Created by dn on 2023/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKBaseMessageConfiguration : NSObject

@property (nonatomic, copy) NSString *text;

// default 16
@property (nonatomic, assign) CGFloat fontSize;

// default 0x333333
@property (nonatomic, strong) UIColor *textColor;

// default 10
@property (nonatomic, assign) CGFloat top;

// default 15
@property (nonatomic, assign) CGFloat bottom;

@end

NS_ASSUME_NONNULL_END
