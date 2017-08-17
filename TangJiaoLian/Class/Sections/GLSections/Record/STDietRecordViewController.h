//
//  STDietRecordViewController.h
//  Diabetes
//
//  Created by 高临原 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "GLViewController.h"
#import "RecordEntity.h"

typedef void(^RefreshDietRecord)();

@protocol STDietRecordVCDelegate <NSObject>

- (void)reloadDietRVCData;

@end

@interface STDietRecordViewController : GLViewController

@property (nonatomic,weak) id<STDietRecordVCDelegate> delegate;

@property (nonatomic,copy) NSString *dietRecordId;

@property (nonatomic,strong) DiningRecordEntity *entity;

@property (nonatomic) BOOL isHidRightBtn; /**< 是否隐藏右上角按钮 */
@property (nonatomic) BOOL isHidSaveBtn;  /**< 是否隐藏保存按钮 */

@property (nonatomic) BOOL isPostSam;//是否上传到圣美

@property (nonatomic,copy) RefreshDietRecord refreshDietRecord;

@end
