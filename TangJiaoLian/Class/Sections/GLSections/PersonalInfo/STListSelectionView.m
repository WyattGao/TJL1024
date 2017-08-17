//
//  STListSelectionView.m
//  Diabetes
//
//  Created by 高临原 on 16/3/7.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STListSelectionView.h"

@interface STListSelectionView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTV;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) NSArray *listArr;

@end

@implementation STListSelectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _listArr = [NSArray arrayWithObjects:@"无",@"1型糖尿病",@"2型糖尿病",@"妊娠糖尿病",@"特殊糖尿病",nil];
        
        _backBtn = [UIButton    new];
        _mainTV  = [UITableView new];
        
        [self addSubview:_backBtn];
        [self addSubview:_mainTV];
        
        _backBtn.backgroundColor = RGBA(74, 74, 74,0.3);
        [_backBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        _mainTV.delegate         = self;
        _mainTV.dataSource       = self;
        _mainTV.separatorStyle   = UITableViewCellSeparatorStyleNone;
        _mainTV.bounces          = NO;

        WS(ws);
        
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(ws);
            make.center.equalTo(ws);
        }];
        
        [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 13 * 2, 52 * _listArr.count));
            make.center.equalTo(ws);
        }];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
        
        UIView  *line = [UIView new];
        UILabel *lbl  = [UILabel new];
        
        [cell.contentView addSubview:line];
        [cell.contentView addSubview:lbl];
        
        line.backgroundColor = RGB(241, 241, 245);

        lbl.font             = GL_FONT(18);
        lbl.text             = _listArr[indexPath.row];
        lbl.textColor        = TCOL_MAIN;
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(_mainTV.width - 26 * 2, 1));
        }];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
        }];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.delegate respondsToSelector:@selector(getListSelText:)]) {
        [self.delegate getListSelText:_listArr[indexPath.row]];
    }
    
    if ([self.delegate respondsToSelector:@selector(getListSelView:)]) {
        _selText = _listArr[indexPath.row];
        [self.delegate getListSelView:self];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)closeClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show
{
    [GL_KEYWINDOW addSubview:self];    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(GL_KEYWINDOW);
        make.size.equalTo(GL_KEYWINDOW);
    }];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
//
}
@end
