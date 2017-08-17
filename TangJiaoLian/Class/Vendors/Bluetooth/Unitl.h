//
//  Unitl.h
//  BluetoothDemo
//
//  Created by bai on 16/2/25.
//  Copyright © 2016年 Sanmeditech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Unitl : NSObject


+ (NSTimer *)addTimeOutOperationWithInterval:(CGFloat)interval completionBlock:(void (^)())completentBlock;


@end
