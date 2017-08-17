//
//  STDietRecordCell.h
//  Diabetes
//
//  Created by 高临原 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordEntity.h"

@protocol STDietRecordCellDelegate <NSObject,UITextViewDelegate>

- (void)reloadTextViewForCellWithHeight:(CGFloat)height;

- (void)addObj:(id)obj WithKey:(NSString *)key;

@end

@interface STDietRecordCell : UITableViewCell

@property (nonatomic,weak) id<STDietRecordCellDelegate> delegate;

@property (nonatomic,strong) UILabel  *rightLbl; /**< cell3 ~ cell5右侧内容标题 */

@property (nonatomic,strong) NSMutableArray *savePicArr;

@property (nonatomic,strong) UITextView *tv;

@property (nonatomic,strong) DiningRecordEntity *entity;

@property (nonatomic) BOOL isNotEdit; /**< 是否是不可编辑状态 */

@end
