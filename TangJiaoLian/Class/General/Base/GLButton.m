//
//  GLButton.m
//  SuiTangNew
//
//  Created by 高临原 on 16/6/13.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "GLButton.h"

@implementation GLButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadView];
    }
    
    return self;
}

- (instancetype)initButtonWithType:(GLButtonType)buttonType
{
    self = [super init];
    if (self) {
        [self loadView];
                
        WS(ws);
        
        self.backgroundColor = [UIColor blueColor];
        self.cornerRadius    = 5;
        
        _lbl.font            = GL_FONT(15);
        _lbl.textColor       = RGB(255, 255, 255);
        
        [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws);
        }];
    }
    
    return self;
}

- (void)loadView
{
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    
    _image              = [UIImage new];
    _selImage           = [UIImage new];

    _textColor          = [UIColor blackColor];
    _selTextColor       = nil;

    _text               = @"";
    _selText            = nil;

    _nomBackGroundColor = [UIColor clearColor];
    
    _iv  = [UIImageView new];
    _lbl = [UILabel new];
    
    [self addSubview:_iv];
    [self addSubview:_lbl];
    
    _lbl.textAlignment = NSTextAlignmentCenter;
    
    WS(ws);
    
    [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_lbl.mas_top).offset(4);
        make.centerX.equalTo(ws);
    }];
    
    [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws);
        make.width.equalTo(ws);
        make.bottom.equalTo(ws.mas_bottom).offset(-5);
    }];
}


- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _image = image;
    } else if(state == UIControlStateSelected){
        _selImage = image;
    }
    
    if (self.selected) {
        [_iv setImage:_selImage];
    } else {
        [_iv setImage:_image];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _textColor = color;
    } else if(state == UIControlStateSelected){
        _selTextColor = color;
    } else if(state == UIControlStateHighlighted){
        _highlightedTextColor = color;
    }
    
    if (self.selected) {
        [_lbl setTextColor:_selTextColor];
    } else {
        [_lbl setTextColor:_textColor];
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _text = title;
    } else {
        _selText = title;
    }
    
    if (self.selected) {
        [_lbl setText:_selText.length ? _selText : _text];
    } else {
        [_lbl setText:_text];
    }
    
    WS(ws);
    
    if (_graphicLayoutState == DEFAULT) {
        [_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws);
        }];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _nomBackGroundColor = backgroundColor;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _nomBackGroundColor = backgroundColor;
    } else if(state == UIControlStateSelected) {
        _selBackGroundColor = backgroundColor;
    } else if(state == UIControlStateHighlighted){
        _highlightedBackGroundColor = backgroundColor ;
    }
    
    if (self.selected) {
        [self setBackgroundColor:_selBackGroundColor];
    } else {
        [self setBackgroundColor:_nomBackGroundColor];
    }
}

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state
{
    if (state == UIControlStateNormal) {
        _nomBorderColor = borderColor;
    } else if(state == UIControlStateSelected){
        _selBorderColor = borderColor;
    } else if(state == UIControlStateHighlighted){
        _highlightedBorderColor = borderColor;
    }
    
    if (self.selected) {
        [self setBorderColor:_selBorderColor];
    } else {
        [self setBorderColor:_nomBorderColor];
    }
}

- (void)setNomBackGroundColor:(UIColor *)nomBackGroundColor
{
    self.backgroundColor = nomBackGroundColor;
    _nomBackGroundColor = nomBackGroundColor;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [_lbl setText:text];
}

- (void)setFont:(UIFont *)font
{
    self.lbl.font = font;
    self.titleLabel.font = font;
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [_iv setImage:_selImage ? _selImage : _image];
        _lbl.textColor       = _selTextColor ? _selTextColor : _textColor;
        _lbl.text            = _selText ? _selText : _text;
        [super setBackgroundColor:_selBackGroundColor ? _selBackGroundColor : _nomBackGroundColor];
        self.borderColor     = _selBorderColor ? _selBorderColor : _borderColor;
    } else {
        [_iv setImage:_image];
        _lbl.textColor       = _textColor;
        _lbl.text            = _text;
        [super setBackgroundColor:_nomBackGroundColor ? _nomBackGroundColor : self.backgroundColor];
        self.borderColor     = _nomBorderColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = _highlightedBackGroundColor ? _highlightedBackGroundColor : _nomBackGroundColor;
        _lbl.textColor       = _highlightedTextColor ? _highlightedTextColor : _textColor;
        self.borderColor     = _highlightedBorderColor ? _highlightedBorderColor : _borderColor;
    } else {
        self.backgroundColor = _nomBackGroundColor;
        _lbl.textColor       = _textColor;
        self.borderColor     = _nomBorderColor;
        if (self.selected) {
            self.selected = true;
        }
    }
}

- (void)setGraphicLayoutState:(BtnGraphicLayout)graphicLayoutState
{
    _graphicLayoutState = graphicLayoutState;
    
    WS(ws);
    
    switch (graphicLayoutState) {
        case PICLEFT:
        {
            [_iv mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(ws);
                make.centerY.equalTo(ws);
            }];
            
            [_lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iv.mas_right).offset(_graphicLayoutSpacing);
                make.centerY.equalTo(_iv);
                make.right.lessThanOrEqualTo(ws.mas_right);
            }];
        }
            break;
        case TEXTCENTER:
        {
            [_lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(ws);
            }];
        }
            break;
        case PICCENTER:
        {
            [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(ws);
            }];
        }
            break;
        case PICTOP:
        {
            [_iv mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.mas_centerY).offset(0);
                make.centerX.equalTo(ws);
            }];
            
            [_lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_iv);
                make.top.equalTo(ws.mas_centerY).offset(_graphicLayoutSpacing);
            }];
        }
            break;
        default:
            break;
    }
    
    if (graphicLayoutState == PICLEFT) {
        

    }
}



- (void)setGraphicLayoutSpacing:(CGFloat)graphicLayoutSpacing
{
    _graphicLayoutSpacing = graphicLayoutSpacing;
    
    [self setGraphicLayoutState:_graphicLayoutState];
}


- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    
    if (!_nomBorderColor) {
        _nomBorderColor = borderColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [self.lbl setTextAlignment:textAlignment];
}

- (void)touchDown:(GLButton *)sender
{
    sender.highlighted = true;
}

- (void)touchUpOutside:(GLButton *)sender
{
    sender.highlighted = false;
    if (sender.selected) {
        sender.selected = true;
    }
    
}

@end
