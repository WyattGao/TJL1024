//
//  STMedicineView.m
//  Diabetes
//
//  Created by 房克志 on 16/3/4.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STMedicineView.h"
#import "STNewMedicationCell.h"
@implementation STMedicineView
{
    NSMutableArray *_dataSource;
    NSMutableArray *_dataSource1;
    NSDictionary *_medicineDict;
    UIButton *btn;
    BOOL ableClick;
    NSString *_str;
    NSMutableArray *_selectArray;
    UITableView *_tableView;
}

#define IsMedical [[GL_USERDEFAULTS objectForKey:@"medicationCell"]isEqualToString:@"用药"]

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = [NSMutableArray new];
        _dataSource1 = [NSMutableArray new];

//        _downLoadArray = [NSMutableArray new];
        _selectArray = [NSMutableArray new];
        ableClick = NO;
        if (IsMedical) {
            _str = @"medicineArray";
        }else
        {
            _str = @"insulinArray";
        }
        _dataSource1 =  [NSMutableArray arrayWithArray:[GL_USERDEFAULTS objectForKey:_str]];
        
        NSString *highKey = [@"high" stringByAppendingString:_str];
        NSArray *highUseArr = [NSArray arrayWithArray:[GL_USERDEFAULTS objectForKey:highKey]];
        
        if (highUseArr.count) {
            [_dataSource1 removeObjectsInArray:highUseArr];
            [_dataSource1 insertObjects:highUseArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, highUseArr.count)]];
        }

        [self loadMedicineList];
        [self creatSegmentContron];
    }
    return  self;
}


- (void)loadMedicineList
{
    NSString *useType;
    if (IsMedical) {
        useType = @"0";
    }else
    {
        useType = @"1";
    }
    NSDictionary *dict = @{
        @"FuncName":@"queryDrugs",
        @"InField":@{
            @"ACCOUNT":USER_ACCOUNT,	//string 账号
            @"DEVICE":@"1",
            @"KEYWORDS":@"",	//string 关键字
            @"PAGE":@"1",
            @"PAGESIZE":@"10",
            @"TYPE":useType
        },
        @"OutField":@[]
        };
//    [AFrequest postWithDataDic:dict andTarget:self markStr:@"queryDrugs"];
    
    [GL_Requst postWithParameters:dict SvpShow:false success:^(GLRequest *request, id response) {
        if ([[[[response objectForKey:@"Result"] objectForKey:@"OutField"]objectForKey:@"RETVAL"]isEqualToString:@"S"]) {
            _dataSource = [[[response objectForKey:@"Result"]objectForKey:@"OutTable"] firstObject];
            _dataSource1 = [NSMutableArray arrayWithArray:[[[response objectForKey:@"Result"]objectForKey:@"OutTable"] firstObject]];
            
            NSString *highKey   = [@"high" stringByAppendingString:_str];
            NSArray *highUseArr = [NSArray arrayWithArray:[GL_USERDEFAULTS objectForKey:highKey]];
            //将使用频率高的药物放上去 2017年01月20日15:33:24
            if (highUseArr.count) {
                [_dataSource1 removeObjectsInArray:highUseArr];
                [_dataSource1 insertObjects:highUseArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, highUseArr.count)]];
            }
            
            
            _medicineDict = _dataSource[0];
            
            if (![_dataSource isEqualToArray:[GL_USERDEFAULTS objectForKey:_str]]) {
                [GL_USERDEFAULTS setObject:_dataSource forKey:_str];
                [_tableView reloadData];
            }
            
            ableClick = YES;
        }

    } failure:^(GLRequest *request, NSError *error) {
        GL_AFFAil;
        ableClick = YES;
    }];
}


- (void)dateClick:(UIButton *)sender
{
//    if (!ableClick && _dataSource.count >0) {
//        return;
//    }
    [UIView animateWithDuration:0.3f animations:^{
        [self viewWithTag:15].alpha = 0;
        [self viewWithTag:16].y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma  mark -- textViewdelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length>0) {
        [_selectArray removeAllObjects];
        if (_dataSource.count>0) {
            [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj getStringValue:@"name" ] rangeOfString:textField.text].location != NSNotFound) {
                    [_selectArray addObject:obj];
                }
            }];
