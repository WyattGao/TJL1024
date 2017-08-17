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

@interface WearRecordViewController ()

@property (nonatomic,strong) WearRecordTableView *mainTV;
@property (nonatomic,strong) WearRecordDetailViewController *detailVC;

@end

@implementation WearRecordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createUI
{
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
}

- (void)getData
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
        if (GETTAG) {
            if (GETRETVAL) {
                NSArray *dataArr = response[@"Result"][@"OutTable"];
                if (dataArr.count == 0) {
                    GL_ALERT_E(@"暂无佩戴记录");
                } else {
                    dataArr          = [[dataArr reverseObjectEnumerator] allObjects];
                    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            WearRecordEntity *enttiy = [[WearRecordEntity alloc]initWithDictionary:obj];
                        if (![[obj getStringValue:@"endtime"] length]) {
                            enttiy.endtime = [GLTools nowDateString];
                        }
                            [_mainTV.tbDataSouce addObject:enttiy];
                    }];
                    
                }
                [_mainTV reloadData];
            }else{
                GL_ALERT_E(GETRETMSG);
            }
        }else
        {
            GL_ALERT_E(GETMESSAGE);
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_AFFAil;
    }];
}

- (WearRecordTableView *)mainTV
{
    if (!_mainTV) {
        _mainTV = [WearRecordTableView new];
        WS(ws);
        [_mainTV tableViewDidSelect:^(NSIndexPath *indexPath) {
            //佩戴设备记录模型
            WearRecordEntity *entity = [_mainTV.tbDataSouce objectAtIndex:indexPath.row];
            _detailVC = [WearRecordDetailViewController new];
            _detailVC.entity = entity;
            [self pushWithController:ws.detailVC];
        }];
    }
    return _mainTV;
}


@end
