//
//  STPersonInfoViewController.m
//  SuiTangNew
//
//  Created by 高临原 on 16/7/4.
//  Copyright © 2016年 高临原♬. All rights reserved.
//
#import "STPersonInfoViewController.h"
#import "STPersonInfoCell.h"
#import "STEditiInfoViewController.h"
#import "SpringsBoxView.h"
#import "STListSelectionView.h"
#import "STSelectDateView.h"
#import "TherapyMethodViewController.h"

@interface STPersonInfoViewController ()
<
 SpringsBoxViewBLDelegate,
 ListSelectionDelegate,
 EditiInfoDelegate,
 SelecteDateDelegate,
 UIActionSheetDelegate,
 PersonCellDelegate,
 UIGestureRecognizerDelegate,
 UIAlertViewDelegate,
 TherapyMethodViewControllerDelegate,
 UITableViewDataSource,
 UITableViewDelegate,
 UINavigationControllerDelegate,
 UIImagePickerControllerDelegate
>

@property (nonatomic,strong) UITableView *mainTV;

@property (nonatomic,strong) UIImageView *picIV;

@property (nonatomic,copy) NSIndexPath *selIndexPath;

@property (nonatomic,strong) NSUserDefaults *U;

@property (nonatomic) BOOL isEditi;

@property (nonatomic,strong) NSMutableDictionary *saveDic;


@end

@implementation STPersonInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navHide = false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

- (void)initNav
{
    [self setNavTitle:@"个人信息"];
    [self setLeftBtnImgNamed:nil];
}

