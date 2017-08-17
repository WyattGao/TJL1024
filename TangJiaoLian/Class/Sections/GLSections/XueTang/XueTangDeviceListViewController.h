//
//  XueTangDeviceListViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLViewController.h"
#import "SMDBlueToothManager.h"

typedef void(^connectDevice)(LFPeripheral *deviceEntity);

@interface XueTangDeviceListViewController : GLViewController

@property (nonatomic,copy) connectDevice connectDevice;

@end
