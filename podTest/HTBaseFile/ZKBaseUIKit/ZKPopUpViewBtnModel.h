//
//  ZKPopUpViewBtnModel.h
//  GuessNums
//
//  Created by dn on 2023/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKPopUpViewBtnModel : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) ENUM_ZKBasePopUpBtnStyle buttonStyle;
@property (nonatomic, copy) BLOCK_buttonActionBlock actionHandler;

@end

NS_ASSUME_NONNULL_END
