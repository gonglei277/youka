//
//  GLPay_OfflineController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_OfflineController.h"

@interface GLPay_OfflineController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    LoadWaitView *_loadV;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UITextField *yzmTextF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (strong, nonatomic)UIImage *picImage;//头像

@end

@implementation GLPay_OfflineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线下支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 640;
    [self random:@""];
    
    if (self.pushIndex == 1) {
        
        self.accountLabel.text = [UserModel defaultUser].congig_card;
        self.goodsNameLabel.text = self.goods_name;
        self.usernameLabel.text = [UserModel defaultUser].username;
        self.moneyLabel.text = self.realy_price;
        self.sumLabel.text = self.goods_num;
    }else{
        self.accountLabel.text = [UserModel defaultUser].congig_card;
        self.goodsNameLabel.text = @"招商总管身份";
        self.usernameLabel.text = [UserModel defaultUser].username;
        self.sumLabel.text = @"1";
        if(self.upgrade == 1){
            
            self.moneyLabel.text = @"6000";
            
        }else{
            
            self.moneyLabel.text = @"12000";
        }
    }
}

- (IBAction)random:(id)sender {
    
    int num = (arc4random() % 10000);
    NSString *randomNumber = [NSString stringWithFormat:@"%.4d", num];
    self.randomLabel.textColor = [UIColor darkGrayColor];
    self.randomLabel.text = randomNumber;

}

- (IBAction)getCode:(id)sender {

    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:kGET_CODE_URL paramDic:@{@"phone":[UserModel defaultUser].phone} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
                self.getCodeBtn.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = TABBARTITLE_COLOR;
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
- (IBAction)submit:(id)sender {
    
    if(self.picImage == nil){
        [MBProgressHUD showError:@"请上传图片"];
        return;
    }
//    [self submitTheRequest:self.pushIndex];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userphone"] = [UserModel defaultUser].phone;
    dict[@"yzm"] = self.yzmTextF.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kENSURE_CODE_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
           
            [self submitTheRequest:self.pushIndex];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    

}
- (void)submitTheRequest:(NSInteger)pushIndex {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *urlstr = [[NSString alloc]init];
    
    if (pushIndex == 1) {
        
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"goods_id"] = self.goods_id;
        dict[@"num"] = self.goods_num;
        dict[@"code"] = self.randomLabel.text;
        dict[@"l_money"] = self.realy_price;
        urlstr = kPay_OffLine_URL;
        
    }else if(pushIndex == 3){
        
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"money"] = self.moneyLabel.text;
        dict[@"upgrade"] = @(self.upgrade);
        dict[@"code"] = self.randomLabel.text;
        urlstr = kPayDelegate_OffLine_URL;
    }
    
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,urlstr] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (self.picImage) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(self.picImage);
                
                if (pushIndex == 1) {
                    
                    [formData appendPartWithFileData:data name:@"l_pic" fileName:fileName mimeType:@"image/png"];
                }else if(pushIndex == 3){
                    
                    [formData appendPartWithFileData:data name:@"money_pic" fileName:fileName mimeType:@"image/png"];
                }
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
                
                [MBProgressHUD showSuccess:dic[@"message"]];
                
                if (pushIndex == 1) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }else if(pushIndex == 3){
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateManagerNotification" object:nil];
                }
                
            }else{
                [MBProgressHUD showError:dic[@"message"]];
            }
            [_loadV removeloadview];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    
}
//上传图片
- (IBAction)uploadPic:(id)sender {
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
//    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
//    GLMine_PersonInfoCell *cell = [self.scrollView cellForRowAtIndexPath:indexPath];
//    popover.sourceView = cell;
    
//    popover.sourceRect = cell.bounds;
    
//    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    [self presentViewController:alertVC animated:YES completion:nil];
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
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data = UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        self.picImage = [UIImage imageWithData:data];
        self.imageV.image = self.picImage;
        
    }

    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