//            [_dataSource removeAllObjects];
            _dataSource1 = _selectArray;
            [_tableView reloadData];
        }
    }else
    {
        _dataSource1 = [GL_USERDEFAULTS objectForKey:_str];
        [_tableView reloadData];
    }
    
    [textField resignFirstResponder];
    return YES;
}
- (void)creatSegmentContron
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    btn = [UIButton new];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    btn.backgroundColor = [UIColor blackColor];
    btn.alpha = 0;
    btn.tag = 15;
    [btn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    CGFloat topY = SCREEN_WIDTH *(275.f/262.f);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, topY)];
    view.alpha = 1;
    view.backgroundColor = [UIColor whiteColor];
    view.tag = 16;
    [self addSubview:view];
    
//    [view addSubview:_textfield];
    
    UIView *topView = [UIView new];
    [view addSubview:topView];
    topView.backgroundColor = RGB(255, 255, 255);
    topView.layer.cornerRadius = 8.f;
    topView.layer.borderWidth  =0.5f;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(55);
        make.right.equalTo(view).offset(-55);
        make.top.equalTo(view).offset(25);
        make.height.equalTo(@30);
    }];
    
    UIImageView *leftImgView = [UIImageView new];
    [topView addSubview:leftImgView];
    leftImgView.image = GL_IMAGE(@"iconfont-sousuo");
    [leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15);
        make.centerY.equalTo(topView);
    }];
    
//    _textfield.backgroundColor = RGB(245, 245, 245);
    _textfield = [UITextField new];
    _textfield.clearButtonMode = UITextFieldViewModeAlways;
    [topView addSubview:_textfield];
    _textfield.placeholder = @"搜索药品信息";
    _textfield.font = GL_FONT(15);
    _textfield.delegate = self;
    _textfield.returnKeyType = UIReturnKeyDone;
    _textfield.layer.cornerRadius = 5;
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView);
        make.left.equalTo(topView).offset(30);
        make.right.equalTo(topView);
        make.height.equalTo(@30);
    }];
    UIButton *closeBtn = [UIButton new];
    [view addSubview:closeBtn];
    [closeBtn setImage:GL_IMAGE(@"iconfont-guanbi") forState:UIControlStateNormal];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textfield.mas_right).offset(20);
        make.centerY.equalTo(_textfield);
    }];
    [closeBtn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel *lineLab = [UILabel new];
//    lineLab.backgroundColor = LINE_COLOR;
//    [view addSubview:lineLab];
//    
//    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_textfield.mas_bottom).offset(8);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
//    }];
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.equalTo(view).offset(80);
        make.bottom.equalTo(view);
        make.right.equalTo(view);
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        view.y = SCREEN_HEIGHT-topY;
        btn.alpha = 0.5f;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    STNewMedicationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[STNewMedicationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.titLab.text = [_dataSource1[indexPath.row] getStringValue:@"name"];;
//    cell.iconImgView.image = GL_IMAGE(@"检测手表");
    if (_textfield.text.length>0) {
        //现实不同颜色
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.titLab.text];
        
         NSRange RangeTwo = NSMakeRange([cell.titLab.text rangeOfString:_textfield.text].location, [cell.titLab.text rangeOfString:_textfield.text].length);
        [str addAttribute:NSForegroundColorAttributeName value:TCOL_MAIN range:RangeTwo];
        [cell.titLab setAttributedText:str];
    }
    [cell.iconImgView sd_setImageWithURL:GL_URL([_dataSource1[indexPath.row] getStringValue:@"pic"])];
    cell.iconBlock = ^(UIImageView *imgView)
    {
        if (imgView.image) {
            _picView = [[PictureExaminationView alloc]initWithPics:@[imgView.image] Withindex:0];
            
            _picView.yBtn.hidden = YES;
            UIWindow *keyv    = [[UIApplication sharedApplication] keyWindow];
            [keyv addSubview: _picView];
            
            _picView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            [UIView animateWithDuration:0.3 animations:^{
                _picView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } completion:^(BOOL finished) {
            }];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //将点最近点选率高的药物放到上面
    NSString *highKey = [@"high" stringByAppendingString:_str];
    NSMutableArray *highUseArr = [NSMutableArray arrayWithArray:[GL_USERDEFAULTS objectForKey:highKey]];
    _medicineDict = _dataSource1[indexPath.row];
    if ([highUseArr containsObject:_medicineDict]) {
        [highUseArr removeObject:_medicineDict];
    }
    [highUseArr insertObject:_medicineDict atIndex:0];
    [GL_USERDEFAULTS setObject:highUseArr forKey:highKey];
    
    _medicineValue(_medicineDict);
    [self dateClick:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
- (void)ConfirmClick
{
    if (_medicineDict) {
        _medicineValue(_medicineDict);
        [self removeFromSuperview];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
