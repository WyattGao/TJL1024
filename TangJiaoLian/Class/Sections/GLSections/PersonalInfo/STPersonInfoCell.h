//
//  STPersonInfoCell.h
//  Diabetes
//
//  Created by 高临原 on 16/3/4.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *lastRow = @"lastRow";

@protocol PersonCellDelegate <NSObject>

- (void)changeSex:(NSString *)sex;

@end

@interface STPersonInfoCell : UITableViewCell

@property (nonatomic,weak) id<PersonCellDelegate> delegate;

@property (nonatomic,strong) NSMutableDictionary *dict;

@property (nonatomic,strong) NSMutableDictionary *userBaseDic; /**< 用户基本信息 */

@property (nonatomic,strong) NSMutableDictionary *patientDic;  /**< 用户扩展信息 */

@property (nonatomic,strong) UIImageView *picIV;

@property (nonatomic,strong) UILabel *rightLbl;

@property (nonatomic,strong) UILabel *leftLbl;

@property (nonatomic,strong) UIButton *maleBtn;   /**< 选择性别 - 男按钮 */

@property (nonatomic,strong) UILabel *maleLbl;    /**< 选择性别 - 男标签 */

@property (nonatomic,strong) UIButton *femaleBtn; /**< 选择性别 - 女按钮 */

@property (nonatomic,strong) UILabel *femaleLbl;  /**< 选择性别 - 女标签 */
@property (nonatomic,strong) UILabel * codeLable; /**< 我的邀请码  */
- (void)reloadData;


@end
