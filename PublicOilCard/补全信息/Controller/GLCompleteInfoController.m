//
//  GLCompleteInfoController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLCompleteInfoController.h"
#import "GLLoginController.h"
#import "BaseNavigationViewController.h"
#import "LBMineCenterChooseAreaViewController.h"
#import "editorMaskPresentationController.h"
#import "BasetabbarViewController.h"
#import "GLMineHomeController.h"

@interface GLCompleteInfoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIAlertViewDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//@property (weak, nonatomic) IBOutlet UITextField *IDTF;
//@property (weak, nonatomic) IBOutlet UITextField *oilCardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *indentifierTF;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;

@property (strong, nonatomic)NSString *status;//判断登录是否过期
@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *dataArr;
//保存省市区
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@end

@implementation GLCompleteInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"补全信息";
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
//省市区选择
- (IBAction)adressChoose:(id)sender {
    
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
- (void)refresh {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue]==1) {
            [UserModel defaultUser].price = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"price"]];
            [UserModel defaultUser].mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mark"]];
            [UserModel defaultUser].recNumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"recNumber"]];
            [UserModel defaultUser].yue = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"yue"]];
            [UserModel defaultUser].username = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"username"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].group_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"group_name"]];
            [UserModel defaultUser].isHaveOilCard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isHaveOilCard"]];
            [UserModel defaultUser].qtIdNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"qtIdNum"]];
            [UserModel defaultUser].jyzSelfCardNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"jyzSelfCardNum"]];
            [UserModel defaultUser].isBqInfo = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"isBqInfo"]];
            [UserModel defaultUser].banknumber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"banknumber"]];
            [UserModel defaultUser].openbank = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"openbank"]];
            [UserModel defaultUser].address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"address"]];
            [UserModel defaultUser].IDCard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"IDCard"]];
            
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].price] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].price = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].mark] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].mark = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].recNumber] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].recNumber = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].username] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].username = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].truename] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].truename = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].group_name] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].group_name = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].isHaveOilCard] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].isHaveOilCard = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].qtIdNum] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].qtIdNum = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].jyzSelfCardNum] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].jyzSelfCardNum = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].isBqInfo] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].isBqInfo = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].banknumber] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].banknumber = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].openbank] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].openbank = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].address] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].address = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].IDCard] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].IDCard = @"";
            }
            
            [usermodelachivar achive];
            
            if ([[UserModel defaultUser].group_id integerValue] == 1 ||[[UserModel defaultUser].group_id integerValue] == 2 ||[[UserModel defaultUser].group_id integerValue] == 3 ) {
                
                GLMineHomeController *homevc = [[GLMineHomeController alloc] init];
                BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:homevc];
                nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:nav animated:YES completion:nil];
                
            }else{
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }

            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    }enError:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
    }];
}

//退出
- (IBAction)exit:(id)sender {
    
    if ([self.status isEqualToString:@"1"]) {
        
        GLLoginController *loginVC = [[GLLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
    
//        [self dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag == 10) {
            
            [UserModel defaultUser].loginstatus = NO;
            [UserModel defaultUser].pic = @"";
            [UserModel defaultUser].group_id = @"0";
            [usermodelachivar achive];
//            [self dismissViewControllerAnimated:YES completion:nil];
            BasetabbarViewController *baseVc = [[BasetabbarViewController alloc] init];
            [self presentViewController:baseVc animated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BasetabbarViewController alloc] init];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
        }
    }
}
//提交
- (IBAction)submit:(id)sender {
    if(self.nameTF.text.length <= 0){
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }else if(![predicateModel IsChinese:self.nameTF.text]){
        [MBProgressHUD showError:@"真实姓名只能为汉字"];
        return;
    }

    if(self.indentifierTF.text.length <= 0){
        [MBProgressHUD showError:@"请输入证件号"];
        return;
    }else if(self.indentifierTF.text.length < 6 ){
        [MBProgressHUD showError:@"请输入正确的证件号码"];
        return;
    }
    if(self.bankCardNumTF.text.length <= 0){
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }else if (![predicateModel IsBankCard:self.bankCardNumTF.text]){
        [MBProgressHUD showError:@"输入的银行卡号不正确"];
        return;
    }
    if(self.bankNameTF.text.length <= 0){
        [MBProgressHUD showError:@"请输入银行名称"];
        return;
    }else if(![predicateModel IsChinese:self.bankNameTF.text]){
        [MBProgressHUD showError:@"银行名只能为中文"];
        return;
    }
    if([self.addressLabel.text isEqualToString:@"请选择省市区"]){
        [MBProgressHUD showError:@"请选择省市区"];
        return;
    }
    if(self.detailTF.text.length == 0){
        [MBProgressHUD showError:@"请填写详细地址"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"truename"] = self.nameTF.text;
    dict[@"province"] = self.provinceStrId;
    dict[@"city"] = self.cityStrId;
    dict[@"area"] = self.countryStrId;
    
    dict[@"IDCard"] = self.indentifierTF.text;
    dict[@"bankNum"] = self.bankCardNumTF.text;
    dict[@"openbank"] = self.bankNameTF.text;
    dict[@"address"] = self.detailTF.text;

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];

    [NetworkManager requestPOSTWithURLStr:kINFO_BQ paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 0) {
            self.status = @"1";
            [self.exitBtn setTitle:@"重新登录" forState:UIControlStateNormal];
        }
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
            [self refresh];

        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

#pragma mark UITextfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.indentifierTF) {//身份证号只能输入数字和X
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest){
            [MBProgressHUD showError:@"证件号输入不合法"];
            return NO;
        }

    }
    return YES;
    
}

#pragma 动画要用到的招商总管
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
    
    [self chooseAddress:transitionContext];

}
//选择省市区
-(void)chooseAddress:(id <UIViewControllerContextTransitioning>)transitionContext{
    
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
#pragma 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
