//
//  WoChangePassWordTableView.m
//  TangJiaoLian
//
//  Created by 高临原 on 2017/5/23.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "WoChangePassWordTableView.h"

@implementation WoChangePassWordTableView

- (void)createUI
{
    self.bounces = false;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;          
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mark"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mark"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *hintLbl        = [UILabel new];
        UITextField *passWordTF = [UITextField new];
        
        [cell.contentView addSubview:hintLbl];
        [cell.contentView addSubview:passWordTF];
        
        hintLbl.text          = @[@"新密码",@"验证密码"][indexPath.row];
        hintLbl.font          = GL_FONT(16);
        hintLbl.textColor     = RGB(102, 102, 102);
        hintLbl.textAlignment = NSTextAlignmentRight;
        
        passWordTF.placeholder     = @[@"请输入新密码",@"请确认新密码"][indexPath.row];
        passWordTF.keyboardType    = UIKeyboardTypeNumberPad;
        passWordTF.secureTextEntry = true;
        passWordTF.tag             = 1024 + indexPath.row;
        
        [hintLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView);
        }];
        
        [passWordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(hintLbl.mas_right).offset(30);
            make.right.equalTo(cell.contentView.mas_right);
        }];
        
        if(!indexPath.row){
            UIView *line = [UIView new];
            [cell.contentView addSubview:line];
            
            line.backgroundColor = TCOL_LINE;
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
                make.centerX.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
        }
    }
    return cell;
}

- (NSString *)getNewPassWord
{
    UITextField *firstTF  = [self viewWithTag:1024];
    UITextField *secondTF = [self viewWithTag:1025];
    
    if (![firstTF.text isEqualToString:secondTF.text]) {
        GL_ALERT_E(@"两次输入密码不一致");
        return nil;
    } else if (firstTF.text.length < 6) {
        GL_ALERT_E(@"密码不得少于6位");
        return nil;
    }

    return [firstTF.text md5HexDigest];
}


@end
