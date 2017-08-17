//
//  STEncyclopediaViewController.m
//  SuiTangNew
//
//  Created by 高临原 on 16/6/13.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "STEncyclopediaViewController.h"
#import "STEncyclopediaDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "EncyclopediaTypeCell.h"

@interface STEncyclopediaViewController ()
<
entyclopediaDetailDelegate,
UIScrollViewDelegate,
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
EncyclopediaTyoeCellDelegate
>

{
    NSInteger moveCount;
    NSInteger moveTmpNum;
}

@property (nonatomic,strong) UIScrollView *mainSV;

@property (nonatomic,strong) UIScrollView *headSV;      /**< 顶部文章切换滑动控件 */

@property (nonatomic,strong) NSMutableArray *dataSource;  /**< 数据源 */

@property (nonatomic,strong) NSMutableArray *adsDataSource;/**< 广告图数据源 */

@property (nonatomic,strong) NSMutableArray *pageArr;     /**< 存放不同新闻类型目前加载的页数 */

@property (nonatomic,strong) NSMutableArray *typeArr;      /**< 存放百科分类标题和ID */

@property (nonatomic,assign) NSInteger selIdx; /**< 目前选择的百科类型的下标 */

@property (nonatomic,strong) EncyclopediaTypeCell *tmpVidCell;

@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,strong) UIView *headLine; /**< 头部选项横线 */

@property (nonatomic,assign) NSInteger lastPosition;  /**< 记录SV上一次滚动的值 */

@property (nonatomic,assign) BOOL isLeft;

@property (nonatomic,strong) UIButton *reloadBtn; /**< 重新加载按钮 */

@property (nonatomic,strong) UIImageView *leftCoverIV;  /**< 左侧遮盖 */
@property (nonatomic,strong) UIImageView *rightCoverIV; /**< 右侧遮盖 */


@end

@implementation STEncyclopediaViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

- (void)initNav
{
    [self setNavTitle:@"锦囊"];
    //    [self setRightBtnTitle:@"百科-文章搜索放大镜"];
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mainSV          = [UIScrollView new];
    _headSV          = [UIScrollView new];
    _leftCoverIV     = [[UIImageView alloc]initWithImage:GL_IMAGE(@"bk_导航栏left")];
    _rightCoverIV    = [[UIImageView alloc]initWithImage:GL_IMAGE(@"bk_导航栏right")];
    _headLine        = [UIView new];
    _reloadBtn       = [UIButton new];
    UIView  *bomline = [UIView new];
    
    [self.view addSubview:_mainSV];
    [self.view addSubview:_headSV];
    [self.view addSubview:bomline];
    [self.view addSubview:_leftCoverIV];
    [self.view addSubview:_rightCoverIV];
    [self.view addSubview:_headLine];
    [_mainSV addSubview:_reloadBtn];
    
    _headSV.backgroundColor                = RGB(255, 255, 255);
    _headSV.showsHorizontalScrollIndicator = false;
    _headSV.delegate                       = self;
    
    [_mainSV setPagingEnabled:true];
    [_mainSV setDelegate:self];
    [_mainSV setShowsHorizontalScrollIndicator:false];
    
    _headLine.backgroundColor = TCOL_MAIN;
    
    bomline.backgroundColor   = RGB(213, 213, 213);
    
    _leftCoverIV.hidden       = true;
    
    [_reloadBtn setHidden:true];
    [_reloadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [_reloadBtn setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    [_reloadBtn setBackgroundColor:RGB(255, 255, 255)];
    [_reloadBtn setCornerRadius:5];
    [_reloadBtn setBorderWidth:0.5];
    [_reloadBtn setBorderColor:[UIColor blackColor]];
    [_reloadBtn addTarget:self action:@selector(reloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    WS(ws);
    
    [_headSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        make.centerX.equalTo(ws.view);
    }];
    
    [_mainSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(104, 0, 0, 0));
    }];
    
    [bomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
        make.bottom.equalTo(ws.view.mas_top).offset(39.5);
    }];
    
    [_leftCoverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headSV);
        make.left.equalTo(ws.view);
    }];
    
    [_rightCoverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headSV);
        make.right.equalTo(ws.view.mas_right);
    }];
    
    [_reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_mainSV);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
}

