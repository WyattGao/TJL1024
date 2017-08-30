//
//  GLTextView.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/8/2.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "GLTextView.h"
#import "UITextView+Category.h"

@interface GLTextView () <UITextViewDelegate>

@end

@implementation GLTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLbl.text = placeholder;
}

- (UILabel *)placeholderLbl
{
    if (!_placeholderLbl) {
        _placeholderLbl = [UILabel new];
        [self addSubview:_placeholderLbl];
        
        _placeholderLbl.font          = self.font;
        _placeholderLbl. textColor    = RGB(169, 169, 169);
        _placeholderLbl.numberOfLines = 0;
        
        WS(ws);
        
        [_placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws).offset(ws.textContainerInset.top);
            make.left.equalTo(ws).offset(ws.textContainerInset.left + 5);
            make.right.equalTo(ws).offset(-ws.textContainerInset.right);
            make.bottom.equalTo(ws).offset(-ws.textContainerInset.bottom);
        }];
    }
    
    return _placeholderLbl;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLbl.font = font;
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    
    [self setText:self.text lineSpacing:lineSpacing];
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0) {
        _placeholderLbl.hidden = NO;
    } else {
        _placeholderLbl.hidden = YES;
    }
    
    if ([self.glDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.glDelegate textViewDidChange:textView];
    }
    
    
    UITextRange *selectedRange = [self markedTextRange];
    NSString *str              = [self textInRange:selectedRange];
    NSInteger num              = [self.text length]-[str length];

    [self setText:[self.text substringToIndex:num] lineSpacing:self.lineSpacing];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.glDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.glDelegate textViewDidEndEditing:textView];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.glDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.glDelegate textViewDidBeginEditing:textView];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([self.glDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.glDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    if (textView.returnKeyType == UIReturnKeyDone && [text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return false;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.glDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.glDelegate textViewShouldBeginEditing:textView];
    }

    return YES;
}

@end
