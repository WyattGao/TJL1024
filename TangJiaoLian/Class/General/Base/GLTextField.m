//
//  GLTextField.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/13.
//  Copyright © 2016年 高临原♪ All rights reserved.
//

#import "GLTextField.h"

@interface GLTextField ()<UITextFieldDelegate>

@end

@implementation GLTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.returnKeyType     = UIReturnKeyDone;
        
        [self addTarget:self action:@selector(textfieldFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (UILabel *)glPlaceLbl
{
    if (!_glPlaceLbl) {
        _glPlaceLbl = [UILabel new];
        [self addSubview:_glPlaceLbl];
        _glPlaceLbl.font          = self.font;
        _glPlaceLbl.textColor     = RGB(148.00, 148.00, 148.00);
        _glPlaceLbl.textAlignment = NSTextAlignmentLeft;
        
        WS(ws);
        
        [_glPlaceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(5);
            make.centerY.equalTo(ws);
            make.right.equalTo(ws.mas_right);
        }];
    }
    
    return _glPlaceLbl;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth           = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor           = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setGlDelegate:(id<GLTextFieldDelegate>)glDelegate
{
    _glDelegate   = glDelegate;
    self.delegate = glDelegate;
}

- (void)textfieldFieldEditingChange:(UITextField *)textField
{
    
}

- (void)textfieldFieldDidChange:(UITextField *)textField
{
    _glPlaceLbl.hidden = textField.text.length ? true : false;
    
    if (![self charactersOfTheFilterWithText:textField.text] && _limitType != GLTextFieldTypeDefault && textField.text.length) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
        return;
    }
    
    if (self.textLength > 0 && textField.text.length > self.textLength) {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        NSString *str              = [textField textInRange:selectedRange];
        NSInteger num              = [textField.text length]-[str length];
        if (num > self.textLength) {
            textField.text = [textField.text substringToIndex:self.textLength];
        }

    }
    
    if ([_glDelegate respondsToSelector:@selector(textfieldFieldDidChange:)]) {
        [_glDelegate textfieldFieldDidChange:self];
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    _glPlaceLbl.hidden = text.length ? true : false;
}

- (BOOL)charactersOfTheFilterWithText:(NSString *)text
{
    NSString *regex = @"";
    switch (_limitType) {
        case GLTextFieldTypeDecimalPointAndDigital:
            regex = @"^\\d*\\.{0,1}\\d{0,1}$";
            break;
        case GLTextFieldTypeOnlyNumbers:
            regex = @"^[0-9]+$";
            break;
        default:
            break;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isTrue = [pred evaluateWithObject:text];
    return isTrue;
}

@end

