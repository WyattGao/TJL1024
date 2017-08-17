//
//  EncyclopediaTypeCell.m
//  SuiTangNew
//
//  Created by 高临原 on 2016/7/22.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import "EncyclopediaTypeCell.h"
#import "LoginViewController.h"

@interface EncyclopediaTypeCell ()

@property (nonatomic,strong) UILabel  *timeLbl;     /**< cell上方时间 */
@property (nonatomic,strong) UIView   *mainView;    /**< 白色主View */
@property (nonatomic,strong) UILabel  *titleLbl;    /**< 主标题 */
@property (nonatomic,strong) GLButton *readBtn;     /**< 阅读 */
@property (nonatomic,strong) UIButton *shareBtn;    /**< 分享 */
@property (nonatomic,strong) UIButton *checkBtn;    /**< 查看更多 */
@property (nonatomic,strong) UIView   *line;        /**< 分割线 */
@property (nonatomic,copy)   NSString *identifier;  /**< cell标识 */

#pragma mark - 名医访谈属性
@property (nonatomic,strong) UILabel *hosLbl;       /**< 医院名称 */
@property (nonatomic,strong) UILabel *docLbl;       /**< 医生名称 */

@end

@implementation EncyclopediaTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.identifier     = reuseIdentifier;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(ws);
        
            _readBtn  = [GLButton new];
//            _favBtn   = [GLButton new];
            _mainIV   = [UIImageView new];
            _titleLbl = [UILabel new];
            
            [self.contentView addSubview:_titleLbl];
            [self.contentView addSubview:_mainIV];
            [self.contentView addSubview:_readBtn];
//            [self.contentView addSubview:_favBtn];
        
            [_readBtn setImage:GL_IMAGE(@"锦囊-阅读") forState:UIControlStateNormal];
            [_readBtn setTitleColor:RGB(113, 113, 113) forState:UIControlStateNormal];
            [_readBtn.lbl setFont:GL_FONT(12)];
            [_readBtn setGraphicLayoutState:PICLEFT];
            [_readBtn setGraphicLayoutSpacing:5];
            [_readBtn addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
//            [_favBtn setImage:GL_IMAGE(@"iconfont-favorite") forState:UIControlStateNormal];
//            [_favBtn setImage:GL_IMAGE(@"iconfont-favorite-sel") forState:UIControlStateSelected];
//            [_favBtn setTitleColor:RGB(113, 113, 113) forState:UIControlStateNormal];
//            [_favBtn.lbl setFont:GL_FONT(12)];
//            [_favBtn setGraphicLayoutState:PICLEFT];
//            [_favBtn setGraphicLayoutSpacing:5];
//            [_favBtn addTarget:self action:@selector(favBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
            [_mainIV setImage:GL_IMAGE(@"图片占位")];
            [_mainIV setCornerRadius:5];
            
//            [_favBtn.iv mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(18.6,17.67));
//            }];
        
            [_readBtn.iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(18.6, 16.5));
            }];
            
            if ([reuseIdentifier isEqualToString:artMark]){
                //文章cell
                
                self.contentView.backgroundColor = RGB(255, 255, 255);
                
                _mainIV.layer.masksToBounds = true;
                
                _line = [UIView new];
                
                [self.contentView addSubview:_line];
                
                _titleLbl.numberOfLines = 2;
                _titleLbl.font          = GL_FONT(17);
                _titleLbl.textColor     = RGB(51, 51, 51);
                
                _line.backgroundColor   = RGB(213, 213, 213);
                
                [_mainIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(ws.contentView).offset(10);
                    make.centerY.equalTo(ws.contentView);
                    make.size.mas_equalTo(CGSizeMake(104, 78));
                }];
                
                [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_mainIV.mas_right).offset(12);
                    make.top.equalTo(_mainIV);
                    make.right.equalTo(ws.contentView.mas_right).offset(-15);
                }];
                
                [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_mainIV.mas_right).offset(12);
                    make.bottom.equalTo(_mainIV);
                }];
                
//                [_favBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(_readBtn.mas_right).offset(10.7);
//                    make.centerY.equalTo(_readBtn);
//                }];
 
                [_line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_mainIV.mas_bottom).offset(9);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15 * 2, 1));
                    make.centerX.equalTo(ws.contentView);
                    make.bottom.equalTo(ws.contentView.mas_bottom);
                }];
            }
    }
    return self;
}

