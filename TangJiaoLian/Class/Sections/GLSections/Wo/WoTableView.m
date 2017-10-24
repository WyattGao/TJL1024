//
//  WoTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoTableView.h"
#import "WoTableViewCell.h"

@interface WoTableView ()

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *imgArr;

@end

@implementation WoTableView

- (void)createUI
{
    if (@available(iOS 11.0, *)) { //iOS11不自动调整状态栏
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.backgroundColor     = TCOL_BGGRAY;
    self.sectionView         = self.infoHeaderView;
    self.sectionHeaderHeight = GL_IP6_H_RATIO(237);
    self.tableFooterView     = self.infoFooterView;
    
    for (NSInteger i = 0;i < 5;i++) {
        WoTableViewEntity *entity = [WoTableViewEntity new];
        entity.imgStr             = self.imgArr[i];
        entity.titleStr           = self.titleArr[i];
        [self.tbDataSouce addObject:entity];
    }
    [self setUpCellHeight:50 CellIdentifier:nil CellClassName:NSStringFromClass([WoTableViewCell class])];
    [self setCellNumbers:5];
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"消息中心",@"设置",@"账号安全",@"帮助与反馈",@"关于"];
    }
    return _titleArr;
}

- (NSArray *)imgArr
{
    if (!_imgArr) {
        _imgArr = @[@"我的-消息中心",@"我的-设置",@"我的-账号安全",@"帮助-使用说明",@"我的-关于"];
    }
    return _imgArr;
}

- (WoInfoHeaderView *)infoHeaderView
{
    if (!_infoHeaderView) {
        _infoHeaderView = [WoInfoHeaderView new];
    }
    return _infoHeaderView;
}

- (WoInfoFooterView *)infoFooterView
{
    if (!_infoFooterView) {
        CGFloat infoFooterViewHeight = SCREEN_HEIGHT - GL_IP6_H_RATIO(237) - 50 * self.titleArr.count - GL_TABBARHEIGHT - 10 - (GL_IS_IPX ? [UIApplication sharedApplication].statusBarFrame.size.height : 0);
        _infoFooterView = [[WoInfoFooterView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, infoFooterViewHeight)];
        _infoFooterView.hidden = !ISLOGIN;
    }
    return _infoFooterView;
}

@end
