//
//  GLPicReincarnationView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/4/1.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLPicReincarnationView.h"

@interface GLPicReincarnationView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *mainSV;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) CGRect  selfFrame;

@end

@implementation GLPicReincarnationView

- (instancetype)initWithFrame:(CGRect)frame WithPics:(NSArray *)picsArr WithTitles:(NSArray *)titlesArr;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createWithFrame:frame WithPiceArr:picsArr WithTitles:titlesArr];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createWithFrame:frame WithPiceArr:nil WithTitles:nil];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)createWithFrame:(CGRect)frame WithPiceArr:(NSArray *)picsArr WithTitles:(NSArray *)titlesArr
{
    WS(ws);
    
    [self stop];
    [self removeAllChildView];
    
    if (picsArr) {
        //                picsArr = @[@"http://img5q.duitang.com/uploads/blog/201403/18/20140318120254_LXV4P.jpeg",@"http://pic31.nipic.com/20130722/11643229_142927221112_2.jpg",@"http://file2.zhituad.com/thumb/201201/13/201201130300339473kNpfJ_priv.jpg"];
        
        _mainSV                                  = [UIScrollView new];
        _mainSV.contentOffset                    = CGPointMake(frame.size.width, 0);
        _mainSV.pagingEnabled                    = YES;
        _mainSV.showsHorizontalScrollIndicator   = NO;
        _mainSV.delegate                         = self;
        _mainSV.scrollEnabled                    = YES;
        
        _pageContr                               = [UIPageControl new];
        _pageContr.numberOfPages                 = picsArr.count;
        _pageContr.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageContr.currentPage                   = 0;
        _pageContr.userInteractionEnabled        = false;
        
        [self addSubview:_mainSV];
        [self addSubview:_pageContr];
        
        [_mainSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws);
            make.size.equalTo(ws);
        }];
        
        [_pageContr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws);
            make.bottom.equalTo(_mainSV.mas_bottom).offset(-0.2);
            make.size.mas_equalTo(CGSizeMake(60, 30));
        }];
        
        [picsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *iv = [UIImageView new];
            iv.contentMode  = UIViewContentModeScaleToFill  ;
            iv.tag = idx + 11;
            iv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(picClick:)];
            [iv addGestureRecognizer:tapGesture];
            [_mainSV addSubview:iv];
            
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_mainSV).offset(SCREEN_WIDTH * (idx + 1));
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, frame.size.height));
                make.centerY.equalTo(_mainSV);
            }];
            if (picsArr.count) {
                if ([obj isKindOfClass:[NSString class]]) {
                    [iv sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:GL_IMAGE(@"icon_文章图片_占位")];
                } else if([obj isKindOfClass:[UIImage class]]){
                    [iv setImage:obj];
                } else if ([obj isKindOfClass:[NSData class]]){
                    [iv setImage:[UIImage imageWithData:obj]];
                }
            }
        }];
        
        //如果图片大于1张 添加循环滚动
        if (picsArr.count > 1) {
            
            _mainSV.contentSize = CGSizeMake(SCREEN_WIDTH * (picsArr.count + 2), 0);
            //最后一张
            UIImageView *iv = [UIImageView new];
            iv.contentMode  = UIViewContentModeScaleToFill  ;
            
            iv.tag = picsArr.count + 10;
            [_mainSV addSubview:iv];
            
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_mainSV).offset(_mainSV.contentSize.width);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, frame.size.height));
                make.centerY.equalTo(_mainSV);
            }];
            
            if ([[picsArr firstObject] isKindOfClass:[NSString class]]) {
                [iv sd_setImageWithURL:[NSURL URLWithString:[picsArr firstObject]] placeholderImage:GL_IMAGE(@"icon_文章图片_占位")];
            } else if([[picsArr firstObject] isKindOfClass:[UIImage class]]){
                [iv setImage:[picsArr firstObject]];
            } else if ([[picsArr firstObject] isKindOfClass:[NSData class]]){
                [iv setImage:[UIImage imageWithData:[picsArr firstObject]]];
            }
            
            //第一张
            UIImageView *iv2 = [UIImageView new];
            iv2.tag = 10;
            iv2.contentMode  = UIViewContentModeScaleToFill  ;
            
            [_mainSV addSubview:iv2];
            
            [iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_mainSV).offset(0);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, frame.size.height));
                make.centerY.equalTo(_mainSV);
            }];
            
            if ([[picsArr lastObject] isKindOfClass:[NSString class]]) {
                [iv2 sd_setImageWithURL:[NSURL URLWithString:[picsArr lastObject]] placeholderImage:GL_IMAGE(@"icon_文章图片_占位")];
            } else if([[picsArr lastObject] isKindOfClass:[UIImage class]]){
                [iv2 setImage:[picsArr lastObject]];
            } else if ([[picsArr lastObject] isKindOfClass:[NSData class]]){
                [iv2 setImage:[UIImage imageWithData:[picsArr lastObject]]];
            }
            
            [self start];
        }
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat page = (scrollView.contentOffset.x/SCREEN_WIDTH);
    
    if (page + 1 >= (scrollView.contentSize.width/SCREEN_WIDTH)) {
        scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _pageContr.currentPage = 0;
    }  else if (page <= 0){
        _pageContr.currentPage = (scrollView.contentSize.width/SCREEN_WIDTH) - 3;
        scrollView.contentOffset = CGPointMake((_pageContr.currentPage + 1) * SCREEN_WIDTH, 0);
    } else {
        _pageContr.currentPage = page - 1;
    }
}

//手动拖拽开始时触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stop];
}

//手动拖拽结束时触发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self start];
}

- (void)start
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0f
                                              target:self
                                            selector:@selector(next)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stop
{
    [_timer invalidate];
}

- (void)next
{
    if (_pageContr.currentPage + 1 == _pageContr.numberOfPages) {
        _pageContr.currentPage = 0;
        [_mainSV setContentOffset:CGPointMake((_pageContr.numberOfPages + 1) * SCREEN_WIDTH, 0) animated:YES];
    } else {
        _pageContr.currentPage ++;
        [_mainSV setContentOffset:CGPointMake((_pageContr.currentPage + 1) * SCREEN_WIDTH, 0) animated:YES];
    }
    
}

- (void)setImageArr:(NSArray *)imageArr WithTilteArr:(NSArray *)titleArr
{
    [self createWithFrame:self.frame WithPiceArr:imageArr WithTitles:titleArr];
}


- (void)picClick:(UITapGestureRecognizer *)getsture
{
    if (_picReClick) {
        _picReClick(getsture.view.tag - 11);
    }
}

- (void)PicReClick:(PicReClick)picReClick
{
    _picReClick = picReClick;
}

@end