- (void)initUI
{
    _mainTV = [UITableView new];
    
    [self addSubView:_mainTV];
    
    _mainTV.delegate               = self;
    _mainTV.dataSource             = self;
    _mainTV.separatorStyle         = UITableViewCellSeparatorStyleNone;
    _mainTV.backgroundColor        = RGB(246, 246, 250);
    _mainTV.tableHeaderView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    
    WS(ws);
    
    [_mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(64);
        make.bottom.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
}

- (void)initData
{

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!section) {
        return 5; //多返回一行作为分割线
    }
//    return 10;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastRow = [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1;
    //顶部分割线
    if (!indexPath.section && !indexPath.row) {
            return 72;
    }
    //每段最后一行分割线
    if (indexPath.row == lastRow) {
        return 9.5;
    }
    
    return 42;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mark = [NSString stringWithFormat:@"%ld",indexPath.row + indexPath.section * 10];
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        mark = lastRow;
    }
    STPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (!cell) {
        cell = [[STPersonInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    if (!indexPath.section && indexPath.row == 2) {
        cell.delegate = self;
    }
    cell.patientDic  = _patientDic;
    cell.userBaseDic = _userBaseDic;
    [cell reloadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selIndexPath = indexPath;
    
    _isEditi = true;
    
    if (!indexPath.section) {
        if (indexPath.row == 0) {
            UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
            [action showInView:self.view];
        }
        if (indexPath.row == 1) { //修改昵称
            STEditiInfoViewController *editiInfoVC = [[STEditiInfoViewController alloc]initWithType:NikeName];
            editiInfoVC.delegate = self;
            editiInfoVC.editiStyle = NikeName;
            editiInfoVC.tf1Str   = [[(STPersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath] rightLbl] text];
            [self pushWithController:editiInfoVC];
        }
        if (indexPath.row == 3) {
            STSelectDateView *selDateView = [[STSelectDateView alloc]initDatePickerView];
            [GL_KEYWINDOW addSubview:selDateView];
            selDateView.delegate = self;
            [selDateView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(GL_KEYWINDOW);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
            }];
        }
        if (indexPath.row == 4) {
            if ([[[(STPersonInfoCell *)[tableView cellForRowAtIndexPath:indexPath] rightLbl] text] length]) {
                GL_ALERT_S(@"您已绑定手机号");
            } else {
                STEditiInfoViewController *editiInfoVC = [[STEditiInfoViewController alloc]initWithType:BingDingPhone];
                editiInfoVC.delegate = self;
                [self pushWithController:editiInfoVC];
            }
        }
    } else {
        SpringsBoxView *boxView;
        if (indexPath.row == 0) {
            STListSelectionView *listSeView = [STListSelectionView new];
            listSeView.delegate = self;
            [listSeView show];
        }
        if (indexPath.row == 1) {
            STSelectDateView *selDateView = [[STSelectDateView alloc]initWithType:ParticularYear];
            [selDateView show];
            selDateView.delegate = self;
        }
        if (indexPath.row == 2) {
            TherapyMethodViewController *methodVC = [TherapyMethodViewController new];
            methodVC.therapyMethodArr             = [NSMutableArray arrayWithArray:[_patientDic getArrValue:@"TREATTYPE"]];
            methodVC.delegate = self;
            [self.navigationController pushViewController:methodVC animated:true];
        }
        if (indexPath.row == 3) {
            boxView = [[SpringsBoxView alloc]initWithTitle:@"身高" Num:2 lMiniScope:100 TolMaxScope:300 rMiniScope:0 TorMaxScope:9 Unit:@"cm" DetailsArr:@[@"身高"]];
            boxView.delegate2 = self;
            [GL_KEYWINDOW addSubview:boxView];
        }
        if (indexPath.row == 4) {
            boxView = [[SpringsBoxView alloc]initWithTitle:@"体重" Num:2 lMiniScope:30 TolMaxScope:300 rMiniScope:0 TorMaxScope:9 Unit:@"kg" DetailsArr:@[@"体重"]];
            boxView.delegate2 = self;
            [GL_KEYWINDOW addSubview:boxView];
        }
        if (indexPath.row == 5) {
            boxView = [[SpringsBoxView alloc]initWithTitle:@"腰围" Num:2 lMiniScope:30 TolMaxScope:300 rMiniScope:0 TorMaxScope:9 Unit:@"cm" DetailsArr:@[@"腰围"]];
            boxView.delegate2 = self;
            [GL_KEYWINDOW addSubview:boxView];
        }
        if (indexPath.row == 7) {
            boxView = [[SpringsBoxView alloc]initWithTitle:@"心率" Num:1 lMiniScope:40 TolMaxScope:160 rMiniScope:0 TorMaxScope:0 Unit:@"次/分" DetailsArr:@[@"心率"]];
            boxView.delegate2 = self;
            [GL_KEYWINDOW addSubview:boxView];
        }
        if (indexPath.row == 8) {
            boxView = [[SpringsBoxView alloc]initWithTitle:@"血压" Num:2 lMiniScope:50 TolMaxScope:180 rMiniScope:50 TorMaxScope:180 Unit:@"mmHg" DetailsArr:@[@"收缩压",@"舒张压"]];
            boxView.delegate2 = self;
            [GL_KEYWINDOW addSubview:boxView];
            boxView.isHideUnit = YES;
        }
        
        [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(GL_KEYWINDOW);
            make.size.equalTo(GL_KEYWINDOW);
        }];
        
        boxView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            boxView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        
    }
}

- (void)springsBoxViewSelectedWhitBoxView:(SpringsBoxView *)BoxView
{
    STPersonInfoCell *cell = [_mainTV cellForRowAtIndexPath:_selIndexPath];
    
    if ([cell.leftLbl.text isEqualToString:@"身高"]) {
        cell.rightLbl.text = [NSString stringWithFormat:@"%@cm",BoxView.leftStr];
        [_patientDic setObject:BoxView.leftStr forKey:@"HEIGHT"];
    }
    if ([cell.leftLbl.text isEqualToString:@"体重"]) {
        cell.rightLbl.text = [NSString stringWithFormat:@"%@kg",BoxView.leftStr];
        [_patientDic setObject:BoxView.leftStr forKey:@"WEIGHT"];
    }
    if ([cell.leftLbl.text isEqualToString:@"腰围"]) {
        cell.rightLbl.text = [NSString stringWithFormat:@"%@cm",BoxView.leftStr];
        [_patientDic setObject:BoxView.leftStr forKey:@"WAISTLINE"];
    }
    if ([cell.leftLbl.text isEqualToString:@"心率"]) {
        cell.rightLbl.text = [NSString stringWithFormat:@"%@次/分",BoxView.leftStr];
        [_patientDic setObject:BoxView.leftStr forKey:@"HEARTRATE"];
    }
    if ([cell.leftLbl.text isEqualToString:@"血压"]) {
        cell.rightLbl.text = [NSString stringWithFormat:@"高压%@ 低压%@",BoxView.leftStr,BoxView.rightStr];
        [_patientDic setObject:BoxView.leftStr forKey:@"HIGHESTHYPERTENSION"];
        [_patientDic setObject:BoxView.rightStr forKey:@"LOWESTHYPERTENSION"];
    }
    
    
    [self getBMI];
}

- (void)springsBoxViewSelectedWhitNumStr:(NSString *)numStr
{
    
}


- (void)getBMI
{
    STPersonInfoCell *heightCell = [_mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    STPersonInfoCell *kgCell     = [_mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    STPersonInfoCell *bmiCell    = [_mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    
    if (heightCell.rightLbl.text.length && kgCell.rightLbl.text.length) {
        NSString *hight = [heightCell.rightLbl.text substringToIndex:heightCell.rightLbl.text.length - 2];
        NSString *kg    = [kgCell.rightLbl.text substringToIndex:kgCell.rightLbl.text.length - 2];
        
        if (([hight integerValue] >= 100&&[hight integerValue] <= 300)&&([kg floatValue] >= 30 && [kg floatValue] <= 300))
        {
            bmiCell.rightLbl.text =  [NSString stringWithFormat:@"%.2f",[kg doubleValue]/(([hight doubleValue]/100)*([hight doubleValue]/100))];
            [_patientDic setObject:bmiCell.rightLbl.text forKey:@"BMI"];
            [_userBaseDic setObject:bmiCell.rightLbl.text forKey:@"BMI"];
        }
    }
}

- (void)getListSelText:(NSString *)text
{
    STPersonInfoCell *cell = [_mainTV cellForRowAtIndexPath:_selIndexPath];
    cell.rightLbl.text = text;
    
    if ([cell.leftLbl.text isEqualToString:@"糖尿病类型"]) {
        if ([text isEqualToString:@"无"]) {
            [_patientDic setObject:@"0" forKey:@"DIABETESTYPE"];
        }
        if ([text isEqualToString:@"1型糖尿病"]) {
            [_patientDic setObject:@"1" forKey:@"DIABETESTYPE"];
        }
        if ([text isEqualToString:@"2型糖尿病"]) {
            [_patientDic setObject:@"2" forKey:@"DIABETESTYPE"];
        }
        if ([text isEqualToString:@"妊娠糖尿病"]) {
            [_patientDic setObject:@"3" forKey:@"DIABETESTYPE"];
        }
        if ([text isEqualToString:@"特殊糖尿病"]) {
            [_patientDic setObject:@"4" forKey:@"DIABETESTYPE"];
        }
    }
}

//获取修改后的手机号和昵称
- (void)getEditiContent:(NSString *)editiStr
{
    STPersonInfoCell *cell = [_mainTV cellForRowAtIndexPath:_selIndexPath];
    
    NSMutableString *str = [[NSMutableString alloc]initWithString:editiStr];
    if ([cell.leftLbl.text isEqualToString:@"绑定手机号"]) {
        [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [_userBaseDic setObject:editiStr forKey:@"PHONE"];
        [_U setObject:editiStr forKey:@"PHONE"];
    }
    if ([cell.leftLbl.text isEqualToString:@"昵称"]) {
        [_userBaseDic setObject:editiStr forKey:@"USERNAME"];
    }
    cell.rightLbl.text = str;
}

//修改治疗方式代理回调方法
- (void)changeTherapyMethodArr:(NSArray *)arr
{
    [_patientDic setValue:arr forKey:@"TREATTYPE"];;
    STPersonInfoCell *cell = [_mainTV cellForRowAtIndexPath:_selIndexPath];
    cell.rightLbl.text = [arr componentsJoinedByString:@","];
}

- (void)getSelecteDataYeaer:(NSString *)Year WithMoth:(NSString *)Moth WithDay:(NSString *)day
{
    STPersonInfoCell *cell = [_mainTV cellForRowAtIndexPath:_selIndexPath];
    if (!_selIndexPath.section) {
        cell.rightLbl.text =  [NSString stringWithFormat:@"%@-%@-%@",Year,Moth,day];
        [_userBaseDic setObject:[NSString stringWithFormat:@"%@-%@-%@",Year,Moth,day] forKey:@"BIRTHDAY"];
    } else {
        cell.rightLbl.text =  [NSString stringWithFormat:@"%@年",Year];
        [_patientDic setObject:Year forKey:@"ILLYEARS"];
    }
}

- (void)changeSex:(NSString *)sex
{
    [_patientDic setObject:sex forKey:@"SEX"];
    [_userBaseDic setObject:sex forKey:@"SEX"];
}

#pragma mark ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    if (buttonIndex == 0) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSLog(@"访问相机权限受限，请到设置-隐私-相机中开启");
            return;
        }
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
        if (!isCamera) {
            GL_ALERT_AFTER(@"相机打开失败！请重试", 1.0f);
            return ;
        }
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
        picker.delegate      = self;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else if(buttonIndex ==1){
        picker.sourceType    = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.delegate      = self;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark ImagePickerController的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    image =[Tools image:image fitInSize:CGSizeMake(200, 200)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self upLoadImage:image];
}

#pragma mark 上传头像
-(void)upLoadImage:(UIImage *)imageURL
{
//    imageURL = [UIImage scaleImage:imageURL toKb:200];
    NSData *data = [NSData compressImage:imageURL toByte:200 * 1024];
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dict = @{
                           FUNCNAME:@"uploadPicIos",
                           INFIELD:@{
                                   @"ACCOUNT":USER_ACCOUNT,
                                   @"DEVICE":@"0",
                                   @"FACE":encodedImageStr
                                   },
                           OUTFIELD:@[
                                   @"RETVAL",
                                   @"RETMSG"
                                   ]
                           };
    [GL_Requst postWithParameters:dict SvpShow:true success:^(GLRequest *request, id response) {
        if ([response getIntegerValue:@"Tag"]) {
            NSString *picUrl = [[[response objectForKey:@"Result"] objectForKey:@"OutField"] getStringValue:@"RET_FACE"];
            STPersonInfoCell *cell = [_mainTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            //            [_userBaseDic setObject:picUrl forKey:@"PIC"];
            [cell.picIV sd_setImageWithURL:[NSURL URLWithString:picUrl]];
            [_U setObject:picUrl forKey:@"PIC"];
            [_patientDic setObject:picUrl forKey:@"PIC"];
            [_userBaseDic setObject:picUrl forKey:@"PIC"];
        } else {
            GL_ALERT_E(@"头像上传失败，请稍后再试");
        }
    } failure:^(GLRequest *request, NSError *error) {
        GL_ALERT_E(@"头像上传失败，请稍后再试");
    }];
}

- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSDictionary *postDic = @{
                                  FUNCNAME : @"saveUserInfo",
                                  INFIELD  : @{@"DEVICE" : @"1"},
                                  INTABLE  :@{
                                          @"USER_BASE" : @[_userBaseDic],
                                          @"PATIENT" : @[_patientDic]
                                          }
                                  };
        
        [GL_Requst postWithParameters:postDic SvpShow:false success:^(GLRequest *request, id response) {
            if ([response getIntegerValue:@"Tag"]) {
                
                [GL_USERDEFAULTS setValuesForKeysWithDictionary:_userBaseDic];
                [GL_USERDEFAULTS setValuesForKeysWithDictionary:_patientDic];
                
                GL_NOTIC_CENTER_POST1(@"changeUserInfo");
            } else {
                //            GL_ALERT_E(@"保存失败，请稍后再试");
            }
        } failure:^(GLRequest *request, NSError *error) {
            //        GL_ALERT_E(@"保存失败，请稍后再试");
        }];
    }
}

- (void)navLeftBtnClick:(UIButton *)sender
{
    [super navLeftBtnClick:sender];
}

@end
