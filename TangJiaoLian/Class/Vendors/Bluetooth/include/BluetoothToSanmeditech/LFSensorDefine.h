//
//  LFSensorDefine.h
//
//  Created by apple on 12-11-29.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFSensorDefine : NSObject

@end



@interface LFHardwareSensor : NSObject

@property(nonatomic, retain) NSString *deviceId;
@property(nonatomic, retain) NSString *sensorName;
@property(nonatomic, retain) NSString *identifier;
@property(nonatomic, assign) BOOL smdAutoConnect;

@property(nonatomic,retain)NSString *Manufactuer;
@end