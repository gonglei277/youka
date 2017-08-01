//
//  GLRegisterController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/6.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLRegisterController.h"
#import "LBViewProtocolViewController.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"

@interface GLRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *recomendId;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *secretTf;
@property (weak, nonatomic) IBOutlet UITextField *sureSecretTf;
@property (weak, nonatomic) IBOutlet UITextField *verificationTf;
@property (weak, nonatomic) IBOutlet UIButton *getcodeBt;
@property (weak, nonatomic) IBOutlet UIButton *registerBt;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UIButton *isAgreeBtn;

@property (assign, nonatomic)BOOL isAgreel;//是否同意注册协议 默认为NO

@end

@implementation GLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"注册";
    self.isAgreel = NO;
    
    self.registerBt.userInteractionEnabled = NO;
    
}
//获取验证码
- (IBAction)getcode:(UIButton *)sender {
    
    if (self.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:kGET_CODE_URL paramDic:@{@"phone":self.phoneTf.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}
- (IBAction)scaning:(id)sender {
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    
    style.alpa_notRecoginitonArea = 0.6;
    
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    
    
    style.animationImage = imgFullNet;
    
    
    [self openScanVCWithStyle:style];
}
- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.retureCode = ^(NSString *codeStr){
        
        self.recomendId.text = codeStr;
        
    };
    //vc.isOpenInterestRect = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//注册按钮事件
- (IBAction)regsiterEventBt:(UIButton *)sender {
    
    if (self.recomendId.text.length <= 0) {
        [MBProgressHUD showError:@"推荐人ID不能为空"];
        return;
    }


    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCheckID paramDic:@{@"user_name":self.recomendId.text} finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"]] rangeOfString:@"null"].location != NSNotFound ) {
                [MBProgressHUD showError:@"查无此人"];
                return ;
                
            }else{
                
                //查到推荐人,开始注册
                [self registerRequest:responseObject[@"data"]];
            }

        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
  
}

//注册请求
- (void)registerRequest:(NSString *)name {
    if (self.phoneTf.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTf.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    if (self.secretTf.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.secretTf.text.length < 6 || self.secretTf.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.secretTf.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    
    if (self.sureSecretTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (![self.secretTf.text isEqualToString:self.sureSecretTf.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    if (self.verificationTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (_isAgreel == NO) {
        [MBProgressHUD showError:@"勾选注册协议"];
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"推荐人:%@",name];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认推荐人" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"userphone"] = self.phoneTf.text;
        dict[@"password"] = [RSAEncryptor encryptString:self.secretTf.text publicKey:public_RSA];
        dict[@"user_name"] = self.recomendId.text;
        dict[@"yzm"] = self.verificationTf.text;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kREGISTER_URL paramDic:dict finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue]==1) {
                [MBProgressHUD showError:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
        } enError:^(NSError *error) {
            
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
            
        }];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 *是否同意注册协议
 */
- (IBAction)isAgreeRegist:(id)sender {
    self.isAgreel = !self.isAgreel;
    
    if (self.isAgreel) {
        self.registerBt.userInteractionEnabled = YES;
        self.registerBt.backgroundColor = TABBARTITLE_COLOR;
        [self.isAgreeBtn setImage:[UIImage imageNamed:@"注册协议选中"] forState:UIControlStateNormal];
    }else{
        self.registerBt.userInteractionEnabled = NO;
        self.registerBt.backgroundColor = [UIColor lightGrayColor];
        [self.isAgreeBtn setImage:[UIImage imageNamed:@"注册协议未选中"] forState:UIControlStateNormal];
    }
}

/**
 *查看注册协议
 */
- (IBAction)seeRegistinfo:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.navTitle = @"注册协议";
    vc.webUrl = REGISTER_URL;
    [self.navigationController pushViewController:vc animated:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.recomendId && [string isEqualToString:@"\n"]) {
        [self.phoneTf becomeFirstResponder];
        return NO;
        
    }else if (textField == self.phoneTf && [string isEqualToString:@"\n"]){
        
         [self.secretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.secretTf && [string isEqualToString:@"\n"]){
        
        [self.sureSecretTf becomeFirstResponder];
        return NO;
    }else if (textField == self.sureSecretTf && [string isEqualToString:@"\n"]){
        
        [self.verificationTf becomeFirstResponder];
        return NO;
    }else if (textField == self.verificationTf && [string isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.recomendId || textField == self.phoneTf ||self.sureSecretTf || self.secretTf||self.verificationTf) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff)
                
                return NO;
        }
    }
    
    return YES;
    
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
                [self.getcodeBt setTitle:@"重发验证码" forState:UIControlStateNormal];
                self.getcodeBt.userInteractionEnabled = YES;
                self.getcodeBt.backgroundColor = YYSRGBColor(44, 153, 46, 1);
                 self.getcodeBt.titleLabel.font = [UIFont systemFontOfSize:13];
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getcodeBt setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getcodeBt.userInteractionEnabled = NO;
                self.getcodeBt.backgroundColor = TABBARTITLE_COLOR;
                self.getcodeBt.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}

-(void)updateViewConstraints{
    
    [super updateViewConstraints];
    
    
    self.registerBt.layer.cornerRadius = 4;
    self.registerBt.clipsToBounds = YES;
    
    self.getcodeBt.layer.cornerRadius = 4;
    self.getcodeBt.clipsToBounds = YES;
    
    
}


@end
