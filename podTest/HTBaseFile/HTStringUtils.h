//
//  HTStringUtils.h
// 
//
//  Created by admin on 2022/12/16.
//  Copyright © 2022 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTStringUtils : NSObject
@property (nonatomic, strong) NSMutableDictionary *var_multiLangDict;

+ (instancetype)sharedInstance;
+ (NSURL *)ht_imageUrlFromNumber:(NSInteger)var_Number;
+ (NSString *)ht_asciistring:(id)object;
- (NSString *)ht_stringWithKid:(id)text;
- (void)ht_getLangfileData;
+ (NSString *)ht_shStringFromAsciiArray:(NSArray *)codeArr;
- (void)lgjeropj_getLangWithNetwork;

@end

NS_ASSUME_NONNULL_END
