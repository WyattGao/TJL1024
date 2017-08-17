//
//  STPersonInfoCell.m
//  Diabetes
//
//  Created by 高临原 on 16/3/4.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STPersonInfoCell.h"

@interface STPersonInfoCell ()

@property (nonatomic,strong) UIImageView *rightIV;
@property (nonatomic,strong) UIView      *line;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) NSUserDefaults *U;

@end

@implementation STPersonInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        if ([reuseIdentifier isEqualToString:lastRow]) {
            //每段最后一行加间隔
            self.contentView.backgroundColor = TCOL_BGGRAY;
        } else {
            _U = [NSUserDefaults standardUserDefaults];
            _userBaseDic = [NSMutableDictionary new];
            _patientDic  = [NSMutableDictionary new];
            
            _row      = [reuseIdentifier integerValue] % 10;
            _section  = [reuseIdentifier integerValue] / 10;
            
            _leftLbl  = [UILabel new];/**< 左侧标题Lbl */
            _rightLbl = [UILabel new];
            _rightIV  = [UIImageView new];
            _line     = [UIView  new];
            
            [self.contentView addSubview:_leftLbl];
            [self.contentView addSubview:_rightLbl];
            [self.contentView addSubview:_rightIV];
            [self.contentView addSubview:_line];
            
            _leftLbl.font           = GL_FONT((15));
            _leftLbl.textColor      = RGB(74,74,74);
            _leftLbl.textAlignment  = NSTextAlignmentLeft;
            
            _rightLbl.font          = GL_FONT((15));
            _rightLbl.textColor     = RGB(155, 155, 155);
            _rightLbl.textAlignment = NSTextAlignmentRight;
            
            _rightIV.image          = [UIImage imageNamed:@"右箭头"];
            
            _line.backgroundColor   = RGB(241, 241, 245);
            
            if (!_section) {
                _leftLbl.text       = @[@"头像",@"昵称",@"性别",@"出生日期",@"绑定手机号",@"我的邀请码"][_row];
            } else {
                _leftLbl.text       = @[@"糖尿病类型",@"确诊时间(病史)",@"治疗方式",@"身高",@"体重",@"腰围",@"BMI",@"心率",@"血压"][_row];
            }
            
            WS(ws);
            
            [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.contentView);
                make.left.equalTo(ws.contentView).offset(15);
            }];
            
            [_rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(ws.contentView);
                make.right.equalTo(ws.contentView.mas_right).offset(-12);
            }];
            
            [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(ws.contentView.mas_right).offset(-35);
                make.centerY.equalTo(ws.contentView);
                make.width.mas_equalTo(SCREEN_WIDTH - 130);
            }];
            
            [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.contentView.mas_bottom);
                make.left.equalTo(ws.contentView.mas_left).offset(15);
                make.right.equalTo(ws.contentView.mas_right);
                make.height.equalTo(@(1));
            }];
            
            if (!_section) {
                
                switch (_row) {
                    case 0:
                    {
                        _picIV = [UIImageView new];
                        [ws.contentView addSubview:_picIV];
                        
                        _picIV.image               = [UIImage imageNamed:@"用户默认头像"];
                        _picIV.layer.cornerRadius  = 8;
                        _picIV.layer.masksToBounds = YES;
                        
                        [_picIV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(ws.contentView);
                            make.right.equalTo(ws.contentView.mas_right).offset(-38);
                            make.size.mas_equalTo(CGSizeMake(56, 56));
                        }];
                    }
                        break;
                    case 1:
                        break;
                    case 2:
                    {
                        _rightIV.hidden = YES;
                        
                        _maleBtn   = [UIButton new];
                        _maleLbl   = [UILabel  new];
                        _femaleBtn = [UIButton new];
                        _femaleLbl = [UILabel  new];
                        
                        [self.contentView addSubview:_maleBtn];
                        [self.contentView addSubview:_maleLbl];
                        [self.contentView addSubview:_femaleLbl];
                        [self.contentView addSubview:_femaleBtn];
                        
                        [_maleBtn setImage:[UIImage imageNamed:@"单选框未选中"] forState:UIControlStateNormal];
                        [_maleBtn setImage:[UIImage imageNamed:@"单选框选中绿"] forState:UIControlStateSelected];
                        [_maleBtn addTarget:self action:@selector(selSexClick:) forControlEvents:UIControlEventTouchUpInside];
                        [_femaleBtn setImage:[UIImage imageNamed:@"单选框未选中"] forState:UIControlStateNormal];
                        [_femaleBtn setImage:[UIImage imageNamed:@"单选框选中粉"] forState:UIControlStateSelected];
                        [_femaleBtn addTarget:self action:@selector(selSexClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        _maleLbl.font        = GL_FONT((16));
                        _maleLbl.textColor   = RGB(155, 155, 155);
                        _maleLbl.text        = @"男";
                        
                        _femaleLbl.font      = GL_FONT((16));
                        _femaleLbl.textColor = RGB(155, 155, 155);
                        _femaleLbl.text      = @"女";
                        
                        
                        [_maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(_maleLbl.mas_left).offset(5);
                            make.centerY.equalTo(_maleLbl);
                            make.size.mas_equalTo(CGSizeMake(42, 42));
                        }];
                        
                        [_maleBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(15, 15));
                        }];
                        
                        [_maleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(_femaleBtn.mas_left).offset(-3.5);
                            make.centerY.equalTo(ws.contentView);
                        }];
                        
                        [_femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(_femaleLbl.mas_left).offset(5);
                            make.centerY.equalTo(ws.contentView);
                            make.size.mas_equalTo(CGSizeMake(42, 42));
                        }];
                        
                        [_femaleBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(15, 15));
                        }];
                        
                        [_femaleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(ws.contentView.mas_right).offset(-12);
                            make.centerY.equalTo(ws.contentView);
                        }];
                    }
                        break;
                    case 5:
                    {
                        _rightIV.hidden = YES;
                        _codeLable = [UILabel new];
                        [self.contentView addSubview:_codeLable];
                        _codeLable.textColor = RGB(155, 155, 155);
                        _codeLable.font = GL_FONT(15);
                        [_codeLable mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(ws.contentView.mas_right).offset(-35);
                            make.centerY.equalTo(ws.contentView);
                        }];
                        _codeLable.text = @"dsds";
                        break;
                    }
                    default:
                        break;
                }
            }
        }
    }
    
    return self;
}

