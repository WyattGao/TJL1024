//
//  STMedicationCell.m
//  Diabetes
//
//  Created by 房克志 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STMedicationCell.h"
#import "STMedicineView.h"

#define IsMedical [[GL_USERDEFAULTS objectForKey:@"medicationCell"]isEqualToString:@"用药"]
#define lineColor RGB(241,241,245)

@implementation STMedicationCell
{
    NSArray  *textArray;
    UILabel  *lineLab1;
    NSInteger num;
    NSArray  *segArray;
//    UIButton *leftBtn;
//    UIButton *rightBtn;
    NSArray  *segNum;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle1:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:Style reuseIdentifier:[NSString stringWithFormat:@"%@",reuseIdentifier]];
    if (self) {
        if ([reuseIdentifier integerValue] == YPXX) {
            [self creatCell1];
        }else if ([reuseIdentifier integerValue] == BZXX){
            [self creatCell2];
        }else if ([reuseIdentifier integerValue] == FYSJ){
            [self creatCell3];
        }
    }
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)creatCell1
{
    [[[NSUserDefaults standardUserDefaults] objectForKey:@"medicationCell"]isEqualToString:@"用药"];
    if (IsMedical) {
        textArray = @[@"药品名称",@"服药剂量",@"服用方法"];

    }else
    {
        textArray = @[@"胰岛素名称",@"使用剂量",@"使用方法"];
    }
    self.titArray = [[NSMutableArray alloc]initWithArray:textArray];
    [self customOtherCell1];
    [self deBug];
}

