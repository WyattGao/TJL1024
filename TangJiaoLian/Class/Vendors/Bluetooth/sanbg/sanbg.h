//========================================================================
//
// File: sanbg.h
//
// Description:
//
// Created:2014.5
//
// Author: TONG Bin  www.wicoolsoft.com
//
//========================================================================


//----------------------------------
//      global  definition
//----------------------------------

#define BGC_OK	0				//正常

//about current
#define BGC_CURRENT_ZERO 		1	//电流为零。电流持续等于或近似零
#define BGC_CURRENT_TOOLOW		2	//电流过低。电流持续小于设定的最小值
#define BGC_CURRENT_TOOHIGH		3	//电流过高。电流持续大于设定的最大值

//about bg
#define BGC_BG_NONE				1	//不能进行转化，尚未输入参比
#define BGC_BG_ERRORCURRENT		2	//当前电流异常
#define BGC_BG_ERRORK			3	//当前K值异常
#define BGC_BG_ROC				4   //血糖ROC异常

//about k
#define BGC_K_TOOLOW			1	//计算后，K值小于设定的最小值
#define BGC_K_TOOHIGH			2	//计算后，K值大于设定的最大值


//about trend
#define BGC_TREND_SHARPRISE		0	//快速上升
#define BGC_TREND_RISE  		1	//上升
#define BGC_TREND_STEADY		3	//稳定
#define BGC_TREND_FALL			4	//下降
#define BGC_TREND_SHARPFALL		5	//快速下降
#define BGC_TREND_UNCLEAR		6	//趋势不明



typedef struct{
    unsigned int state;
    unsigned int bg;
    unsigned int trend;
    unsigned int K;
    unsigned int Backgroud;
}_sConvertResult_t;


//----------------------------------
//      global  function
//----------------------------------
extern void BGC_Init();
extern int BGC_InputCurrent(unsigned int current, _sConvertResult_t *result);
extern int BGC_InputReference(unsigned int ref, int type);
extern int BGC_PermitRef();
extern long BGC_GetInputCurrentCount();
extern void BGC_ContinueConverting(unsigned int K, unsigned int background, unsigned int latestcurrent);

extern int BGC_Verion();
