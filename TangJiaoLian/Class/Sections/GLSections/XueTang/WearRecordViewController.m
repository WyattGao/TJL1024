//
//  WearRecordViewController.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/31.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WearRecordViewController.h"
#import "WearRecordTableView.h"
#import "WearRecordEntity.h"
#import "XueTangView.h"
#import "WearRecordDetailViewController.h"
#import "STDataAnalysisViewController.h"

@interface WearRecordViewController ()

@property (nonatomic,strong) WearRecordTableView *mainTV;
@property (nonatomic,strong) WearRecordDetailViewController *detailVC;
@property (nonatomic,strong) STDataAnalysisViewController *dataAnalysisVC;

@end

@implementation WearRecordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createUI
{
    [SVProgressHUD show];
    [self setNavTitle:@"佩戴记录"];
    [self setLeftBtnImgNamed:nil];
    
    [self addSubView:self.mainTV];
    
    WS(ws);
    
    [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.centerX.equalTo(ws.view);
        make.bottom.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    self.reloadView.reload = ^{
        [ws createData];
    };
}

- (void)createData
{
    NSDictionary *postDic = @{
                           @"FuncName":@"getSamWear",
                           @"InField":@{
                                   @"ACCOUNT":USER_ACCOUNT,	//账号
                                   @"DEVICE":@"1"	//设备号
                                   }
                           };
    [GL_Requst postWithParameters:postDic SvpShow:false success:^(GLRequest *request, id response) {
        [_mainTV.tbDataSouce removeAllObjects];
        [SVProgressHUD dismiss];
        if (GETTAG) {
            if (GETRETVAL) {
                NSArray *dataArr = response[@"Result"][@"OutTable"];
                if (dataArr.count == 0) {
                    GL_ALERT_E(@"暂无佩戴记录");
                } else {
                    dataArr = [[dataArr reverseObjectEnumerator] allObjects];
//                    if (ISBINDING) { //插入当前时间
//                        WearRecordEntity *entity = [WearRecordEntity new];
//                        entity.starttime = [GL_USERDEFAULTS getStringValue:SamStartBinDingDeviceTime];
//                        entity.endtime = [GLTools nowDateString];
//                        [_mainTV.tbDataSouce addObject:entity];
//                    }
                    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            WearRecordEntity *entity = [[WearRecordEntity alloc]initWithDictionary:obj];
                        if (![[obj getStringValue:@"endtime"] length]) {
                            entity.endtime = [GLTools nowDateString];
                        }
                            [_mainTV.tbDataSouce addObject:entity];
                    }];
                    
                }
                [_mainTV reloadData];
            }else{
                GL_ALERT_E(GETRETMSG);
                [self.reloadView setHidden:false];
            }
        }else
        {
            GL_ALERT_E(GETMESSAGE);
            [self.reloadView setHidden:false];
        }
    } failure:^(GLRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [self.reloadView setHidden:false];
        GL_AFFAil;
    }];
}

- (WearRecordTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [WearRecordTableView new];
        WS(ws);
        _mainTV.cellButtonClick = ^(RecordCellButtonClickType clickType, NSInteger row) {
            WearRecordEntity *entity = [ws.mainTV.tbDataSouce objectAtIndex:row];
            if (clickType == RecordCelldetailedRecordClick) {
                //佩戴设备记录模型
                ws.detailVC              = [WearRecordDetailViewController new];
                ws.detailVC.entity       = entity;
                [ws pushWithController:ws.detailVC];
            } else {
                STDataAnalysisViewController *dataVC = [STDataAnalysisViewController new];
                dataVC.startTimeStr = entity.starttime;
                dataVC.endTimeStr   = entity.endtime;
                [ws pushWithController:dataVC];
            }
        };
        
        [_mainTV tableViewDidSelect:^(NSIndexPath *indexPath) {
        }];
    }
    return _mainTV;
}


@end