- (void)selSexClick:(UIButton *)sender
{
    if (!sender.selected) {
        if (sender == _maleBtn) {
            [_delegate changeSex:@"0"];
            _maleBtn.selected    = YES;
            _maleLbl.textColor   = TCOL_MAIN;
            _femaleBtn.selected  = NO;
            _femaleLbl.textColor = RGB(155, 155, 155);
        } else {
            [_delegate changeSex:@"1"];
            _femaleBtn.selected  = YES;
            _femaleLbl.textColor = RGBA(248,49,82,0.70);
            _maleBtn.selected    = NO;
            _maleLbl.textColor   = RGB(155, 155, 155);
        }
    }
}

- (void)reloadData
{
    if (!_section) {
        switch (_row) {
            case 0:
                [_picIV sd_setImageWithURL:[NSURL URLWithString:[_U getStringValue:@"PIC"]] placeholderImage:GL_IMAGE(@"用户默认头像")];
                break;
            case 1:_rightLbl.text = [_userBaseDic getStringValue:@"USERNAME"]; break;
            case 2:
                if ([[_patientDic getStringValue:@"SEX"] isEqualToString:@"0"]) {
                    [self selSexClick:_maleBtn];
                } else if ([[_patientDic getStringValue:@"SEX"] isEqualToString:@"1"]) {
                    [self selSexClick:_femaleBtn];
                }
                break;
            case 3:_rightLbl.text = [_userBaseDic getStringValue:@"BIRTHDAY"];break;
            case 4:
            {
                NSMutableString *str = [[NSMutableString alloc]initWithString:[_U getStringValue:@"PHONE"]];
                if (str.length) {
                    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    _rightLbl.text = str;
                }
            }
                break;
            default:break;
        }
    } else {
        switch (_row) {
            case 0:
                if ([[_patientDic getStringValue:@"DIABETESTYPE"] length]) {
                    switch ([_patientDic getIntegerValue:@"DIABETESTYPE"]) {
                        case 1:_rightLbl.text = @"1型糖尿病";break;
                        case 2:_rightLbl.text = @"2型糖尿病";break;
                        case 3:_rightLbl.text = @"妊娠糖尿病";break;
                        case 4:_rightLbl.text = @"特殊糖尿病";break;
                        default:break;
                    }
                }
                break;
            case 1:
                if ([[_patientDic getStringValue:@"ILLYEARS"] length]) {
                    _rightLbl.text = [NSString stringWithFormat:@"%@年",[_patientDic getStringValue:@"ILLYEARS"]];
                }
                break;
            case 2:
            {
                NSArray *arr = [_patientDic getArrValue:@"TREATTYPE"];
                if ([arr count]) {
                    _rightLbl.text = [arr componentsJoinedByString:@","];
                }
            }
                break;
            case 3:
                if ([[_patientDic getStringValue:@"HEIGHT"] length]){
                    _rightLbl.text =[NSString stringWithFormat:@"%@cm",[_patientDic getStringValue:@"HEIGHT"]];
                }
                break;
            case 4:
                if ([[_patientDic getStringValue:@"WEIGHT"] length]) {
                    _rightLbl.text = [NSString stringWithFormat:@"%@kg",[_patientDic getStringValue:@"WEIGHT"]];
                }
                break;
            case 5:
                if ([[_patientDic getStringValue:@"WAISTLINE"] length]) {
                    _rightLbl.text = [NSString stringWithFormat:@"%@cm",[_patientDic getStringValue:@"WAISTLINE"]];
                }
                break;
            case 6:{
                if ([[_patientDic getStringValue:@"BMI"] length]) {
                    _rightLbl.text = [_patientDic getStringValue:@"BMI"];
                } else {
                    double height = [_patientDic getDoubleValue:@"HEIGHT"];
                    double weight = [_patientDic getDoubleValue:@"WEIGHT"];
                    
                    if (height && weight) {
                        if ((height >= 100&&height <= 300)&&(weight >= 30 && weight <= 300))
                        {
                            _rightLbl.text =  [NSString stringWithFormat:@"%.1f",weight/((height/100)*(height /100))];
                            [_patientDic setObject:_rightLbl.text forKey:@"BMI"];
                        }
                    }
                    
                }
            }
                break;
            case 7:
                if ([[_patientDic getStringValue:@"HEARTRATE"] length] && [_patientDic getIntegerValue:@"HEARTRATE"]) {
                    _rightLbl.text =[NSString stringWithFormat:@"%@次/分",[_patientDic getStringValue:@"HEARTRATE"]];
                }
                break;
            case 8:
                if ([[_patientDic getStringValue:@"HIGHESTHYPERTENSION"] length] && [_patientDic getIntegerValue:@"HIGHESTHYPERTENSION"]) {
                    _rightLbl.text = [NSString stringWithFormat:@"高压%@ 低压%@",[_patientDic getStringValue:@"HIGHESTHYPERTENSION"],[_patientDic getStringValue:@"LOWESTHYPERTENSION"]];
                }
                break;
            default:
                break;
        }
    }
}



@end
