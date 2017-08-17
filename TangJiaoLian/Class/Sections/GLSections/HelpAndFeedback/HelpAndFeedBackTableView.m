//
//  HelpAndFeedBackTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/27.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "HelpAndFeedBackTableView.h"
#import "WoTableViewCell.h"

@implementation HelpAndFeedBackTableView

- (void)createUI
{
    self.backgroundColor = TCOL_BGGRAY;
    self.bounces         = false;
    
    for (NSInteger i = 0;i < 3;i++) {
        WoTableViewEntity *entity = [WoTableViewEntity new];
        entity.imgStr             = @[@"帮助-用户协议",@"帮助-使用说明",@"帮助-意见反馈"][i];
        entity.titleStr           = @[@"用户协议",@"使用说明",@"意见反馈"][i];
        
        [self.tbDataSouce addObject:entity];
    }
    [self setUpCellHeight:50
           CellIdentifier:nil
            CellClassName:NSStringFromClass([WoTableViewCell class])];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WoTableViewCell *cell = (WoTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = TCOL_BG;
    if (indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
        cell.lineView.hidden = true;
    }
    return cell;
}

@end
