//
//  STNewMedicationCell.h
//  SuiTangNew
//
//  Created by 房克志 on 16/8/16.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IconClickBlock)(UIImageView *imgView);

@interface STNewMedicationCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UILabel  *titLab;

@property (nonatomic,strong) UIImageView *iconImgView;

@property (nonatomic,copy) IconClickBlock   iconBlock;

@end