- (void)initMainSVWithTypeArr:(NSArray *)typeArr
{
    [_mainSV removeAllChildView];
    [_headSV removeAllChildView];
    
    //计算scrollView滑动的宽度
    __block CGFloat tmpContentWidth = 5;
    
    
    
    [typeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_dataSource addObject:[NSMutableArray array]];
        [_pageArr    addObject:@(1)];
        
        GLButton *btn = [GLButton new];
        [_headSV addSubview:btn];
        [btn setSelected:idx ? false : true];
        [btn setTag:300 + idx];
        [btn setTitle:[obj getStringValue:@"PARAMNAME"] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
        [btn setTitleColor:TCOL_MAIN forState:UIControlStateSelected];
        [btn setFont:GL_FONT(16)];
        [btn setGraphicLayoutState:TEXTCENTER];
        [btn addTarget:self action:@selector(docTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTextAlignment:NSTextAlignmentCenter];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headSV).offset(tmpContentWidth);
            make.centerY.equalTo(_headSV);
            make.size.mas_equalTo(CGSizeMake([btn.lbl getLabelWidth] + 10, 40));
        }];
        
        if (!idx) {
            [_headLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(btn);
                make.size.mas_equalTo(CGSizeMake([btn.lbl getLabelWidth] + 10, 2));
                make.bottom.equalTo(btn.mas_bottom);
            }];
        }
        
        tmpContentWidth += [btn.lbl getLabelWidth] + 20;
        
        UITableView *mainTV = [UITableView new];
        [_mainSV addSubview:mainTV];
        
        mainTV.backgroundColor = TCOL_BGGRAY;
        mainTV.delegate        = self;
        mainTV.dataSource      = self;
        mainTV.separatorStyle  = UITableViewCellSeparatorStyleNone;
        mainTV.tag             = 400 + idx;
        
        mainTV.mj_header       = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            [_dataSource replaceObjectAtIndex:_selIdx withObject:[NSMutableArray array]];
            [_pageArr replaceObjectAtIndex:_selIdx withObject:@(1)];
            [self request];
        }];
        
        mainTV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSInteger page = [[_pageArr objectAtIndex:_selIdx] integerValue] + 1;
            [_pageArr replaceObjectAtIndex:_selIdx withObject:@(page)];
            [self request];
        }];
        
        [mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_mainSV);
            make.size.equalTo(_mainSV);
            make.left.equalTo(_mainSV).offset(SCREEN_WIDTH * idx);
        }];
    }];
    
    [_headSV setContentSize:CGSizeMake(tmpContentWidth, 0)];
    [_mainSV setContentSize:CGSizeMake(SCREEN_WIDTH * typeArr.count, 0)];
}

- (void)initData
{
    WS(ws);

    moveCount   = 455;
    _dataSource = [NSMutableArray array];
    _pageArr    = [NSMutableArray array];
    _selIdx     = 0;
    
    _typeArr = [NSMutableArray arrayWithArray:@[@{@"PARAMNAME" : @"推荐",@"ID" : @""}]];
    [self initMainSVWithTypeArr:_typeArr];
    
    NSDictionary *postDic = @{
                              FUNCNAME : @"getClassification"
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        if (GETTAG) {
            if (GETRETVAL) {
                [_typeArr addObjectsFromArray:[[response objectForKey:@"Result"] objectForKey:@"OutTable"]];
                [self initMainSVWithTypeArr:_typeArr];
                
                [self request];
            } else {
                GL_ALERT_E(GETRETMSG);
            }
        } else {
            GL_ALERT_E(GETMESSAGE);
            if ([GETRETMSG isEqualToString:@"获取数据为空"]) {
                [self initMainSVWithTypeArr:_typeArr];
                [self request];
            } else {
                _reloadBtn.hidden = false;
            }
        }
        
        [GL_ReloadView dismiss];
    } failure:^(GLRequest *request, NSError *error) {
        GL_AFFAil;
        _reloadBtn.hidden = false;
        
        if (!_selIdx) {
            [GL_ReloadView showInView:self.view];
            GL_ReloadView.reload = ^{
                [ws initData];
            };
        }
    }];
}

