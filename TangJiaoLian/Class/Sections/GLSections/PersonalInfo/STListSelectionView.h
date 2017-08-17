//
//  STListSelectionView.h
//  Diabetes
//
//  Created by 高临原 on 16/3/7.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STListSelectionView;

@protocol ListSelectionDelegate <NSObject>

@optional
- (void)getListSelText:(NSString *)text;

@optional
- (void)getListSelView:(STListSelectionView *)listView;

@end

@interface STListSelectionView : UIView

@property (nonatomic,weak) id<ListSelectionDelegate> delegate;

@property (nonatomic,copy) NSString *selText;

- (void)show;

@end
