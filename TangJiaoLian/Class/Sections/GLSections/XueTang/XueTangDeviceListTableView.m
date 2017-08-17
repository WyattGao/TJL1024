//
//  XueTangDeviceListTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangDeviceListTableView.h"
#import "XueTangDeviceListHeader.h"
#import "UIImage+EMGIF.h"

@interface XueTangDeviceListTableView ()

@property (nonatomic,strong) XueTangDeviceListHeader *header;

//加载动图
@property (nonatomic,strong) UIImageView *blocksGifIV;

@end

@implementation XueTangDeviceListTableView

- (void)createUI
{
    [self setBackgroundColor:TCOL_BG];
    [self setSectionView:self.header];
    [self setUpCellHeight:40 CellIdentifier:@"cell" CellClassName:NSStringFromClass([XueTangDeviceListCell class])];
    
    [self addSubview:self.blocksGifIV];
    
    WS(ws);
    
    [self.blocksGifIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
}

- (XueTangDeviceListHeader *)header
{
    if (!_header) {
        _header = [[XueTangDeviceListHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 107)];
    }
    return _header;
}

- (UIImageView *)blocksGifIV
{
    if (!_blocksGifIV) {
        _blocksGifIV = [UIImageView new];
        [_blocksGifIV setImage:[UIImage sd_animatedGIFNamed:@"Blocks"]];
    }
    return _blocksGifIV;
}

- (void)setStatus:(GLConnectionStatus)status
{
    switch (status) {
        case GLConnectionUnfinished:
            self.blocksGifIV.hidden       = false;
            self.header.refreshBtn.hidden = true;
            self.header.titleLbl.text     = @"搜索中...";
            break;
        case GLConnectionSucceed:
            self.blocksGifIV.hidden       = true;
            self.header.refreshBtn.hidden = false;
            self.header.titleLbl.text     = @"请选择设备";
            break;
        default:
            break;
    }
}

@end
