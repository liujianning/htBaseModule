//
//  ZKBaseTextField.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/22.
//

#import <UIKit/UIKit.h>

@class ZKBaseTextField;

@protocol HTBaseTextFieldDelegate <NSObject>

@optional

/**
 输入完成的回调
 @param textField textField
 */
- (void)textFieldDidBeginEditing:(ZKBaseTextField *)textField;
- (void)textFieldDidEndEditing:(ZKBaseTextField *)textField;
- (BOOL)textFieldShouldBeginEditing:(ZKBaseTextField *)textField;
- (BOOL)textFieldShouldReturn:(ZKBaseTextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
/// 校验不通过回调，需开发者自行实现提示用户
- (void)lgjeropj_textFieldValiteError:(ZKBaseTextField *)textField errorMsg:(NSString *)errorMsg;
- (void)textFieldDidChange:(ZKBaseTextField *)textField;

@end


@interface ZKBaseTextField : UITextField<UITextFieldDelegate>

@property (nonatomic, weak) id<HTBaseTextFieldDelegate> var_myDelegate;

//任何类型都会有默认的字数限制，如果设置了textNumber 不等于0    则以textNumber为准   手机号码  身份证
//TextState_phone手机号码  TextState_cardId身份证  设置无效
//TextState_BFB百分比  设置表示最大百分比  如textNumber = 300    就可以输入最大为300%的百分比    默认100%
@property (nonatomic, assign)IBInspectable NSInteger var_textNumber;

@property (nonatomic,copy)NSString *var_subText;

/// 正则校验规则
@property (nonatomic,copy)NSString *regex;

/// 占位文字，用于不显示实际placeholder，但是输入校验出错时的提示信息
@property (nonatomic,copy)NSString *var_placeholderTemp;

/// 校验不通过回调，需开发者自行实现提示用户
@property (nonatomic, copy) void(^BLOCK_textFieldValiteErrorBlock)(ZKBaseTextField *textField, NSString *errorMsg);

@end

