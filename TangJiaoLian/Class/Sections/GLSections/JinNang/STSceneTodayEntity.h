//
//  STSceneTodayEntity.h
//  Diabetes
//
//  Created by 高临原 on 16/4/16.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "GLEntity.h"

@interface STSceneTodayEntity : GLEntity

@property (nonatomic, copy) NSString *QUIZID;

@property (nonatomic, copy) NSString *SKETCH;

@property (nonatomic, copy) NSString *COLLECTSTATUS;

@property (nonatomic, copy) NSString *PIC;

@property (nonatomic, copy) NSString *SPIC;

@property (nonatomic, copy) NSString *TITLE;

@property (nonatomic, copy) NSString *CREATTIME;

@property (nonatomic, copy) NSString *URL;

@property (nonatomic, copy) NSString *CLICKNUM;  /**< 阅读量 */

@property (nonatomic, copy) NSString *TYPE;

@property (nonatomic, copy) NSString *COLLECTNUM; /**< 收藏数 */

@property (nonatomic, copy) NSString *ID;

@property (nonatomic,copy)  NSString *BEVELPIC;  /**< 推荐文章海报图 */

@property (nonatomic,copy) NSString *NEWSORVIDEO; /**< 区分视频还是文章 0 文章 1 视频 */

@property (nonatomic,copy) NSString *PRAISESTATUS; /**< 点赞状态 */

@property (nonatomic,copy) NSString *PRAISENUM; /**< 点赞数量 */

@property (nonatomic,copy) NSString *VURL;      /**< 视频地址 */

#pragma mark - 视频属性
@property (nonatomic, strong) NSString * CREATER;
@property (nonatomic, strong) NSString * DOCTORID;
@property (nonatomic, strong) NSString * ISMAIN;
@property (nonatomic, strong) NSString * MAINID;
@property (nonatomic, strong) NSString * REALCLICKNUM;
@property (nonatomic, strong) NSString * RECOMMEND;
@property (nonatomic, strong) NSString * SORT;
@property (nonatomic, strong) NSString * UPDATER;
@property (nonatomic, strong) NSString * UPDATETIME;
@property (nonatomic, strong) NSString * USERNAME;
@property (nonatomic, strong) NSString * H5URL;
@property (nonatomic, strong) NSString * VIDEONUM;



@end