- (void)customOtherCell1
{
    WS(ws);
    for (NSInteger i = 0; i<3; i++) {
        UILabel *lab  = [UILabel new];
        lab.text      = _titArray[i];
        lab.font      = GL_FONT(14);
        lab.textColor = RGB(19, 19, 19);
        
        [self.contentView addSubview:lab];
        
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10+43*i));
            make.left.equalTo(ws.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(90, 22));
        }];
        if (i == 0) {
            _cellLab1 = [UILabel new];
            if (IsMedical) {
                _cellLab1.text = @"请添加药品名称";
            }else
            {
                _cellLab1.text = @"请添加胰岛素名称";
            }
            _cellLab1.font          = GL_FONT((15));
            _cellLab1.textAlignment = NSTextAlignmentRight;
            _cellLab1.textColor     = RGB(207, 206, 206);
            [self.contentView addSubview:_cellLab1];
            [_cellLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(10));
                make.left.equalTo(lab.mas_right);
                make.right.equalTo(ws.contentView).offset(-40);
                make.height.equalTo(@22);
            }];
            _cellLab1.userInteractionEnabled = YES;
            UITapGestureRecognizer *gestureClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nameBtnClick:)];
            [_cellLab1 addGestureRecognizer:gestureClick];

        }
        UILabel *shortLab = [UILabel new];
        shortLab.backgroundColor = lineColor;
        [self.contentView addSubview:shortLab];
        [shortLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab.mas_bottom).offset(10);
            make.left.equalTo(ws.contentView).offset(15);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-15, 1));
        }];
        
        if ((i+1)%3 == 1) {
            UIButton *btn = [UIButton new];
            btn.tag = 100+i;
            [btn setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
            [self.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(10+43*i));
                make.right.equalTo(ws.contentView).offset(-13);
                make.height.mas_equalTo(@22);
            }];
            [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if((i+1)%3==2)
        {
            
            UILabel *tipLbl = [UILabel new];
            [self.contentView addSubview:tipLbl];
            
            tipLbl.font      = GL_FONT((14));
            tipLbl.textColor = RGB(19, 19, 19);
            if (IsMedical) {
                tipLbl.text      = @"mg";
            } else {
                tipLbl.text      = @"u";
            }

            _textField               = [GLTextField new];
            _textField.text          = @"";
            _textField.placeholder   = @"如3";
            _textField.glDelegate    = self;
            _textField.returnKeyType = UIReturnKeyDone;
            _textField.font          = GL_FONT((15));
            _textField.keyboardType  = UIKeyboardTypeNumbersAndPunctuation;
            _textField.borderWidth   = 0.5;
            _textField.borderColor   = RGBA(150, 150, 150, 0.46);
            _textField.textAlignment = NSTextAlignmentCenter;
            _textField.limitType     = GLTextFieldTypeDecimalPointAndDigital;
            
            [self.contentView addSubview:_textField];
            
            [tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(ws.contentView.mas_right).offset(-13);
                make.centerY.equalTo(_textField);
            }];
            
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(10+43*i));
                make.right.equalTo(tipLbl.mas_left).offset(-7);
                make.size.mas_equalTo(CGSizeMake(45, 22));
            }];
        }
        else
        {
            NSArray *selArray;
            if (IsMedical) {
                selArray = @[@"sel口服",@"sel嚼服"];
                segArray = @[@"口服",@"嚼服"];
                segNum   = @[@"1",@"2"];
                
            }else
            {
                selArray = @[@"sel皮下注射",@"sel胰岛素泵"];
                segArray = @[@"皮下注射",@"胰岛素泵"];
                segNum   = @[@"3",@"4"];

            }
            _leftBtn = [UIButton new];
            [_leftBtn setBackgroundImage:GL_IMAGE(selArray[0]) forState:UIControlStateSelected];
            [_leftBtn setBackgroundImage:GL_IMAGE(segArray[0]) forState:UIControlStateNormal];
            _leftBtn.selected = YES;
            _leftBtn.tag = 120;
            [_leftBtn addTarget:self action:@selector(BTNAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_leftBtn];
            [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(5+43*i));
                make.left.equalTo(ws.contentView.mas_right).offset(-166);
                make.size.mas_equalTo(CGSizeMake(76, 29));
            }];
            _rightBtn = [UIButton new];
            [_rightBtn setBackgroundImage:GL_IMAGE(selArray[1]) forState:UIControlStateSelected];
            [_rightBtn setBackgroundImage:GL_IMAGE(segArray[1]) forState:UIControlStateNormal];
            _rightBtn.tag = 121;
            [_rightBtn addTarget:self action:@selector(BTNAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_rightBtn];
            [_rightBtn mas_makeConstraints:^( MASConstraintMaker *make) {
                make.top.equalTo(_leftBtn);
                make.left.equalTo(_leftBtn.mas_right).offset(-1);
                make.size.equalTo(_leftBtn);
            }];
        
//            UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:segArray];
//            segmentControl.selectedSegmentIndex = 0;
//            segmentControl.backgroundColor = [UIColor clearColor];
//            segmentControl.tintColor = RGBA(64, 165, 243, 1);
//            [segmentControl setBackgroundImage:[UIImage imageWithColor:COL_MAIN_BLUE size:CGSizeMake(40, 25)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//            [self.contentView addSubview:segmentControl];
//            [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//            [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(@(5+43*i));
//                make.right.equalTo(ws.contentView).offset(-13);
//                make.size.mas_equalTo(CGSizeMake(150, 29));
//            }];

        }
    }
    [self creatLineView];
}

- (void)deBug
{
    if (_textField) {
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

- (void)BTNAction:(UIButton *)seg
{
    if (!seg.selected) {
        UIButton *btn;
        if (seg==_leftBtn) {
            btn = _rightBtn;
            _segmentBlock(segNum[0]);

        }else
        {
            btn = _leftBtn;
            _segmentBlock(segNum[1]);

        }
        seg.selected = YES;
        btn.selected = NO;
    }
    
    
}
- (void)creatCell2
{
    UILabel *lineLab2 = [UILabel new];
    lineLab2.backgroundColor = TCOL_BG;
    [self.contentView addSubview:lineLab2];
    WS(ws);
    [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView);
        make.top.equalTo(ws.contentView);
        make.bottom.equalTo(ws.contentView.mas_top).offset(8);
    }];
    
    UILabel * BZXXLabel = [UILabel new];
    BZXXLabel.text = @"备注信息";
    BZXXLabel.textColor = TCOL_MAIN;
    BZXXLabel.font = GL_FONT(16);
    [self.contentView addSubview:BZXXLabel];
    [BZXXLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(18);
        make.left.equalTo(ws.contentView).offset(40);
        make.size.mas_equalTo(CGSizeMake(150, 22));
    }];
    UIImageView *imgV = [UIImageView new];
    [self.contentView addSubview:imgV];
    imgV.image = GL_IMAGE(@"用药-备注");
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(BZXXLabel.mas_left).offset(-10);
        make.centerY.equalTo(BZXXLabel);
