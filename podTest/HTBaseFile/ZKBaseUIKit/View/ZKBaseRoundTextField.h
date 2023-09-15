//
//  ZKBaseRoundTextField.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import "ZKBaseTextField.h"

@interface ZKBaseRoundTextField : ZKBaseTextField

@property (nonatomic, strong) IBInspectable id leftImage;
@property (nonatomic, assign) IBInspectable CGFloat var_leftOffset;
@property (nonatomic, assign) IBInspectable CGFloat var_textLeftOffset;
@property (nonatomic, strong) IBInspectable UIColor *var_clearButtonColor;

@end
