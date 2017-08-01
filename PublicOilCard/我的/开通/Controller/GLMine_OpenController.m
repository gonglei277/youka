//
//  GLOpenSubordinateController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_OpenController.h"
#import "LBMineCenterChooseAreaViewController.h"
#import "editorMaskPresentationController.h"

@interface GLMine_OpenController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
     BOOL _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *dataArr;

//保存省市区
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@end

@implementation GLMine_OpenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 300;
    
    self.navigationItem.title = @"开通下级";
    self.noticeLabel.text = @" 1.部长：开通总监   总计名额 20个.\n 2.总监：开通经理   总计名额 20个.";
    [self getCityList];
}
- (void)getCityList {
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kGET_CITYLIST_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.dataArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
    
}
//获取验证码
- (IBAction)getCode:(id)sender {
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:kGET_CODE_URL paramDic:@{@"phone":self.phoneTF.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

//选择省市区
- (IBAction)chooseAddress:(id)sender {
    LBMineCenterChooseAreaViewController *vc=[[LBMineCenterChooseAreaViewController alloc]init];
    vc.dataArr = self.dataArr;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.addressLabel.textColor = [UIColor blackColor];
        weakself.addressLabel.text = str;
        weakself.provinceStrId = provinceid;
        weakself.cityStrId = cityd;
        weakself.countryStrId = areaid;
    };
}

//提交
- (IBAction)submit:(id)sender {
    
    if(self.phoneTF.text.length == 0){
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
    }
    if(![self.pwdTF.text isEqualToString:self.ensurePwdTF.text]){
        [MBProgressHUD showError:@"两次密码输入不一致"];
        return;
    }
    if(self.pwdTF.text.length == 0){
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if ([predicateModel checkIsHaveNumAndLetter:self.pwdTF.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 20) {
        [MBProgressHUD showError:@"请输入6-20位密码"];
        return;
    }
    if(self.provinceStrId.length == 0){
        [MBProgressHUD showError:@"请选择省市区"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"phone"] = self.phoneTF.text;
    dict[@"pwd"] = [RSAEncryptor encryptString:self.pwdTF.text publicKey:public_RSA];
    dict[@"province"] = self.provinceStrId;
    dict[@"city"] = self.cityStrId;
    dict[@"area"] = self.countryStrId;
    [NetworkManager requestPOSTWithURLStr:kOPEN_UNDER_URL paramDic:dict finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue]==1) {
            [MBProgressHUD showSuccess:@"开通下级成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
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
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重新发送", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTF && [string isEqualToString:@"\n"]) {
        [self.codeTF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.codeTF && [string isEqualToString:@"\n"]){
        
        [self.pwdTF becomeFirstResponder];
        return NO;
    }else if (textField == self.pwdTF && [string isEqualToString:@"\n"]){
        
        [self.ensurePwdTF becomeFirstResponder];
        return NO;
    }else if (textField == self.ensurePwdTF && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }
    
    if (textField == self.phoneTF || textField == self.codeTF ||self.pwdTF || self.ensurePwdTF) {
        
        for(int i=0; i< [string length];i++){
            
            int a = [string characterAtIndex:i];
            
            if( a >= 0x4e00 && a <= 0x9fff){
                
                [MBProgressHUD showError:@"输入不合法,不能输入中文"];
                return NO;
            }
        }
    }
    
    return YES;
    
}

#pragma mark 动画要用到的招商总管
//动画
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}
//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    [self chooseAddress_gl:transitionContext];
    
}
//选择省市区
-(void)chooseAddress_gl:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
            
        }];
        
    }
    
}

@end
