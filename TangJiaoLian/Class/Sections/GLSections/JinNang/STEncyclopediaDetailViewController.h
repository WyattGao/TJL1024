//
//  STEncyclopediaDetailViewController.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/6/15.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "GLViewController.h"
#import "STSceneTodayEntity.h"

typedef NS_ENUM(NSInteger, EncyclopediaDetailViewType) {
    FormeOtherPage = 0,
    FormServer   = 3,            /**< 服务页 */
    FormDoctorIntroduction = 2,  /**< 医风采 */
    FormSearch = 4               /**< 搜索页推过 */
};

typedef NS_ENUM(NSInteger,EncyPushType){
    formEncyOther = 0,
    formEncyAPNS = 1,    /**< APNS推送 */
    formEncyLocal = 2    /**< 本地推送 */
};

@protocol entyclopediaDetailDelegate <NSObject>

- (void)changeCollectStateWithEntity:(STSceneTodayEntity *)entity;

@end

@interface STEncyclopediaDetailViewController : GLViewController

@property (nonatomic,strong) STSceneTodayEntity *entity;

//@property (nonatomic,strong) STSceneTodayEntity *formOtherEnttiy;    /**< 除百科首页 其他界面进入使用此模型 */

@property (nonatomic,weak) id<entyclopediaDetailDelegate> delegate;


@property (nonatomic) EncyclopediaDetailViewType viewType;

@property (nonatomic,assign) EncyPushType pushType;

@end
