//
//  STSportController.m
//  Diabetes
//
//  Created by 高临原 on 16/3/8.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STSportController.h"
#import "STSelPickerView.h"
#import "STSelectDateView.h"

@interface STSportController()<GetSelTextDelegate,SelecteDateDelegate>
{
    NSString *saveDate;
}

@end

@implementation STSportController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNav];
    [self makeUI];
    
    saveDate = [[NSDate date] toString:@"yyyy-MM-dd HH:mm:ss"];
}


- (void)setNav{
    [self setNavTitle:@"运动"];
    
    [self setLeftBtnImgNamed:nil];
}

- (void)makeUI{
    self.view.backgroundColor = TCOL_BGGRAY;
    
    NSArray *titleArr = @[@"时间",@"类型",@"持续时间"];
    
    NSArray *iconArr  = @[@"用药-时间",@"记录运动",@"饮食-使用时间"];
    
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        UILabel *titleLab = [UILabel new];
        [btn addSubview:titleLab];
        UIImageView *img = [UIImageView new];
        [btn addSubview:img];
        UILabel *connectLab = [UILabel new];
        [btn addSubview:connectLab];
        UIView *line = [UIView new];
        [btn addSubview:line];
        
        UIImageView *iconImg = [UIImageView new];
        [self.view addSubview:iconImg];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@12);
            make.centerY.equalTo(btn);
            make.size.mas_equalTo(CGSizeMake(18, 19));
        }];
        iconImg.image = GL_IMAGE(iconArr[idx]);
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 42));
            make.top.mas_equalTo(64 + 8+idx*42);
        }];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.centerY.mas_equalTo(btn.mas_centerY);
        }];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn.mas_centerY);
            make.right.mas_equalTo(btn.mas_right).offset(-12);
        }];
        [connectLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(btn.mas_right).offset(-42);
            make.centerY.mas_equalTo(btn.mas_centerY);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(btn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        }];
        
        titleLab.text = titleArr[idx];
        titleLab.textColor = RGB(74, 74, 74);
        titleLab.font = connectLab.font = [UIFont systemFontOfSize:15];
        connectLab.text = @"";
        connectLab.textColor = RGB(93, 93, 93);
        connectLab.tag = 2342350+idx;
        
        if (_entity) {
            switch (idx) {
                case 0:connectLab.text = [[_entity.MOTIONTIME toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"aakk:mm yyyy-MM-dd"];break;  //运动时间
                case 1:connectLab.text = _entity.MOTIONTYPE;break;  //运动类型
                case 2:connectLab.text = _entity.DURATIONTIME;break;//运动时长
                default:
                    break;
            }
        } else {
            if (!idx) {
                connectLab.text = [[NSDate date] toString:@"aakk:mm yyyy-MM-dd"];
            }
        }
        
        line.backgroundColor = RGB(245, 245, 250);
        
        img.image = GL_IMAGE(@"右箭头_灰色");
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 2342340+idx;
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_isHideSavaBtn) {
            btn.userInteractionEnabled = false;
        }
    }];
    
    if (!_isHideSavaBtn) {
        UIButton *saveBtn = [UIButton new];
        [self.view addSubview:saveBtn];
        saveBtn.layer.cornerRadius = 5.0f;
        saveBtn.clipsToBounds = YES;
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-40);
            make.size.mas_equalTo(CGSizeMake(300, 40));
            make.centerX.equalTo(self.view);
        }];
        saveBtn.backgroundColor = TCOL_MAIN;
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:(17)];
        [saveBtn addTarget:self action:@selector(saveOK) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - - 事件
- (void)saveOK{
    [self saveBloodMotion];
}

- (void)btnDown:(UIButton*)sender{
    NSLog(@"%ld",sender.tag);
    
    NSInteger tag = sender.tag-2342340;
    switch (tag) {
        case 0:
        {
            STSelectDateView *selDateView = [[STSelectDateView alloc]initWithType:DateTime];
            [GL_KEYWINDOW addSubview:selDateView];
            selDateView.delegate = self;
            
            [selDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(GL_KEYWINDOW);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            }];
        }
            break;
        case 1:
        {
            STSelPickerView *pickerView = [[STSelPickerView alloc]initWithTextArr:@[@"休闲运动",@"剧烈运动",@"放松运动"]];
            pickerView.tag = 100;
            pickerView.delegate = self;
            [pickerView show];
        }
            break;
            
        case 2:
        {
            NSMutableArray *tmpArr = [NSMutableArray new];
            for (NSInteger i = 0;i < 24;i++) {
                [tmpArr addObject:[NSString stringWithFormat:@"%ld分钟",5 * (i + 1)]];
            }
            STSelPickerView *pickerView = [[STSelPickerView alloc]initWithTextArr:tmpArr];
            pickerView.tag = 23423;
            pickerView.delegate = self;
            [pickerView show];
        }
            break;
        default:
            break;
    }
    
    
}

- (void)getSelecteDataWithDate:(NSDate *)date
{
    UILabel *lab = (UILabel*)[self.view viewWithTag:2342350];
    lab.text  =  [date toString:@"aakk:mm yyyy-MM-dd"];
    
    saveDate = [date toString:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)getSelText:(STSelPickerView *)picker{
    UILabel *lab;
    if (picker.tag==23423) {
        lab = (UILabel*)[self.view viewWithTag:2342352];
    }else{
        lab = (UILabel*)[self.view viewWithTag:2342351];
        
    }
    lab.text     = picker.myLbl.text;
}

- (void)saveBloodMotion{
    UILabel *timLab = (UILabel *)[self.view viewWithTag:2342350];
    UILabel *typeLab = (UILabel*)[self.view viewWithTag:2342351];
    UILabel *longTimeLab = (UILabel*)[self.view viewWithTag:2342352];
    if ([timLab.text isEqualToString:@""]||[typeLab.text isEqualToString:@""]||[longTimeLab.text isEqualToString:@""]) {
        GL_ALERT_1(@"请填写信息");
        return;
    }
    NSString *long1 =  [longTimeLab.text substringToIndex:longTimeLab.text.length-2];
    
    if (typeLab.text.length==0 || longTimeLab.text.length==0 || long1.length==0) {
        [SVProgressHUD showErrorWithStatus:@"数据不能为空!"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"FuncName":@"saveBloodMotion",
                          @"InField":@{
                                  @"DEVICE":@"1",		//0:android 1:ios
                                  @"ID":@"",		//运动id
                                  @"ACCOUNT":USER_ACCOUNT,	//用户账号
                                  @"MOTIONTIME":saveDate,	//运动时间
                                  @"MOTIONTYPE":typeLab.text,	//类型:休闲运动,剧烈运动,放松运动,计步器
                                  @"STEPSNUM":@"",		//步数
                                  @"DURATIONTIME":long1		//运动时长
                                  },
                          @"OutField":@[
                                  @"RETVAL",
                                  @"RETMSG"
                                  ]
                          };
    [GL_Requst postWithParameters:dic SvpShow:true success:^(GLRequest *request, id response) {
        NSDictionary *myDic = response;
        if ([myDic[@"Tag"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [self navLeftBtnClick:nil];
            
            if (_refreshSportRecord) {
                _refreshSportRecord();
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"保存失败，请检查网络"];
        }
    } failure:^(GLRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败，请检查网络"];
    }];
}


@end
