//
//  ZKBaseTextField.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/22.
//

#import "ZKBaseTextField.h"
//#import "ZKBaseSDK.h"

#define kBaseDefaultNum 50

@implementation ZKBaseTextField

- (void)awakeFromNib{
    [super awakeFromNib];
    self.var_subText = @"";
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.autocorrectionType=UITextAutocorrectionTypeNo;
}

-(instancetype)init{
    if (self = [super init]) {
        self.var_subText = @"";
        self.delegate = self;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.autocorrectionType=UITextAutocorrectionTypeNo;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.var_subText = @"";
        self.delegate = self;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.autocorrectionType=UITextAutocorrectionTypeNo;
    }
    return self;
    
}

- (BOOL)textFieldOfRegex:(NSString*)regex andText:(NSString*)text {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ %@", AsciiString(@"SELF MATCHES"), regex];
    return [pred evaluateWithObject:text];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString ht_isEmpty:textField.text.ht_trimming]) {
        self.text = @"";
        if ([self.var_myDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [self.var_myDelegate textFieldDidEndEditing:self];
        }
        return;
    }
    if(![NSString ht_isEmpty:self.regex]){
        BOOL flag = [self textFieldOfRegex:self.regex andText:textField.text.ht_trimming];
        if(!flag){
            NSString *errorStr = [NSString stringWithFormat:@"%@ %@", AsciiString(@"Please enter the correct"), kFormat(self.placeholder?:self.var_placeholderTemp).ht_isEmptyStr];
            [self TextFieldValiteErrorMsg:errorStr];
            return;
        }
    }
    if ([self.var_myDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.var_myDelegate textFieldDidEndEditing:self];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if([self.var_myDelegate respondsToSelector:@selector(textFieldDidChange:)]){
        [self.var_myDelegate textFieldDidChange:self];
    }
    if ([NSString ht_isEmpty:textField.text.ht_trimming]) {
        self.var_subText  = @"";
        return;
    }else if ([[[textField textInputMode] primaryLanguage] isEqualToString:AsciiString(@"emoji")]) {
        textField.text = self.var_subText;
        return;
    }else{
        self.var_subText = textField.text ;
    }
    if (textField.text.ht_trimming.length > ((self.var_textNumber>0)?self.var_textNumber:kBaseDefaultNum)) {
        NSString *lang = [[textField textInputMode]primaryLanguage];//键盘输入模式
        if ([lang isEqualToString:AsciiString(@"zh-Hans")]) {// 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                
                textField.text = [textField.text.ht_trimming substringToIndex:((self.var_textNumber>0)?self.var_textNumber:kBaseDefaultNum)];
            }
            //有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }else{
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            textField.text = [textField.text.ht_trimming substringToIndex:((self.var_textNumber>0)?self.var_textNumber:kBaseDefaultNum)];
        }
    }
}

- (void)textFieldDidBeginEditing:(ZKBaseTextField *)textField{
    if ([self.var_myDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.var_myDelegate textFieldDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.var_myDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return  [self.var_myDelegate textFieldShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([self.var_myDelegate respondsToSelector:@selector(textFieldShouldReturn:)]){
        [self.var_myDelegate textFieldShouldReturn:self];
    }
    if(self.delegate != self){
        if([self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]){
            [self.delegate textFieldShouldReturn:self];
        }
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([self.var_myDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
        return [self.var_myDelegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    if(self.delegate != self){
        if([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
            return  [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
        }
    }
    return YES;
}

#pragma mark -

- (void)TextFieldValiteErrorMsg:(NSString *)errorMsg{
    if ([self.var_myDelegate respondsToSelector:@selector(lgjeropj_textFieldValiteError:errorMsg:)]) {
        [self.var_myDelegate lgjeropj_textFieldValiteError:self errorMsg:errorMsg];
    }
    if (self.BLOCK_textFieldValiteErrorBlock) {
        self.BLOCK_textFieldValiteErrorBlock(self, errorMsg);
    }
}

@end
