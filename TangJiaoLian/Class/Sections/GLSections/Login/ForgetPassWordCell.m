//
//  ForgetPassWordCell.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/26.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "ForgetPassWordCell.h"

@interface ForgetPassWordCell ()

@property (nonatomic,assign) NSInteger identifier;

@end

@implementation ForgetPassWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _identifier         = [reuseIdentifier integerValue];
    }
    
    return self;
}

- (void)setType:(ChangePassWordType)type
{
    _type = type;
    
    WS(ws);
    
    UIView *line = [UIView new];
    _textField   = [GLTextField new];
    
    [self.contentView addSubview:_textField];
    [self.contentView addSubview:line];
    
    [_textField setPlaceholderColor:RGB(153, 153, 153)];
    [_textField setFont:GL_FONT(15)];
    [_textField setTextColor:RGB(0, 0, 0)];
    
    line.backgroundColor = RGB(203, 203, 203);
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.contentView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 0.5));
        make.centerX.equalTo(ws.contentView);
    }];
    
    switch (_identifier) {
        case 0:
        {
            GLButton *selAreaCodeBtn = [GLButton new];
            UILabel  *donwLbl        = [UILabel  new];
            UIView   *vLine          = [UIView   new];
            
            [_textField setPlaceholder:@"请输入手机号"];
            [_textField setKeyboardType:UIKeyboardTypeNumberPad];
            [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [_textField setTextLength:11];
            [_textField setLimitType:GLTextFieldTypeOnlyNumbers];

            [self.contentView addSubview:selAreaCodeBtn];
            
            [selAreaCodeBtn addSubview:donwLbl];
            [selAreaCodeBtn addSubview:vLine];
            
            [selAreaCodeBtn setTitle:@"+86" forState:UIControlStateNormal];
            [selAreaCodeBtn setFont:GL_FONT(15)];
            [selAreaCodeBtn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
            
            [donwLbl setText:@"▼"];
            [donwLbl setTextColor:RGB(39, 58, 54)];
            [donwLbl setFont:GL_FONT(8)];
            
            [vLine setBackgroundColor:RGB(151, 151, 151)];
            
            [selAreaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(ws.contentView);
                make.centerY.equalTo(ws.contentView);
                make.size.mas_equalTo(CGSizeMake(94.5, 55));
            }];
            
            [selAreaCodeBtn.lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(selAreaCodeBtn).offset(35);
                make.centerY.equalTo(selAreaCodeBtn);
            }];
            
            [donwLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(vLine.mas_left).offset(-14.7);
                make.centerY.equalTo(vLine);
            }];
            
            [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(selAreaCodeBtn).offset(94);
                make.centerY.equalTo(selAreaCodeBtn);
                make.size.mas_equalTo(CGSizeMake(0.5, 19));
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(vLine.mas_right).offset(9.5);
                make.centerY.equalTo(vLine);
                make.right.equalTo(ws.contentView).offset(-26);
                make.height.mas_equalTo(55);
            }];
        }
            break;
        case 1:
        {
            _getCodeBtn = [GLButton new];
            [self.contentView addSubview:_getCodeBtn];
            
            [_textField setPlaceholder:@"请输入验证码"];
            
            [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [_getCodeBtn setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
            [_getCodeBtn setFont:GL_FONT(12)];
            [_getCodeBtn setGraphicLayoutState:TEXTCENTER];
            [_getCodeBtn setCornerRadius:10];
            [_getCodeBtn setSelBackGroundColor:TCOL_MAIN];
            [_getCodeBtn setNomBackGroundColor:RGB(242, 242, 242)];
            [_getCodeBtn setUserInteractionEnabled:false];
            [_textField setKeyboardType:UIKeyboardTypeNumberPad];
            
            [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(ws.contentView).offset(-15);
                make.centerY.equalTo(ws.contentView);
                make.size.mas_equalTo(CGSizeMake(77, 27));
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.contentView);
                make.left.equalTo(ws.contentView).offset(15);
                make.size.mas_equalTo(CGSizeMake(150, 55));
            }];
        }
            break;
        case 2:case 3:
        {
            GLButton *hidePassWordBtn = [GLButton new];
            [self.contentView addSubview:hidePassWordBtn];
            
            [_textField setSecureTextEntry:YES];
            [_textField setKeyboardType:UIKeyboardTypeASCIICapable];
            
            if (_identifier == 2) {
                [_textField setPlaceholder:@"请输入6至16位密码"];
            } else {
                [_textField setPlaceholder:@"请再次输入密码"];
            }
            
            [hidePassWordBtn setGraphicLayoutState:PICCENTER];
            [hidePassWordBtn setTag:_identifier + 500];
            [hidePassWordBtn setImage:GL_IMAGE(@"dl_hide") forState:UIControlStateNormal];
            [hidePassWordBtn setImage:GL_IMAGE(@"dl_show") forState:UIControlStateSelected];
            [hidePassWordBtn addTarget:self action:@selector(hidePassWordClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [hidePassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.contentView);
                make.right.equalTo(ws.contentView.mas_right).offset(-16);
                make.size.mas_equalTo(CGSizeMake(37, 55));
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.contentView);
                make.left.equalTo(ws.contentView).offset(15);
                make.right.equalTo(ws.contentView.mas_right).offset(-15);
                make.size.mas_equalTo(CGSizeMake(150, 55));
            }];
        }
            break;
        default:
            break;
    }
}

- (void)hidePassWordClick:(UIButton *)sender
{
    _textField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}



@end
