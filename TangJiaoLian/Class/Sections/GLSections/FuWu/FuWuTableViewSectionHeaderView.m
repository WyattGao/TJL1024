//
//  FuWuTableViewSectionHeaderView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FuWuTableViewSectionHeaderView.h"

@implementation FuWuTableViewSectionHeaderView

- (void)checkAllDocBtnClick:(UIButton *)sender
{
    if (_checkAllDoc) {
        _checkAllDoc();
    }
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.picReView];
    [self addSubview:self.checkAllDocBtn];
    
    WS(ws);
    
    [self.checkAllDocBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).with.insets(UIEdgeInsetsMake(120, 0, 0, 0));
    }];
}

- (GLPicReincarnationView *)picReView
{
    if (!_picReView) {
        _picReView = [[GLPicReincarnationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) WithPics:@[[UIImage imageNamed:@"图片占位"]] WithTitles:nil];
    }
    return _picReView;
}

- (UIButton *)checkAllDocBtn
{
    if (!_checkAllDocBtn) {
        _checkAllDocBtn = [UIButton new];
        
        [_checkAllDocBtn addTarget:self action:@selector(checkAllDocBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iconIV  = [[UIImageView alloc]initWithImage:GL_IMAGE(@"服务-hi")];
        UILabel *titleLbl    = [UILabel new];
        UILabel *checkLbl    = [UILabel new];
        UIImageView *rightIV = [[UIImageView alloc]initWithImage:GL_IMAGE(@"右箭头-绿")];
        UIView  *lineView    = [UIView new];
        
        [_checkAllDocBtn addSubview:iconIV];
        [_checkAllDocBtn addSubview:titleLbl];
        [_checkAllDocBtn addSubview:checkLbl];
        [_checkAllDocBtn addSubview:rightIV];
        [_checkAllDocBtn addSubview:lineView];
        
        titleLbl.text            = @"与TA对话";
        titleLbl.font            = GL_FONT(14);
        titleLbl.textColor       = TCOL_NORMALETEXT;

        checkLbl.text            = @"全部";
        checkLbl.font            = GL_FONT(14);
        checkLbl.textColor       = TCOL_MAIN;

        lineView.backgroundColor = TCOL_LINE;
        
        [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_checkAllDocBtn.mas_left).offset(7.5);
            make.centerY.equalTo(_checkAllDocBtn);
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconIV.mas_right).offset(2.8);
            make.centerY.equalTo(iconIV);
        }];
        
        [checkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightIV.mas_left).offset(-2);
            make.centerY.equalTo(rightIV);
        }];
        
        [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_checkAllDocBtn.mas_right).offset(-6);
            make.centerY.equalTo(_checkAllDocBtn);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_checkAllDocBtn.mas_bottom);
            make.centerX.equalTo(_checkAllDocBtn);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5f));
        }];
    }
    return _checkAllDocBtn;
}

@end
