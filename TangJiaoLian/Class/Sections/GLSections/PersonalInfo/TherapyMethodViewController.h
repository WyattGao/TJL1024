//
//  TherapyMethodViewController.h
//  SuiTangNew
//
//  Created by 高临原 on 2017/1/3.
//  Copyright © 2017年 随糖. All rights reserved.
//

#import "GLViewController.h"

@protocol TherapyMethodViewControllerDelegate <NSObject>

- (void)changeTherapyMethodArr:(NSArray *)arr;

@end

@interface TherapyMethodViewController : GLViewController

@property (nonatomic,strong) NSMutableArray *therapyMethodArr;

@property (nonatomic,weak) id<TherapyMethodViewControllerDelegate> delegate;

@end
