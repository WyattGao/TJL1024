//
//  XueTangDeviceListTableView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/19.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"
#import "XueTangDeviceListCell.h"


typedef void(^ConnectClick)(XueTangDeviceListCell *cell);

typedef NS_ENUM(NSInteger,SearchDeviceStatus) {
    SearchDeviceStatusNone    = 0,  /**< 正在搜索，还没有搜索到数据 */
    SearchDeviceStatusSucceed = 1,  /**< 成功搜索到数据 */
    SearchDeviceStatusFailed  = 2,  /**< 搜索超时 */
    SearchDeviceStatusFinish  = 3   /**< 搜索完成 */
};

@interface XueTangDeviceListTableView : GLTableView

@property (nonatomic,assign) SearchDeviceStatus status;

@property (nonatomic,strong) GLButton *retryBtn; /**< 重试按钮 */

@property (nonatomic,copy) ConnectClick connectClick;

@end
