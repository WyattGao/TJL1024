//
//  PictureExaminationView.m
//  Diabetes
//
//  Created by 高临原 on 15/11/20.
//  Copyright © 2015年 hlcc. All rights reserved.
//

#import "PictureExaminationView.h"

@interface PictureExaminationView()
{
    NSInteger picTag;
    BOOL      isLeft;
}
@property (nonatomic,strong) UIScrollView *mainSV;
@property (nonatomic,strong) UIImageView *iv;

@end

@implementation PictureExaminationView

- (instancetype)initWithPics:(NSArray *)picArr Withindex:(NSInteger)index;
{
    self = [super init];
    if (self) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        isLeft = NO;
        
        picTag = (index/10) * 10;
        
        self.backgroundColor = [UIColor blackColor];
        
        _mainSV = [UIScrollView new];
        
        UIButton *nBtn = [UIButton new];
        _yBtn = [UIButton new];
        
        [self addSubview:_mainSV];
        [self addSubview:nBtn];
        [self addSubview:_yBtn];
        
        _mainSV.contentSize     = CGSizeMake(SCREEN_WIDTH * picArr.count, 0);
        _mainSV.pagingEnabled   = YES;
        _mainSV.contentOffset   = CGPointMake(SCREEN_WIDTH * (index % 10), 0);
        
        nBtn.tag                = 10;
        _yBtn.tag               = 11;
        _yBtn.hidden            = YES;
        
        [nBtn setTitle:@"取消" forState:UIControlStateNormal];
        [nBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_yBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_yBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_yBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        WS(ws);
        
        [_mainSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws);
            make.size.equalTo(ws);
        }];

        
        [nBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws).offset(30);
            make.left.equalTo(ws).offset(13);
        }];
        
        [_yBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws).offset(30);
            make.right.equalTo(ws.mas_right).offset(-13);
        }];
        
        [picArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _iv = [UIImageView new];
            if ([obj isKindOfClass:[NSData class]]) {
                [_iv setImage:[UIImage imageWithData:obj]];
            }else if([obj isKindOfClass:[UIImage class]])
            {
                [_iv setImage:obj];
            }
            else {
                NSData *decodedImageData = [[NSData alloc]
                                            initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [_iv setImage:[UIImage imageWithData:decodedImageData]];
            }
            [_mainSV addSubview:_iv];
            
            _iv.contentMode = UIViewContentModeScaleAspectFit;
            _iv.backgroundColor = [UIColor clearColor];
            _iv.tag             = index;
//            iv.layer.borderWidth = 1;
//            iv.layer.borderColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.5].CGColor;
            
            [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_mainSV);
                make.centerY.equalTo(_mainSV).offset(20);
                make.width.equalTo(@(SCREEN_WIDTH));
                make.left.equalTo(@(SCREEN_WIDTH * idx));
                make.height.equalTo(@(SCREEN_HEIGHT - 80));
            }];
        }];
        
    }
    return self;
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 11) {
        NSInteger ivTag ;
        if (isLeft) {
            ivTag = (_mainSV.contentOffset.x/SCREEN_HEIGHT) + picTag;
        } else {
            ivTag = (_mainSV.contentOffset.x/SCREEN_WIDTH) + picTag;
        }
        [[self viewWithTag:ivTag] removeFromSuperview];
        [self.delegate picRemWithTag:ivTag];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;//支持转屏
}

- (void)setDelegate:(id<picRemDelegate>)delegate
{
    _delegate = delegate;
    [self viewWithTag:11].hidden = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
    }else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



@end
