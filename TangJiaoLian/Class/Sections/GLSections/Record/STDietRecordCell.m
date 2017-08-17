//
//  STDietRecordCell.m
//  Diabetes
//
//  Created by 高临原 on 16/3/2.
//  Copyright © 2016年 hlcc. All rights reserved.
//

#import "STDietRecordCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PictureExaminationView.h"
#import "PictureExaminationView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MWPhotoBrowser.h"
#import "DNImagePickerController.h"
#import "DNAsset.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>


typedef NS_ENUM(NSInteger) {
    ADDPIC,
    REPIC
} UPDATAPIC_STATE;



@interface STDietRecordCell ()
  <
   UIImagePickerControllerDelegate,
   UINavigationControllerDelegate,
   UIActionSheetDelegate,
   picRemDelegate,
   UITextViewDelegate,
   DNImagePickerControllerDelegate,
   MWPhotoBrowserDelegate
  >
{
   NSInteger RePicTag;
}

@property (nonatomic,strong) UIView      *bLine;  /**< 分割线 */
@property (nonatomic,strong) UIImageView *iconIV; /**< 图标 */
@property (nonatomic,strong) UILabel     *leftLbl;/**< 左侧标题Lbl */

@property (nonatomic,strong) NSMutableArray *imgArr;
@property (nonatomic,strong) UIScrollView *picSV;

@property (nonatomic,strong) PictureExaminationView *picView;

@property (nonatomic,assign) NSInteger row;

@end

@implementation STDietRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _row = [reuseIdentifier integerValue];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _bLine   = [UIView new];
        _iconIV  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@[@"饮食-描述",@"饮食-照片",@"用药-时间",@"饮食-时间点",@"饮食-使用时间"][[reuseIdentifier integerValue]]]];
        _leftLbl = [UILabel new];
        
        [self.contentView addSubview:_bLine];
        [self.contentView addSubview:_iconIV];
        [self.contentView addSubview:_leftLbl];
        
        _iconIV.contentMode    = UIViewContentModeScaleAspectFit;
        _bLine.backgroundColor = TCOL_BGGRAY;
        _leftLbl.text          = @[@"食物描述",@"食物照片",@"用餐时间",@"用餐点",@"时长"][[reuseIdentifier integerValue]];
        _leftLbl.font          = GL_FONT(15);
        _leftLbl.textColor     = RGB(0, 0, 0);
        
        WS(ws);
        
        [_bLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView);
            make.centerX.equalTo(ws.contentView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 8));
        }];
        
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bLine.mas_bottom).offset(12);
            make.left.equalTo(ws.contentView).offset(12);
        }];
        
        [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconIV.mas_right).offset(10);
            make.top.equalTo(_bLine.mas_bottom).offset(13);
        }];
        
        switch ([reuseIdentifier integerValue]) {
            case 0:
            {
                _tv = [UITextView new];
                [self.contentView addSubview:_tv];
                
                _tv.backgroundColor   = RGB(245, 245, 245);
                _tv.returnKeyType     = UIReturnKeyDone;
                _tv.delegate          = self;
                _tv.font              = GL_FONT(15);
                _tv.scrollEnabled     = NO;
                _tv.cornerRadius      = 5;
                _tv.textColor         = RGB(19, 19, 19);
                
                [_tv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(ws.contentView);
                    make.top.equalTo(ws.contentView).offset(46);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 15, 57));
                    make.bottom.equalTo(ws.contentView.mas_bottom).offset(-9);
                }];
            }
                break;
            case 1:
            {
                _imgArr          = [NSMutableArray new];
                _savePicArr      = [NSMutableArray new];

                UIButton *addBtn = [UIButton new];
                _picSV           = [UIScrollView new];
                
                [_picSV addSubview:addBtn];
                [self.contentView addSubview:_picSV];
                
                [addBtn setBackgroundImage:[UIImage imageNamed:@"选择照片"] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(addFoodPicClick:) forControlEvents:UIControlEventTouchUpInside];
                addBtn.tag    = 1000;
                if (_isNotEdit) {
                    addBtn.hidden = YES;
                }

                _picSV.tag                            = 1001;
                _picSV.showsHorizontalScrollIndicator = NO;
                
                [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_picSV).offset(12);
                    make.centerY.equalTo(_picSV);
                    make.size.mas_equalTo(CGSizeMake(66, 66));
                }];
                
                [_picSV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_leftLbl.mas_bottom).offset(0);
                    make.centerX.equalTo(ws.contentView);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 66 + 10.9 + 10));
                }];
            }
                break;
            default:
            {
                _rightLbl = [UILabel new];
                [self.contentView addSubview:_rightLbl];
                
                _rightLbl.textAlignment = NSTextAlignmentRight;
                _rightLbl.font          = GL_FONT(15);
                _rightLbl.textColor     = RGB(93, 93, 93);
                _rightLbl.text          = @"";
                
                [_rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(ws.contentView.mas_right).offset(-12);
                    make.centerY.equalTo(_leftLbl);
                    make.width.mas_equalTo(SCREEN_WIDTH - 122);
                }];
            }
                break;
        }
    }
    return self;
}

