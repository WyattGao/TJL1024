//
//  STDataAnalysisViewCell.m
//  Diabetes
//
//  Created by 高临原 on 16/4/7.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STDataAnalysisViewCell.h"

@implementation STDataAnalysisViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WS(ws);
        
        _leftLbl  = [UILabel new];
        _rightLbl = [UILabel new];
        
        [self.contentView addSubview:_leftLbl];
        [self.contentView addSubview:_rightLbl];
        
        _leftLbl.font       = GL_FONT(13.6);
        _leftLbl.textColor  = RGB(155, 155, 155);

        _rightLbl.font      = GL_FONT(13.6);
        _rightLbl.textColor = RGB(74, 74, 74);
        
        [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(17.5);
            make.centerY.equalTo(ws.contentView);
        }];
        
        [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.contentView.mas_right).offset(-25);
            make.centerY.equalTo(ws.contentView);
        }];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
