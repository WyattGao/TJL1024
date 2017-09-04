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

@property (nonatomic,assign,getter=isTurnShiOpTop) BOOL turnShiOpTop; /**< 记录View翻转的状态 */

@end

@implementation XueTangView

- (void)turnShiShiView
{
    if (self.isTurnShiOpTop) {
        [self.shiShiView sendSubviewToBack:self.deviceTV];
        [UIView transitionFromView:(self.shiShiView)
                            toView:(self.deviceTV)
                          duration: 0.7
                           options: UIViewAnimationOptionTransitionFlipFromLeft+UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            if (finished) {
                                
                            }
                        }
         ];
    } else {
        [self.deviceTV sendSubviewToBack:self.shiShiView];
        [UIView transitionFromView:(self.deviceTV)
                            toView:(self.shiShiView)
                          duration: 0.7
                           options: UIViewAnimationOptionTransitionFlipFromRight+UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                            if (finished) {
                                
                            }
                        }
         ];
    }
    self.turnShiOpTop = !self.turnShiOpTop;
}

- (void)createUI
{
    self.turnShiOpTop = true;
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
            case 3:[cell addSubviewByCellFrame:self.lineView];         break;
            default:break;
        }
    }
    
    return cell;
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

- (XueTangRingTimeView *)ringView
{
    if (!_ringView) {
        _ringView = self.shiShiView.ringView;
    }
    return _ringView;
}

@end
