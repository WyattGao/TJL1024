//
//  FuWuSearchBarView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "FuWuSearchBarView.h"

@interface FuWuSearchBarView ()<GLTextFieldDelegate>

@end

@implementation FuWuSearchBarView

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_searchTFClick) {
        _searchTFClick();
    }
    
    return false;
}

- (void)createUI
{
    self.backgroundColor = TCOL_MAIN;
    
    [self addSubview:self.searchTF];
    
    WS(ws);
    
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).offset(25);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 30));
        make.centerX.equalTo(ws);
    }];
}

- (GLTextField *)searchTF
{
    if (!_searchTF) {
        _searchTF = [GLTextField new];
        _searchTF.font            = GL_FONT(15);
        _searchTF.glPlaceLbl.text = @"搜索医生或者营养师";
        _searchTF.backgroundColor = TCOL_BG;
        _searchTF.cornerRadius    = 5;
        _searchTF.glDelegate      = self;
        [_searchTF.glPlaceLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_searchTF);
        }];
    }
    return _searchTF;
}

@end