- (void)request
{
    
    UITableView *refreshTV = [self.view viewWithTag:400 + _selIdx];
    NSString *page         = [[_pageArr objectAtIndex:_selIdx] stringValue];
    NSString *pageSize     = @"10";
    
    NSDictionary *postDic = @{
                              @"FuncName" : @"getNewsList",
                              @"InField"  : @{
                                      @"ACCOUNT"  : USER_ACCOUNT,
                                      @"DEVICE"   : @"1",
                                      @"TYPEID"   : [_typeArr[_selIdx] getStringValue:@"ID"],
                                      @"PAGE"     : page,
                                      @"PAGESIZE" : pageSize,
                                      @"VIDEO"    : @"0"
                                      },
                              @"OutField" : @[]
                              };
    [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
        [refreshTV.mj_header endRefreshing];
        [refreshTV.mj_footer endRefreshing];
        if ([response getIntegerValue:@"Tag"]) {
            if (GETRETVAL) {
                if ([[[[response objectForKey:@"Result"] objectForKey:@"OutTable"] firstObject] isKindOfClass:[NSArray class]]) {
                    NSArray *dataArr = [[[response objectForKey:@"Result"] objectForKey:@"OutTable"] firstObject];
                    if (!dataArr.count && [page integerValue] == 1) {
                        NSString *hintStr = [NSString stringWithFormat:@"%@暂无文章",[_typeArr[_selIdx] getStringValue:@"PARAMNAME"]];
                        GL_ALERT_E(hintStr);
                    } else {
                        NSMutableArray *tmpArr = [_dataSource objectAtIndex:_selIdx];
                        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            STSceneTodayEntity *entity = [[STSceneTodayEntity alloc]initWithDictionary:obj];
                            entity.URL = [entity.URL lowercaseString];
                            [tmpArr addObject:entity];
                        }];
                        [_dataSource replaceObjectAtIndex:_selIdx withObject:tmpArr];
                        
                        if (tmpArr.count < 10) {
                            [refreshTV.mj_footer endRefreshingWithNoMoreData];
                        }
                    }
                    [refreshTV reloadData];
                } else {
                    GL_AFFAil;
                }
            } else {
                GL_ALERT_E(GETRETMSG);
            }
        } else {
            GL_ALERT_E([response getStringValue:@"Message"]);
        }
        
    } failure:^(GLRequest *request, NSError *error) {
        [refreshTV.mj_header endRefreshing];
        [refreshTV.mj_footer endRefreshing];
        GL_AFFAil;

    }];
}

#pragma mark - TableViewDelegate & TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataSource objectAtIndex:_selIdx] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     //名医访谈Cell
     GLButton *btn = [self.view viewWithTag:300 + _selIdx];
     if ([btn.lbl.text isEqualToString:@"名医访谈"]) {
     return 245 + 31.8 + 5;
     }
     //药物查询Cell
     if ([btn.lbl.text isEqualToString:@"推荐"]) {
     //推荐分类里面的视频cell
     NSArray *arr = [_dataSource objectAtIndex:_selIdx];
     if (arr.count) {
     STSceneTodayEntity *entity = [arr objectAtIndex:indexPath.row];
     if ([entity.NEWSORVIDEO integerValue]) {
     return 215;
     }
     }
     }
     */
    
    //文章类Cell
    return 98;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //推荐类别中有推荐文章和药物搜索
    NSString *marking;
    GLButton *btn = [self.view viewWithTag:300 + _selIdx];
    
    NSMutableArray *tmpArr     = [_dataSource objectAtIndex:_selIdx];
    STSceneTodayEntity *entity = nil;
    
    if (tmpArr.count > indexPath.row) {
        entity = [tmpArr objectAtIndex:indexPath.row];
    }
    
    /*
     if ([btn.lbl.text isEqualToString:@"推荐"]) {
     marking = [entity.NEWSORVIDEO intValue] ? proVidMark : artMark;
     } else if([btn.lbl.text isEqualToString:@"名医访谈"]) {
     marking = vidMark;
     } else {
     marking = artMark;
     }
     */
    marking = artMark;
    
    EncyclopediaTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:marking];
    if (!cell) {
        cell = [[EncyclopediaTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:marking];
    }
    cell.entity   = entity;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *tmpArr     = [_dataSource objectAtIndex:_selIdx];
    STSceneTodayEntity *entity = [tmpArr objectAtIndex:indexPath.row];
    
    STEncyclopediaDetailViewController *detailVC = [STEncyclopediaDetailViewController new];
    detailVC.entity                              = entity;
    detailVC.delegate                            = self;
    detailVC.viewType                            = FormeOtherPage;
    [self pushWithController:detailVC];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainSV) {
        int currentPostion = scrollView.contentOffset.x;
        if (currentPostion - _lastPosition > 25) {
            _lastPosition = currentPostion;
            _isLeft = false;
            NSLog(@"ScrollRight now");
        }
        else if (_lastPosition - currentPostion > 25)
        {
            _lastPosition = currentPostion;
            _isLeft = true;
            NSLog(@"ScrollLeft now");
        }
    } else if(scrollView == _headSV){
        _rightCoverIV.hidden = scrollView.contentOffset.x+scrollView.width>=scrollView.contentSize.width-15?true:false;
        _leftCoverIV.hidden  = scrollView.contentOffset.x<=15?true:false;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

//滚动停止，代码触发
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _mainSV) {
        int currentPostion = scrollView.contentOffset.x;
        if (currentPostion - _lastPosition > 25) {
            _lastPosition = currentPostion;
            _isLeft = false;
            NSLog(@"ScrollRight now");
        }
        else if (_lastPosition - currentPostion > 25)
        {
            _lastPosition = currentPostion;
            _isLeft = true;
            NSLog(@"ScrollLeft now");
        }
    }
}

