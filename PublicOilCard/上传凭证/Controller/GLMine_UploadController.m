//
//  GLMine_UploadController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_UploadController.h"
#import "GLMine_UploadRecordController.h"
#import "HZQDatePickerView.h"
#import "GL_CardTypeChooseView.h"


@interface GLMine_UploadController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HZQDatePickerViewDelegate,UIGestureRecognizerDelegate>
{
    LoadWaitView *_loadV;
        bool isHaveDian;
    HZQDatePickerView *_pikerView;
}

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *oilCardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (nonatomic, strong) UIView *maskV;
@property (nonatomic, strong) GL_CardTypeChooseView *contentView;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)UIImage *picImage;

@end

@implementation GLMine_UploadController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 680;
    self.navigationItem.title = @"上传凭证";
    self.submitBtn.layer.cornerRadius = 5.f;
    self.oilCardNumLabel.text = [UserModel defaultUser].jyzSelfCardNum;
//    self.userNameLabel.text = [UserModel defaultUser].username;
    self.noticeLabel.text = @" 1. 会员到全国中石油及中石化加油网点加油消费后，会员应打印当次真实消费凭据，拍摄相片上传至本系统，并在输入消费金额填写栏，填写消费金额.\n 2. 会员输入的金额应与当次真实消费凭据金额相同，会员不能虚填或错填，此数据是作为真实消费凭据及奖励核对.\n 3. 如会员输入该金额与真实消费金额不符或恶意错填等，因此造成该消费相应奖励不及时或取消，则由会员自行负责";
    self.type = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

//选择油卡类型
- (IBAction)changeCardType:(id)sender {
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.cardView convertRect:self.cardView.bounds toView:window];
    
    [self.navigationController.view addSubview:self.maskV];
    [self.maskV addSubview:self.contentView];
    self.contentView.frame = CGRectMake(30,CGRectGetMaxY(rect), SCREEN_WIDTH- 60, 0);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.height = 100;
    }];
    
}
#pragma mark 选择时间
- (IBAction)chooseDate:(id)sender {
    
    [self setupDateView:DateTypeOfEnd];
    
}
- (void)setupDateView:(DateType)type {
    
    _pikerView = [HZQDatePickerView instanceDatePickerView];
    _pikerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 20);
    [_pikerView setBackgroundColor:[UIColor clearColor]];
    _pikerView.delegate = self;
    _pikerView.type = type;
    [_pikerView.datePickerView setMaximumDate:[NSDate date]];
    [self.view addSubview:_pikerView];
    
}
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    self.dateLabel.text = date;
    
}
#pragma mark 上传图片
- (IBAction)choosePicture:(id)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"用相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getcamera];//获取照相机
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getpicture];//获取相册
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:cameraAction];
    [alertVC addAction:albumAction];
    [alertVC addAction:cancelAction];
    
    //当在ipad里弹出时.需要用到该代码
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
    popover.sourceView = self.imageV;
    
    popover.sourceRect = self.imageV.bounds;
    [self presentViewController:alertVC animated:YES completion:nil];

}
#pragma mark - UITextField delegate
//textField.text 输入之前的值 string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [MBProgressHUD showError:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [MBProgressHUD showError:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [MBProgressHUD showError:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [MBProgressHUD showError:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [MBProgressHUD showError:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark 调相机 相册
-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
//         先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 1);
        }else {
            data=    UIImageJPEGRepresentation(image, 1);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        self.picImage = [UIImage imageWithData:data];
        
        self.imageV.image = self.picImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 提交
- (IBAction)submit:(id)sender {
    
    self.submitBtn.enabled = NO;
    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
    
    if([UserModel defaultUser].jyzSelfCardNum.length == 0 && [[UserModel defaultUser].hua_status integerValue] == 0){
        [MBProgressHUD showError:@"你还未绑定油卡"];
        return;
    }
    if (self.oilCardNumLabel.text.length == 0) {
        [MBProgressHUD showError:@"请选择油卡类型"];
        return;
    }
    if(self.moneyTextF.text.length == 0){
        [MBProgressHUD showError:@"请输入金额"];
        return;
    }else if([self.moneyTextF.text floatValue] <= 0){
        [MBProgressHUD showError:@"金额必须大于0"];
        return;
    }
    if (self.dateLabel.text == nil) {
        [MBProgressHUD showError:@"请选择消费时间"];
        return;
    }
    if(self.picImage == nil){
        [MBProgressHUD showError:@"请上传图片"];
        return;
    }
//    NSDate * senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSDate * now = [dateformatter dateFromString:self.dateLabel.text];
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
  
    //拿到图片准备上传
    NSDictionary *dic;
    dic=@{@"token":[UserModel defaultUser].token ,
          @"uid":[UserModel defaultUser].uid ,
          @"buytime":timeSp,
          @"qt_id":[UserModel defaultUser].qtIdNum ,
          @"order_money":self.moneyTextF.text,
          @"user_name":[UserModel defaultUser].username,
          @"type":[NSString stringWithFormat:@"%zd",self.type]};
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 10;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kSHOPINFO_UPLOAD_URL] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        if (self.picImage) {
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
            NSData *data = UIImagePNGRepresentation(self.picImage);
            [formData appendPartWithFileData:data name:@"order_pic" fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:^(NSProgress *uploadProgress){
        
        [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//        [SVProgressHUD setCornerRadius:8.0];
        
        if (uploadProgress.fractionCompleted == 1.0) {
            [SVProgressHUD dismiss];
            //                self.submit.userInteractionEnabled = YES;
        }
        
    }success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            self.moneyTextF.text = @"";
            [MBProgressHUD showError:dic[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadSuccessfulNotification" object:nil];
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
        [_loadV removeloadview];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

- (IBAction)record:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_UploadRecordController *recordVC = [[GLMine_UploadRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)changeCard:(UIGestureRecognizer *)tap {
    
    if (tap.view == self.contentView.youLabel) {
        
        if ([UserModel defaultUser].jyzSelfCardNum.length == 0) {
            [MBProgressHUD showError:@"未绑定中石油油卡"];
            [self maskViewTap];
            self.oilCardNumLabel.text = @"";
            return;
        }
        self.type = 1;
        self.oilCardNumLabel.text = [UserModel defaultUser].jyzSelfCardNum;
        [self maskViewTap];
        
    }else{
        
        if ([UserModel defaultUser].hua_card.length == 0) {
            [MBProgressHUD showError:@"未绑定中石化油卡"];
            [self maskViewTap];
            self.oilCardNumLabel.text = @"";
            
            return;
        }
        self.type = 2;
        self.oilCardNumLabel.text = [UserModel defaultUser].hua_card;
        [self maskViewTap];
    }
}
- (void)maskViewTap {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.height = 0;
        
    } completion:^(BOOL finished) {
        [self.contentView removeFromSuperview];

        [self.maskV removeFromSuperview];
    }];
    
}
// 只有点击在mask上才调maskViewTap
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.maskV){
        
        return YES;
        
    }
    
    return NO;
    
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskV.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *maskViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        maskViewTap.delegate = self;
        [_maskV addGestureRecognizer:maskViewTap];
    }
    return _maskV;
}
- (GL_CardTypeChooseView *)contentView{
    if (!_contentView) {
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"GL_CardTypeChooseView" owner:nil options:nil].lastObject;
        
        _contentView.layer.cornerRadius = 5.f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCard:)];
        [_contentView.youLabel addGestureRecognizer:tap];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCard:)];
        [_contentView.huaLabel addGestureRecognizer:tap2];
    }
    return _contentView;
}
@end
