//
//  APPConst.h
//  TangJiaoLian
//
//  Created by 高临原 on 2017/3/30.
//  Copyright © 2017年 高临原♬. All rights reserved.
//

//绑定设备名称
#define SamBangDingDeviceName @"SamBangDingDeviceName"
//绑定设备开始的时间
#define SamStartBinDingDeviceTime  @"SamStartBinDingDeviceTime"
//绑定结束时间
#define SamEndBinDingDeviceTime @"SamEndBinDingDeviceTime"
//绑定设备的电量
#define SamBangDingDeviceBattery @"SamBangDingDeviceBattery"
//极化成功
#define SamPolarizationFinish  @"SamPolarizationFinish"
//动态血糖值存放数组
#define SamBloodValueArr @"SamBloodValueArr"
//动态血糖值上次上传的血糖值的下标
#define SamBloodUpLoadIdx @"SamBloodUpLoadIdx"
//动态血糖电流值存放数组
#define SamCurrentValueArr @"SamCurrentValueArr"
//动态血糖警告值存放数组
#define SamWaringValueArr @"SamWaringValueArr"
//动态血糖参比血糖存放数组名称
#define SamReferenceArr @"SamReferenceArr"
//设置目标血糖值状态
#define SamTargetState @"SamTargetState"
//目标最低血糖
#define SamTargetLow @"SamTargetLow"
//目标最高血糖
#define SamTargetHeight @"SamTargetHeight"

//指尖血范围餐前黄色高
#define SamFingerRangeBeforeYellowHigh @"SamFingerRangeBeforeYellowHigh"
//指尖血范围餐前黄色低
#define SamFingerRangeBeforeYellowLow @"SamFingerRangeBeforeYellowLow"
//指尖血范围餐后黄色高
#define SamFingerRangeAfterYellowHigh @"SamFingerRangeAfterYellowHigh"
//指尖血范围餐后黄色低
#define SamFingerRangeAfterYellowLow @"SamFingerRangeAfterYellowLow"
//指尖血范围餐前红色高
#define SamFingerRangeBeforeRedHigh @"SamFingerRangeBeforeRedHigh"
//指尖血范围餐前红色低
#define SamFingerRangeBeforeRedLow @"SamFingerRangeBeforeRedLow"
//指尖血范围餐后红色高
#define SamFingerRangeAfterRedHigh @"SamFingerRangeAfterRedHigh"
//指尖血范围餐后红丝低
#define SamFingerRangeAfterRedLow @"SamFingerRangeAfterRedLow"
//指尖血范围餐前绿色高
#define SamFingerRangeBeforeGreenHigh @"SamFingerRangeBeforeGreenHigh"
//指尖血范围餐前绿色低
#define SamFingerRangeBeforeGreenLow @"SamFingerRangeBeforeGreenLow"
//指尖血范围餐后绿色高
#define SamFingerRangeAfterGreenHigh @"SamFingerRangeAfterGreenHigh"
//指尖血范围餐后绿色低
#define SamFingerRangeAfterGreenLow @"SamFingerRangeAfterGreenLow"

//预警过的血糖
#define SamTargetWarningArr @"SamTargetWarningArr"
//用户ACCOUNT
#define USER_ACCOUNT [GL_USERDEFAULTS getStringValue:@"ACCOUNT"]
//用户ID
#define USER_ID [GL_USERDEFAULTS getStringValue:@"USERID"]
//用户登陆状态
#define ISLOGIN ([USER_ACCOUNT length] > 0)
//设备绑定状态
#define ISBINDING [[GL_USERDEFAULTS getStringValue:SamBangDingDeviceName] length]
//是否进行过高血糖预警（高低血糖预警只进行一次）
#define SAMISHIGHWARNING  @"SAMISHIGHWARNING"
//是否进行过低血糖预警
#define SAMISLOWWARNING @"SAMISLOWWARNING"
//是否进行过佩戴位置预警
#define SAMISWEARWARNING @"SAMISWEARWARNING"
//饮食的记录时间
#define SamRecordDietTime @"SamRecordDietTime"
//用药的记录时间
#define SamRecordMedicinalTime @"SamRecordMedicinalTime"
//胰岛素的记录时间
#define SamRecordInsulinTime @"SamRecordInsulinTime"
//运动的记录时间
#define SamRecordSportsTime @"SamRecordSportsTime"
//是否震动
#define SamIsShake @"SamIsShake"
//是否声音通知
#define SamIsAudio @"SamIsAudio"

#define YZToken @"YZToken"
#define YZISLOGIN [GL_USERDEFAULTS boolForKey:@"YZLOGIN"]
#define YZISSHOPINGHINT @"YZISSHOPINGHINT"

/**
 * @brief 获取请求状态
 */
#define GETTAG [response getIntegerValue:@"Tag"]
/**
 * @brief 获取接口返回提示语
 */
#define GETMESSAGE [response getStringValue:@"Message"]
/**
 * @brief 获取请求状态
 */
#define GETRETVAL [[[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETVAL"] isEqualToString:@"S"]
/**
 * @brief 获取接口返回提示语
 */
#define GETRETMSG [[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RETMSG"]

#define FUNCNAME @"FuncName"
#define FUNC @"func"
#define INFIELD  @"InField"
#define OUTFIELD @"OutField"
#define INTABLE @"InTable"
#define OUTTABLE @"OutTable"
