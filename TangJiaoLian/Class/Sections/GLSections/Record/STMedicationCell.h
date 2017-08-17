//
//  STMedicationCell.h
//  Diabetes
//
//  Created by 房克志 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addMedicBlock)(NSDictionary *dic);
typedef void (^AddCellValueBlock)(NSInteger indexNum);
typedef void (^SegmentedBlock)(NSString *str);
typedef void (^reloadTextViewCellHeight)();

typedef enum {
    YPXX = 1,//药品信息
    BZXX = 2,//备注信息
    FYSJ = 3,//服药时间
    
}CellID;

@protocol MedicationCellDelegate <NSObject,GLTextFieldDelegate>
@end

@interface STMedicationCell : UITableViewCell<UITextViewDelegate,UITextViewDelegate,UITextFieldDelegate,GLTextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *titArray;
@property (nonatomic,strong) UITextView *BZTextView;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,copy  ) AddCellValueBlock  addBlock;
@property (nonatomic,copy  ) SegmentedBlock  segmentBlock;
@property (nonatomic,copy) addMedicBlock medicBlock;
@property (nonatomic,copy) reloadTextViewCellHeight reloadHightBlock;
@property (nonatomic,strong) UILabel *cellLab1;/**<药品名称*/
@property (nonatomic,strong) GLTextField *textField;/**<服药剂量*/
@property (nonatomic,strong) NSDictionary *medicineDic;
@property (nonatomic) UIButton *leftBtn;
@property (nonatomic) UIButton *rightBtn;
@property (nonatomic,weak) id<MedicationCellDelegate> delegate;
- (instancetype)initWithStyle1:(UITableViewCellStyle)Style reuseIdentifier:(NSString *)reuseIdentifier;
@end
