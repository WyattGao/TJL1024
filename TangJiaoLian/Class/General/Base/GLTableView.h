//
//  GLTableView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLEntity.h"
#import "GLTableViewCell.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

typedef void(^TableViewDidSelect)(NSIndexPath *indexPath);

@interface GLTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

///数据源
@property (nonatomic,strong) NSMutableArray  *tbDataSouce;
@property (nonatomic,strong) UIView *sectionView;
@property (nonatomic,copy)   TableViewDidSelect tableViewDidSelect;
@property (nonatomic,assign) NSInteger cellNumbers;

- (void)setUpCellHeight:(CGFloat)height CellIdentifier:(NSString *)identifier CellClassName:(NSString *)className;

- (void)createUI;

- (void)tableViewDidSelect:(TableViewDidSelect)tableViewDidSelect;


@end