//        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    UILabel *lineLab = [UILabel new];
    lineLab.backgroundColor = lineColor;
    [self.contentView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BZXXLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    _BZTextView               = [UITextView new];
    _BZTextView.font          = GL_FONT((15));
    _BZTextView.returnKeyType = UIReturnKeyDone;
    _BZTextView.scrollEnabled = false;
    [self.contentView addSubview:_BZTextView];
    [_BZTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.contentView).offset(10 + 42);
        make.left.equalTo(ws.contentView).offset(8);
        make.right.equalTo(ws.contentView).offset(-8);
        make.bottom.equalTo(ws.contentView).offset(-8);
    }];
    _BZTextView.text = @"";
    [self creatLineView];
}

- (void)creatCell3
{
    NSArray *array;
    
    if (IsMedical) {
        array = @[@"服药时间"];
    }else
    {
        array = @[@"使用时间"];
    }
    
    for (NSInteger i = 0;i<1; i++) {
        UILabel * FYLabel = [UILabel new];
        FYLabel.text = array[i];
        FYLabel.textColor = TCOL_MAIN;
        FYLabel.font = GL_FONT(16);
        [self.contentView addSubview:FYLabel];
        WS(ws);
        [FYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(10+43*i);
            make.left.equalTo(ws.contentView).offset(40);
            make.size.mas_equalTo(CGSizeMake(70, 22));
        }];
        UIImageView *imgV = [UIImageView new];
        imgV.image        = GL_IMAGE(@"用药-时间");
        [self.contentView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(FYLabel.mas_left).offset(-10);
            make.centerY.equalTo(FYLabel);
//            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        UILabel *lineLab = [UILabel new];
        lineLab.backgroundColor = lineColor;
        [self.contentView addSubview:lineLab];
        [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(FYLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        }];
        _timeLab = [UILabel new];
        _timeLab.tag = 1000+i;
//        _timeLab.text = @"16:10 2016-03-02";
        _timeLab.text = @"请选择使用时间";
        _timeLab.font = GL_FONT(15);
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.textColor = RGB(207, 206, 206);
        _timeLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeTouch)];
        [_timeLab addGestureRecognizer:gesture];
        [self.contentView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(10+i*43);
            make.left.equalTo(FYLabel.mas_right);
            make.right.equalTo(ws.contentView).offset(-40);
            make.height.equalTo(@22);
        }];
        UIButton *btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(10+i*43);
            make.right.equalTo(ws.contentView).offset(-13);
            make.height.mas_equalTo(@22);
        }];

    }
    
}
- (void)timeTouch
{
    
    _addBlock(1);
}

- (void)nameBtnClick:(id)btn
{
    [self.superview endEditing:YES];

    STMedicineView *MedicineView = [[STMedicineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    MedicineView.medicineValue = ^(NSDictionary *dataDic){
        self.cellLab1.textColor = [UIColor blackColor];
        _medicineDic = dataDic;
        self.cellLab1.text = [dataDic getStringValue:@"name"];
        
        if (_medicBlock) {
            _medicBlock(dataDic);
        }
        
    };
    [[[UIApplication sharedApplication].delegate window] addSubview:MedicineView];
}

- (void)creatLineView
{
    UILabel *lineLab = [UILabel new];
    lineLab.backgroundColor = TCOL_BG;
    [self.contentView addSubview:lineLab];
    WS(ws);
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView);
        make.right.equalTo(ws.contentView);
        make.top.equalTo(ws.mas_bottom).offset(-8);
        make.bottom.equalTo(ws.contentView);
    }];
    
}


- (void)addBtnClick
{
    num +=2;
    if (num>6) {
        return;
    }
    _addBlock(num);

    [self customOtherCell1];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_delegate textFieldShouldBeginEditing:textField];
    return true;
}


- (void)selectClick:(UIButton *)btn
{
    
}



- (void)textViewDidChange:(UITextView *)textView
{
//    _BZTextView.attributedText = [Tools HangJianJu:textView.text andJianJu:4];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