//手动滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //取出绝对值 避免最左边往右拉时形变超过1
    if (scrollView == _mainSV) {
        _selIdx = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
        [self docTypeClick:[self.view viewWithTag:_selIdx + 300]];
    }
}

#pragma mark - EncyclopediaTyoeCellDelegate
- (void)changeFavDataWithEntity:(STSceneTodayEntity *)entity
{
    UITableView *mainTV    = [self.view viewWithTag:400 + _selIdx];
    NSMutableArray *tmpArr = [_dataSource objectAtIndex:_selIdx];
    
    NSInteger entityIdx;
    entityIdx = [tmpArr indexOfObject:entity];
    
    [tmpArr replaceObjectAtIndex:entityIdx withObject:entity];
    [_dataSource replaceObjectAtIndex:_selIdx withObject:tmpArr];
    [mainTV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:entityIdx inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - EntyclopediaDetailDelegate
- (void)changeCollectStateWithEntity:(STSceneTodayEntity *)entity
{
    [self changeFavDataWithEntity:entity];
}

#pragma mark - 点击事件
- (void)reloadBtnClick:(UIButton *)sender
{
    [self initData];
}

- (void)docTypeClick:(GLButton *)sender
{
    if (!sender.selected) {
        for (NSInteger i = 0;i < _typeArr.count;i++) {
            [(GLButton *)[self.view viewWithTag:300 + i] setSelected:false];
        }
        _selIdx = sender.tag - 300;
        
        _mainSV.contentOffset = CGPointMake(SCREEN_WIDTH * _selIdx,0);
        [self scrollViewDidScroll:_mainSV];
        
        [_mainSV setContentOffset:CGPointMake(SCREEN_WIDTH * _selIdx, 0) animated:true];
        [sender setSelected:true];
        
        [_headLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sender);
            make.size.mas_equalTo(CGSizeMake(sender.width, 2));
            make.bottom.equalTo(sender.mas_bottom);
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
        
        NSMutableArray *tmpArr = [_dataSource objectAtIndex:_selIdx];
        //        if (!tmpArr.count && ![sender.lbl.text isEqualToString:@"诊疗常识"]) {
        [self request];
        //        }
        
        if (!_isLeft) {
            //scrollRight
            if((sender.x + SCREEN_WIDTH/2 <= _headSV.contentSize.width) && sender.x + sender.width/2 >= SCREEN_WIDTH/2){
                [_headSV setContentOffset:CGPointMake(sender.x - SCREEN_WIDTH/2 + sender.width/2, 0) animated:true];
            } else if((sender.x + sender.width/2 + 5) - SCREEN_WIDTH/2 * 1.0f < 0) {
                [_headSV setContentOffset:CGPointMake(0, 0) animated:true];
            } else {
                [_headSV setContentOffset:CGPointMake(_headSV.contentSize.width - SCREEN_WIDTH, 0) animated:true];
            }
        } else {
            //scrollLeft
            if((sender.x + SCREEN_WIDTH/2 >= _headSV.contentSize.width)){
                [_headSV setContentOffset:CGPointMake(_headSV.contentSize.width - SCREEN_WIDTH, 0) animated:true];
            } else if(((sender.x + sender.width/2 + 20) - SCREEN_WIDTH/2 * 1.0f > 0)){
                [_headSV setContentOffset:CGPointMake(sender.x - SCREEN_WIDTH/2 + sender.width/2, 0) animated:true];
            } else {
                [_headSV setContentOffset:CGPointMake(0, 0) animated:true];
            }
        }
    }
}

@end