#pragma mark - 添加照片相关
- (void)addFoodPicClick:(UIButton *)sender
{
    [[[self getFormViewController] view] endEditing:YES];
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    [action showInView:self];
}

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
        
        [[self getFormViewController] presentViewController:picker animated:YES completion:nil];
    } else if(buttonIndex ==1){
        //多选相册
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        imagePicker.imagePickerDelegate      = self;
        imagePicker.filterType               = DNImagePickerFilterTypePhotos;
        imagePicker.imageFlowMaxSeletedNumber= 5 - _savePicArr.count;
        [[self getFormViewController] presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    [[self getFormViewController] dismissViewControllerAnimated:YES completion:nil];
    

    [imageAssets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DNAsset *dnasset = obj;
        NSURL *url = dnasset.url;
        ALAssetsLibrary *alasset = [[ALAssetsLibrary alloc] init];
        [alasset assetForURL:url resultBlock:^(ALAsset *asset) {
            if (asset) {
                ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                Byte* buffer = (Byte*)malloc([assetRepresentation size]);
                NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:[assetRepresentation size] error:nil];
                NSData* fileData = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                UIImage *img = [UIImage imageWithData:fileData];
                NSData *imageData = UIImageJPEGRepresentation(img, 0.1f);
                NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                
                
                [ _imgArr addObject:imageData];
                [_savePicArr addObject:encodedImageStr];
                [_delegate addObj:_savePicArr WithKey:@"DIETPIC"];
                if (idx == imageAssets.count - 1) {
                    [self upDateFoodImgViewWithState:ADDPIC];
                }
                
            }
        } failureBlock:NULL];
        
//        NSData *imageData = [NSData new];
//        
//        imageData = UIImageJPEGRepresentation([obj objectForKey:UIImagePickerControllerOriginalImage], (CGFloat)0.1);
        
    }];
    
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//ELCImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *data =  [info objectForKey:UIImagePickerControllerEditedImage] ;
        
        NSData *imageData = [NSData new];
        
        imageData = UIImageJPEGRepresentation(data, 0.1f);
        
        [_imgArr addObject:imageData];
        
        NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [_savePicArr addObject:encodedImageStr];
        [_delegate addObj:_savePicArr WithKey:@"DIETPIC"];

        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
        [self upDateFoodImgViewWithState:ADDPIC];
}

- (void)upDateFoodImgViewWithState:(UPDATAPIC_STATE)STATE
{
    [_imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[self viewWithTag:50 + idx] removeFromSuperview];
    }];
    
    if (STATE == REPIC) {
        [_imgArr removeObjectAtIndex:RePicTag % 10];
        if (_savePicArr.count) {
            [_savePicArr removeObjectAtIndex:RePicTag % 10];
            [_delegate addObj:_savePicArr WithKey:@"DIETPIC"];
        }
    }

    UIButton *btn = (UIButton *)[self viewWithTag:1000];

    __block  NSInteger  imgTag = 50;
    

    if (_isNotEdit) {
        btn.hidden = YES;
    } else {
        if (_imgArr.count == 5) {
            btn.hidden = YES;
        } else {
            btn.hidden = NO;
        }
    }
    
    if (!_imgArr.count) {
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_picSV);
            make.left.equalTo(_picSV).offset(12);
            make.size.mas_equalTo(CGSizeMake(66, 66));
        }];
    }
    
    [_imgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [UIButton new];
        
        [_picSV addSubview:button];
        
        button.tag           = imgTag++;
        button.cornerRadius  = 5;
        button.masksToBounds = true;
        [button addTarget:self action:@selector(readPic:) forControlEvents:UIControlEventTouchUpInside];
        if ([obj isKindOfClass:[NSData class]]) {
            [button setBackgroundImage:[UIImage imageWithData:obj] forState:UIControlStateNormal];
        } else {
          NSData *data = [[NSData alloc]
             initWithBase64EncodedString:obj options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [button setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }
        
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_picSV);
                make.left.equalTo(_picSV).offset(12 + (66 + 12) * idx);
                make.size.mas_equalTo(CGSizeMake(66, 66));
            }];
            
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(button);
                make.left.equalTo(button.mas_right).offset(12);
                make.size.mas_equalTo(CGSizeMake(66, 66));
            }];
    }];
    
    
    if (_imgArr.count < 5) {
        [_picSV setContentSize:CGSizeMake((_imgArr.count + 1) * (66 + 12) + 12, 0)];
    } else {
        [_picSV setContentSize:CGSizeMake(_imgArr.count * (66 + 12) + 12, 0)];
    }
}

