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
#import "DeviceListEntity.h"

@interface XueTangDeviceListTableView ()

@property (nonatomic,strong) XueTangDeviceListHeader *header;

//加载动图
@property (nonatomic,strong) UIImageView *blocksGifIV;

@property (nonatomic,assign) NSInteger selectCellIndex; /**< 选中cell的下标 */

@end

@implementation XueTangDeviceListTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectCellIndex = indexPath.row;
    [tableView reloadData];
}

- (void)createUI
{
    [self setBackgroundColor:TCOL_BG];
    [self setSectionView:self.header];
    [self setStatus:SearchDeviceStatusNone];

    [self setUpCellHeight:40 CellIdentifier:@"cell" CellClassName:NSStringFromClass([XueTangDeviceListCell class])];
    
    [self addSubview:self.blocksGifIV];
    [self addSubview:self.retryBtn];
    
    WS(ws);
    
    [self.blocksGifIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
    }];
    
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.size.mas_equalTo(CGSizeMake(140, 50));
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XueTangDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell) {
        cell = [[XueTangDeviceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
    }
    cell.entity = [self.tbDataSouce objectAtIndex:indexPath.row];
    if (indexPath.row == _selectCellIndex) {
        cell.cellSelected = true;
    } else {
        cell.cellSelected = false;
    }
    WS(ws);
    __block XueTangDeviceListCell *tmpCell = cell;
    cell.retryBtn.buttonClick = ^(GLButton *sender) {
        if (ws.connectClick) {
            ws.connectClick(tmpCell);
        }
        
    };
    return cell;
}

- (XueTangDeviceListHeader *)header
{
    if (!_header) {
        _header = [[XueTangDeviceListHeader alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 107)];
        WS(ws);
        //重新搜索设备
        _header.refreshBtn.buttonClick = ^(GLButton *sender) {
            ws.retryBtn.buttonClick(ws.header.refreshBtn);
        };
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

- (GLButton *)retryBtn
{
    if (!_retryBtn) {
        _retryBtn = [GLButton new];
        [_retryBtn setTitle:@"重试" forState:UIControlStateNormal];
        [_retryBtn setFont:GL_FONT(20)];
        [_retryBtn setBackgroundColor:RGB(0, 204, 153) forState:UIControlStateNormal];
        [_retryBtn setCornerRadius:20];
        [_retryBtn setTitleColor:TCOL_WHITETEXT forState:UIControlStateNormal];
        [_retryBtn setHidden:true];
    }
    return _retryBtn;
}

- (void)setStatus:(SearchDeviceStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (status) {
            case SearchDeviceStatusNone:
                self.blocksGifIV.hidden        = false;
                self.header.refreshBtn.hidden  = true;
                self.header.titleLbl.text      = @"搜索中...";
                self.header.titleLbl.textColor = TCOL_MAIN;
                self.retryBtn.hidden           = true;
                [self.tbDataSouce removeAllObjects];
                [self reloadData];
                break;
            case SearchDeviceStatusSucceed:
                self.header.refreshBtn.hidden  = false;
                self.header.titleLbl.text      = @"请选择设备";
                self.header.titleLbl.textColor = TCOL_MAIN;
                self.blocksGifIV.hidden        = true;
                self.retryBtn.hidden           = true;
                self.selectCellIndex           = 0;
                break;
            case SearchDeviceStatusFailed:
                self.blocksGifIV.hidden        = true;
                self.header.titleLbl.text      = @"未找到设备";
                self.header.refreshBtn.hidden  = true;
                self.header.titleLbl.textColor = RGB(255, 102, 102);
                self.retryBtn.hidden           = false;
                [self.tbDataSouce removeAllObjects];
                [self reloadData];
                break;
            default:
                break;
        }
    });
}

@end
