//
//  STMedicineView.h
//  Diabetes
//
//  Created by 房克志 on 16/3/4.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureExaminationView.h"

typedef void(^SelectMedicine)(NSDictionary *medicineDic);

@interface STMedicineView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,picRemDelegate>

@property (nonatomic,strong) UITextField *textfield;

@property (nonatomic,copy) SelectMedicine  medicineValue;
@property (nonatomic,strong) NSMutableArray *downLoadArray;
@property (nonatomic,strong) PictureExaminationView *picView;


@end
