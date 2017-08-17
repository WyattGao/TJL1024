//
//  XueTangView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "XueTangView.h"
#import "GLTableView.h"

@interface XueTangView ()

@end

@implementation XueTangView

- (void)createUI
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 50.0f + 240.0f;
            break;
        case 1:
            return 243.0f;
            break;
        case 2:
            return 90.0f;
            break;
        case 3:
            return 362.2f;
            break;
        case 4:
            return 80.0f;
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell) {
        cell = [[GLTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"cell"];
        switch (indexPath.row) {
            case 0:[cell addSubviewByCellFrame:self.deviceTV];
                   [cell addSubviewByCellFrame:self.shiShiView];
                   break;
            case 1:[cell addSubviewByCellFrame:self.recordView];       break;
            case 2:[cell addSubviewByCellFrame:self.wearRecordBtnView];break;
            case 3:[cell addSubviewByCellFrame:self.dataAndTargetView];break;
            case 4:[cell addSubviewByCellFrame:self.lineView];         break;
            default:break;
        }
    }
    
    return cell;
}

- (void)cellAddSubview:(UITableViewCell *)cell subview:(UIView *)view
{
    [cell.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(cell.contentView);
        make.center.equalTo(cell.contentView);
    }];
}

- (XueTangLiShiZhiView *)liShiZhiView
{
    if (!_liShiZhiView) {
        _liShiZhiView = [XueTangLiShiZhiView new];
    }
    return _liShiZhiView;
}

- (XueTangLineView *)lineView
{
    if (!_lineView) {
        _lineView = [XueTangLineView new];
    }
    return _lineView;
}

- (XueTangShiShiXueTangView *)shiShiView
{
    if (!_shiShiView) {
        _shiShiView = [XueTangShiShiXueTangView new];
    }
    return _shiShiView;
}

- (XueTangDataAnalysisAndMonitoringTargetView *)dataAndTargetView
{
    if (!_dataAndTargetView) {
        _dataAndTargetView = [XueTangDataAnalysisAndMonitoringTargetView new];
    }
    return _dataAndTargetView;
}

- (XueTangRecordView *)recordView
{
    if (!_recordView) {
        _recordView = [XueTangRecordView new];
    }
    return _recordView;
}

- (XueTangWearRecordBtnView *)wearRecordBtnView
{
    if (!_wearRecordBtnView) {
        _wearRecordBtnView = [XueTangWearRecordBtnView new];
    }
    return _wearRecordBtnView;
}

- (XueTangDeviceListTableView *)deviceTV
{
    if (!_deviceTV) {
        _deviceTV = [XueTangDeviceListTableView new];
    }
    return _deviceTV;
}

@end
