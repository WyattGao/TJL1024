//
//  GLTextView.h
//  SuiTangNew
//
//  Created by 高临原 on 2016/8/2.
//  Copyright © 2016年 徐其东. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GLTextViewDelegate <NSObject,UITextViewDelegate>

@end

@interface GLTextView : UITextView

@property (nonatomic,copy) NSString *placeholder;              /**< 提示文字 */

@property (nonatomic,strong) UIColor *placeholderColor;        /**< 提示文字颜色 */

@property (nonatomic,weak) id<GLTextViewDelegate> glDelegate;  /**< GLTextViewDelegate */

@property (nonatomic,strong) UILabel *placeholderLbl;          /**< 提示Label */

@property (nonatomic,assign) CGFloat lineSpacing;             /**< 行间距 */

@end
