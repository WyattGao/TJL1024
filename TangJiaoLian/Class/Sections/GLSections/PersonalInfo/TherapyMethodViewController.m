//
//  TherapyMethodViewController.m
//  SuiTangNew
//
//  Created by 高临原 on 2017/1/3.
//  Copyright © 2017年 随糖. All rights reserved.
//

#import "TherapyMethodViewController.h"

@interface TherapyMethodViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTV;

@property (nonatomic,strong) NSArray *titleArr;

@property (nonatomic,strong) NSMutableArray *selArr;

@end

const static NSInteger kSelBoxBtnTag = 180;

@implementation TherapyMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initNav];
    [self initUI];

}

- (void)initData
{
    _titleArr = @[@"饮食控制",@"运动控制",@"口服药",@"胰岛素",@"暂无"];
}

- (void)initNav
{
    [self setNavTitle:@"治疗方式"];
    [self setLeftBtnImgNamed:nil];
}

- (void)initUI
{
    _mainTV = [UITableView new];
    [self.view addSubview:_mainTV];
    _mainTV.delegate       = self;
    _mainTV.dataSource     = self;
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTV.backgroundColor= TCOL_BG;
    
    WS(ws);
    
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.bottom.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.equalTo(ws.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell            = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
    cell.selectionStyle              = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = RGB(255, 255, 255);
    
    GLButton *selBoxBtn   = [GLButton new];
    UIView   *line        = [UIView new];
    
    [cell.contentView addSubview:selBoxBtn];
    [cell.contentView addSubview:line];
    
    [selBoxBtn setTitle:_titleArr[indexPath.row] forState:UIControlStateNormal];
    [selBoxBtn.lbl setFont:GL_FONT(15)];
    [selBoxBtn setTitleColor:RGB(19, 19, 19) forState:UIControlStateNormal];
    [selBoxBtn setTag:indexPath.row + kSelBoxBtnTag];
    [selBoxBtn setImage:GL_IMAGE(@"复选框-未选中") forState:UIControlStateNormal];
    [selBoxBtn setImage:GL_IMAGE(@"复选框-选中") forState:UIControlStateSelected];
    [selBoxBtn setUserInteractionEnabled:false];
    
    line.backgroundColor = RGB(241, 241, 245);
    
    [_therapyMethodArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:_titleArr[indexPath.row]]) {
            [selBoxBtn setSelected:true];
        }
    }];
    
    [selBoxBtn.lbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selBoxBtn.iv.mas_right).offset(7);
        make.centerY.equalTo(selBoxBtn);
    }];
    
    [selBoxBtn.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.left.equalTo(selBoxBtn);
        make.centerY.equalTo(selBoxBtn);
    }];
    
    [selBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(25);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(15);
        make.bottom.equalTo(cell.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 0.5));
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLButton *btn = [self.view viewWithTag:indexPath.row + kSelBoxBtnTag];
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1 && !btn.selected) {
        [_therapyMethodArr removeAllObjects];
        [_therapyMethodArr addObject:@"暂无"];
        
        for (NSInteger i = 0;i < [tableView numberOfRowsInSection:0] - 1;i++) {
            GLButton *tmpBtn = [self.view viewWithTag:i + kSelBoxBtnTag];
            tmpBtn.selected  = false;
        }
    } else {
        if (!btn.selected) {
            [_therapyMethodArr addObject:btn.lbl.text];
        } else {
            [_therapyMethodArr removeObject:btn.lbl.text];
        }
        
        GLButton *tmpBtn = [self.view viewWithTag:[tableView numberOfRowsInSection:0] - 1 + kSelBoxBtnTag];
        if (tmpBtn.selected) {
            [_therapyMethodArr removeObject:tmpBtn.lbl.text];
            tmpBtn.selected = false;
        }
        
    }
    
    btn.selected = !btn.selected;
}

- (void)navLeftBtnClick:(UIButton *)sender
{
    [super navLeftBtnClick:sender];
    if ([self.delegate respondsToSelector:@selector(changeTherapyMethodArr:)]) {
        [self.delegate changeTherapyMethodArr:[NSArray arrayWithArray:_therapyMethodArr]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
