//
//  GLViewController.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/15.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLViewController : UIViewController


/**
 初始化界面
 */
- (void)createUI;

/**
 初始化数据
 */
- (void)createData;


/**
 在self.view上添加一个子View

 @param view 子View
 */
- (void)addSubView:(UIView *)view;


/**
 推出控制器

 @param controller 控制器
 */
- (void)pushWithController:(UIViewController *)controller;


/**
 返回上一个界面
 */
- (void)popViewController;


/**
 设置NavBar标题

 @param title 标题文本
 */
- (void)setNavTitle:(NSString*)title;

/**
 根据图片设置左按钮 默认为返回图案

 @param imgNamed 图片名称
 */
- (void)setLeftBtnImgNamed:(NSString *)imgNamed;


/**
 根据图片设置右按钮

 @param imgNamed 图片名称
 */
- (void)setRightBtnImgNamed:(NSString *)imgNamed;

/**
 根据文本设置navBar右按钮

 @param title 按钮文本
 */
- (void)setRightBtnTitle:(NSString *)title;


/**
 navBar左按钮点击事件

 @param sender 左按钮
 */
- (void)navLeftBtnClick:(UIButton *)sender;


/**
 navBar右按钮点击事件

 @param sender 右按钮
 */
- (void)navRightBtnClick:(UIButton *)sender;



/**
 初始化一个自定义NavBar

 @param title 标题
 @param leftButtonIV 左按钮图案
 @param rightButtonTtile 右按钮标题文字
 */
- (void)initTemporaryNavWithTitle:(NSString *)title LeftButtonIV:(NSString *)leftButtonIV RightButtonTtile:(NSString *)rightButtonTtile;

/**
 键盘消失回调

 @param keyBoardSize 键盘大小
 */
- (void)keyboardWillHideHandler:(CGSize)keyBoardSize;

/**
 键盘出现回调

 @param keyBoardSize 键盘大小
 */
- (void)keyboardWillShowHandler:(CGSize)keyBoardSize;



@property (nonatomic,assign) BOOL navHide; /**< 隐藏navBar */

@property (nonatomic,assign) BOOL isLogin; /**< get方法 获取是否登陆 未登陆调出登陆界面 */

@property (nonatomic,assign) BOOL isKeyboardListener; /**< get方法获取是进行键盘事件监听 */

@property (nonatomic,strong) GLReloadView *reloadView; /**< 刷新View */

@end