//看照片
- (void)readPic:(UIButton *)sender
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    //右按钮改为删除按钮
    browser.displayActionRemButton  = !_isNotEdit;
    // Set options
    browser.displayActionButton     = false;// Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows        = NO;// Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO;// Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill        = YES;// Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls      = NO;// Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid              = YES;// Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid             = NO;// Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:sender.tag % 10];
    
    // Present
    [[[self getFormViewController] navigationController] pushViewController:browser animated:true];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
//    [[[self getFormViewController] view] endEditing:YES];
//    _picView = [[PictureExaminationView alloc]initWithPics:_imgArr Withindex:sender.tag];
//    _picView.delegate = self;
//    if (_isNotEdit) {
//        _picView.yBtn.hidden = YES;
//    }
//    UIWindow *keyv    = [[UIApplication sharedApplication] keyWindow];
//    [keyv addSubview: _picView];
//    
//    _picView.frame = CGRectMake(0,SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [UIView animateWithDuration:0.3 animations:^{
//    _picView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//    }];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imgArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < _imgArr.count) {
        id obj = _imgArr[index];
        if ([obj isKindOfClass:[NSData class]]) {
           return [MWPhoto photoWithImage:[UIImage imageWithData:obj]];
        } else if([obj isKindOfClass:[UIImage class]]){
            return [MWPhoto photoWithImage:obj];
        } else {
            NSData *decodedImageData = [[NSData alloc]
                                        initWithBase64EncodedString:obj
                                        options:NSDataBase64DecodingIgnoreUnknownCharacters];
          return [MWPhoto photoWithImage:[UIImage imageWithData:decodedImageData]];
        }
    }
    return nil;
}

//删除照片回调
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
    RePicTag = index + 50;

    [self upDateFoodImgViewWithState:REPIC];    
    
    GL_ALERT_AFTER(@"已删除图片", 1.0f);
}


//删除照片回调
- (void)picRemWithTag:(NSInteger)remPicTag
{
    GL_ALERT_AFTER(@"删除成功", 1.5f);
    
    RePicTag = remPicTag;
    
    [self upDateFoodImgViewWithState:REPIC];
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([_delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]){
        [_delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    CGFloat tvHeight = [textView getChangeHeight];
    CGFloat tvHeight = [textView sizeThatFits:CGSizeMake(SCREEN_WIDTH - 15,CGFLOAT_MAX)].height;

    if (tvHeight > 57) {
        if (textView.height != tvHeight) {
            [_delegate reloadTextViewForCellWithHeight:tvHeight - 57];
        }
        
    } else if(tvHeight <= 57){
        [_delegate reloadTextViewForCellWithHeight:0];
        tvHeight = 57;
    }
    
    UITableView *tableView = [self tableView];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
    if ([_delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [_delegate textViewDidChange:textView];
    }
    
    textView.height = tvHeight;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([_delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [_delegate textViewDidEndEditing:textView];
    }
}

- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = value;
    CGSize deSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return deSize.height;
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView){
            tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)setEntity:(DiningRecordEntity *)entity
{
    _entity = entity;
    switch (_row) {
        case 0:
            _tv.text = entity.DIETSITUATION;
            [self textViewDidChange:_tv];
            break;
        case 1:
            [_imgArr addObjectsFromArray:entity.DIETPIC];
            [_savePicArr addObjectsFromArray:entity.DIETPIC];
            [self upDateFoodImgViewWithState:ADDPIC];
            break;
        case 2:
        {
            _rightLbl.text = [[entity.DIETTIME toDate:@"yyyy-MM-dd HH:mm:ss"] toString:@"aakk:mm yyyy-MM-dd"];
        }
            break;
        case 3:
            _rightLbl.text = entity.DIETTYPE;
            break;
        case 4:
            _rightLbl.text = entity.DURATIONTIME;
            break;
        default:
            break;
    }
}

@end
