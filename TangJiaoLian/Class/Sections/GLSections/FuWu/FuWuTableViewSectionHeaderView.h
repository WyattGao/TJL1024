//
//  FuWuTableViewSectionHeaderView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/20.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLView.h"
#import "GLPicReincarnationView.h"

typedef void(^CheckAllDoc)();

@interface FuWuTableViewSectionHeaderView : GLView

@property (nonatomic,strong) UIButton               *checkAllDocBtn;/**< 查看全部医生按钮 */
@property (nonatomic,strong) GLPicReincarnationView *picReView;
@property (nonatomic,copy  ) CheckAllDoc            checkAllDoc;


@end