- (void)setEntity:(STSceneTodayEntity *)entity
{
    _entity = entity;
    
    if (entity) {
        
        [_titleLbl setText:entity.TITLE];
//        [_titleLbl setAttributedText:[Tools HangJianJu:entity.TITLE andJianJu:5]];
        
        [_mainIV   sd_setImageWithURL:[NSURL URLWithString:entity.SPIC] placeholderImage:GL_IMAGE(@"图片占位")];
        [_favBtn   setTitle:entity.COLLECTNUM forState:UIControlStateNormal];
        [_favBtn   setSelected:[entity.COLLECTSTATUS integerValue]];
        [_readBtn  setTitle:entity.CLICKNUM forState:UIControlStateNormal];
        
        if ([_identifier isEqualToString:vidMark]) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[entity.CREATTIME integerValue]];
            _timeLbl.text = [date toString:@"yyyy-MM-dd"];
            _docLbl.text = entity.USERNAME;
            _hosLbl.text = entity.SKETCH;
            [_mainIV   sd_setImageWithURL:[NSURL URLWithString:entity.PIC] placeholderImage:GL_IMAGE(@"图片占位")];
            
            [_docLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo([_docLbl getLabelWidth]);
                make.left.equalTo(_mainView.mas_left).offset(15);
                make.top.equalTo(_mainView).offset(16);
            }];
        } else {
            [_mainIV sd_setImageWithURL:[NSURL URLWithString:entity.SPIC] placeholderImage:GL_IMAGE(@"图片占位")];
            _timeLbl.text = entity.CREATTIME;
        }
    }
}

#pragma mark - Click
- (void)favBtnClick:(GLButton *)sender
{
    NSString *collectType = @"0";
    if ([_identifier isEqualToString:proVidMark] || [_identifier isEqualToString:vidMark]) {
        collectType = @"2";
    }
    
    if (![USER_ACCOUNT isEqualToString:@"0"]&&![USER_ACCOUNT isEqualToString:@""]&&[USER_ACCOUNT length]) {
        NSString *event = @"0";
        if (sender.selected) {
            event = @"1";
        } else {
            event = @"0";
        }
        NSDictionary *postDic = @{
                                  @"FuncName" : @"collect",
                                  @"InField"  : @{
                                          @"DEVICE" : @"1",
                                          @"EVENT"  : event
                                          },
                                  @"InTable"  : @{
                                          @"COLLECT" : @[
                                                  @{
                                                      @"ACCOUNT" : USER_ACCOUNT,
                                                      @"TYPE"    : collectType,//2 是视频
                                                      @"PID"     : _entity.ID //_entity.ID
                                                      }
                                                  ]
                                          },
                                  @"OutField" : @[]
                                  };
        
        [GL_Requst postWithParameters:postDic SvpShow:true success:^(GLRequest *request, id response) {
            if ([response getIntegerValue:@"Tag"]) {
                
                if (sender.selected) {
                    //收藏数-1
                    [sender setTitle:[NSString stringWithFormat:@"%ld",[sender.lbl.text integerValue] - 1] forState:UIControlStateNormal];
                    GL_ALERT_S(@"已取消收藏");
                    _entity.COLLECTSTATUS = @"0";
                    _entity.COLLECTNUM    =  [NSString stringWithFormat:@"%ld",[_entity.COLLECTNUM integerValue] - 1];
                } else {
                    //收藏数+1
                    [sender setTitle:[NSString stringWithFormat:@"%ld",[sender.lbl.text integerValue] + 1] forState:UIControlStateNormal];
                    GL_ALERT_S(@"收藏成功");
                    _entity.COLLECTSTATUS = @"1";
                    _entity.COLLECTNUM    =  [NSString stringWithFormat:@"%ld",[_entity.COLLECTNUM integerValue] + 1];
                }
                
                sender.selected = !sender.selected;
                
                
                if ([_delegate respondsToSelector:@selector(changeFavDataWithEntity:)]) {
                    [self.delegate changeFavDataWithEntity:_entity];
                }
            } else {
                if (sender.selected) {
                    GL_ALERT_E(@"取消收藏失败，请稍后再试");
                } else {
                    GL_ALERT_E(@"收藏失败，请稍后再试");
                }
            }
        } failure:^(GLRequest *request, NSError *error) {
            if (sender.selected) {
                GL_ALERT_E(@"取消收藏失败，请稍后再试");
            } else {
                GL_ALERT_E(@"收藏失败，请稍后再试");
            }
        }];
    } else {
        LoginViewController *loginVC = [LoginViewController new];
        [[self getFormViewController] presentViewController:loginVC animated:YES completion:nil];
    }
}

//- (void)shareBtnClick:(UIButton *)sender
//{
//    ShareDataType type = articleData;
//    
//    [[STUMShare share]shareWithTitle:self.entity.TITLE
//                                Text:self.entity.SKETCH
//                               Image:self.entity.PIC ? self.entity.PIC : self.entity.SPIC
//                            ClickUrl:self.entity.URL ? self.entity.URL : self.entity.H5URL
//                              Target:[self getFormViewController]
//                            DataType:type
//     ];
//}

- (void)readBtnClick:(UIButton *)sender
{
    
}

@end
