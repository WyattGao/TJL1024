//
//  EncyclopediaTypeCell.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/22.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSceneTodayEntity.h"

static NSString *drugSreachMark = @"drugSreachMark";/**< 用药查询按钮 */
static NSString *proVidMark     = @"proVidMark";    /**< 推荐类别中的视频 */
static NSString *artMark        = @"artMark";       /**< 其他文章 */
static NSString *vidMark        = @"vidMark";       /**< 其他视频 */

@class EncyclopediaTypeCell;

@protocol EncyclopediaTyoeCellDelegate <NSObject>

- (void)changeFavDataWithEntity:(STSceneTodayEntity *)entity;

@end

@interface EncyclopediaTypeCell : UITableViewCell

@property (nonatomic,strong) STSceneTodayEntity *entity;


@property (nonatomic,weak) id<EncyclopediaTyoeCellDelegate> delegate;


@property (nonatomic,strong) UIImageView *mainIV;   /**< 图片 */
@property (nonatomic,strong) GLButton *favBtn;      /**< 收藏 */


@end
