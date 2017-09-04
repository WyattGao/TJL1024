//
//  XueTangDeviceListCell.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableViewCell.h"
#import "LFPeripheral.h"

typedef NS_ENUM(NSInteger,GLConnectionStatus){
    ///正在连接
    GLConnectionUnfinished = 0,
    ///连接失败
    GLConnectionFailed,
    ///连接完成
    GLConnectionSucceed
};

@interface XueTangDeviceListCell : GLTableViewCell

///显示设备名称
@property (nonatomic,strong) UILabel *deviceNameLbl;

///重试按钮
@property (nonatomic,strong) GLButton *retryBtn;

///连接状态
@property (nonatomic,strong) UILabel *connectionStatusLbl;

@property (nonatomic,assign) BOOL cellSelected;


///根据连接状态修改Cell
- (void)changeCellForConnectionStatus:(GLConnectionStatus)status;

@end
