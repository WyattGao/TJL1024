//
//  RingTimeHelpView.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/9/6.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import "GLTableView.h"

@interface RingTimeHelpView : GLTableView

@property (nonatomic,strong) NSArray     *hintTextArr;/**< 提示文字集合 */
@property (nonatomic,strong) NSArray     *hintHighlightTextArr;/**< 提示文字高亮部分集合 */
@property (nonatomic,strong) NSArray     *hintHighlightColor;/**< 提示文字高亮部分颜色 */
@property (nonatomic,strong) NSArray     *hintHighlightIndexArr;/**< 存放高亮字符的下标和长度的数组 */
@property (nonatomic,strong) UIView      *ringHeaderView;/**< 环形表头 */

@end
