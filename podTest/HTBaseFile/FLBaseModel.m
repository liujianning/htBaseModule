//
//  FLBaseModel.m
//  TalkFreely
//
//  Created by Apple on 2022/6/2.
//  Copyright © 2021 Apple. All rights reserved.
//

#import "FLBaseModel.h"

@implementation FLBaseModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return [FLBaseModel modelCustomPropertyMapper];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    NSMutableDictionary *mapping = [[NSMutableDictionary alloc] init];
    [mapping setValue:@"id" forKey:@"var_idNum"];
    [mapping setValue:@"description" forKey:@"var_descript"];
    [mapping setValue:@"new_flag" forKey:@"var_tagNewFlag"];
    return mapping;
}

@end
