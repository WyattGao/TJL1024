//
//  WoAccountSecurityTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoAccountSecurityTableView.h"
#import "WoTableViewCell.h"

@implementation WoAccountSecurityTableView

- (void)createUI
{
    self.backgroundColor = TCOL_BGGRAY;
    
    for (NSInteger i = 0;i < 2;i++) {
        WoTableViewEntity *entity = [WoTableViewEntity new];
        entity.imgStr             = @[@"我的-账号安全",@"账号安全-更换手机号"][i];
        entity.titleStr           = @[@"修改密码",@"更换手机号"][i];
        
        [self.tbDataSouce addObject:entity];
    }
    
    [self setUpCellHeight:50 CellIdentifier:nil CellClassName:NSStringFromClass([WoTableViewCell class])];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WoTableViewCell *cell =  (WoTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == [self numberOfRowsInSection:0] - 1) {
        cell.lineView.hidden = true;
        
        UILabel *phoneLbl  = [UILabel new];
        phoneLbl.text      = [[GL_USERDEFAULTS getStringValue:@"PHONE"] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        phoneLbl.font      = GL_FONT(16);
        phoneLbl.textColor = RGB(102, 102, 102);
        [cell.contentView addSubview:phoneLbl];
        
        [phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.titleLbl.mas_right).offset(17);
            make.centerY.equalTo(cell);
        }];
    }
    return cell;
}

@end
