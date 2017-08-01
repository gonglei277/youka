//
//  BasetabbarViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BasetabbarViewController.h"
#import "BaseNavigationViewController.h"
#import "GLMallHomeController.h"
#import "GLMineHomeController.h"
#import "GLLoginController.h"
#import "GLCompleteInfoController.h"
#import "GLMine_UploadRecordController.h"

@interface BasetabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation BasetabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=TABBARTITLE_COLOR;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = TABBARTITLE_COLOR;
    self.delegate=self;
    [self addViewControllers];

    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(refreshInterface) name:@"refreshInterface" object:nil];
    
}

- (void)addViewControllers {
    
    //商城
    GLMallHomeController *mallVC = [[GLMallHomeController alloc] init];
    //个人中心
    GLMineHomeController *mineVC = [[GLMineHomeController alloc] init];
    //上传凭证
    GLMine_UploadRecordController *uploadVC = [[GLMine_UploadRecordController alloc] init];
    
    BaseNavigationViewController *mallNav = [[BaseNavigationViewController alloc] initWithRootViewController:mallVC];
    BaseNavigationViewController *mineNav = [[BaseNavigationViewController alloc] initWithRootViewController:mineVC];
    BaseNavigationViewController *uploadNav = [[BaseNavigationViewController alloc] initWithRootViewController:uploadVC];
    
    mallNav.tabBarItem = [self barTitle:@"消费" image:@"首页未选中状态" selectImage:@"首页选中状态"];
    mineNav.tabBarItem = [self barTitle:@"我的" image:@"消费商城未选中状态" selectImage:@"消费商城"];
    uploadNav.tabBarItem = [self barTitle:@"凭证" image:@"凭证未点钟" selectImage:@"凭证点中"];
    
    if ([UserModel defaultUser].loginstatus == YES) {//登录状态
        if ([[UserModel defaultUser].group_id isEqualToString:MANAGER] || [[UserModel defaultUser].group_id isEqualToString:DIRECTOR] || [[UserModel defaultUser].group_id isEqualToString:MINISTER]) {//经理

            self.viewControllers = @[mineNav];

        }else if ([[UserModel defaultUser].group_id isEqualToString:Retailer] || [[UserModel defaultUser].group_id isEqualToString:OrdinaryUser]|| [[UserModel defaultUser].group_id isEqualToString:TWODELEGATE]){//商家
            self.viewControllers = @[mallNav,uploadNav,mineNav];
        }else{
            self.viewControllers = @[mallNav,mineNav];
        }
    }else{//退出状态
        self.viewControllers = @[mallNav,mineNav];
    }

    self.selectedIndex=0;
    
}

- (UITabBarItem *)barTitle:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    UITabBarItem *item = [[UITabBarItem alloc] init];
    
    item.title = title;
    item.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    item.titlePositionAdjustment = UIOffsetMake(0, -4);
    return item;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    int index;
    if ([[UserModel defaultUser].group_id isEqualToString:OrdinaryUser] || [[UserModel defaultUser].group_id isEqualToString:Retailer] ) {
        
        index = 2;
        
    }else if ([[UserModel defaultUser].group_id isEqualToString:MANAGER] || [[UserModel defaultUser].group_id isEqualToString:DIRECTOR]|| [[UserModel defaultUser].group_id isEqualToString:MINISTER]){
        
        index = 0;
        
    }else if ( [UserModel defaultUser].group_id == nil || [[UserModel defaultUser].group_id integerValue] == 0){
        
        index = 1;
        
    }else{
        
        index = 1;
        
    }
    if (viewController == [tabBarController.viewControllers objectAtIndex:index]) {

        if ([UserModel defaultUser].loginstatus == YES) {
            
            if ([[UserModel defaultUser].isBqInfo integerValue] == 0) {
                
                GLCompleteInfoController *infoVC = [[GLCompleteInfoController alloc] init];
                infoVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:infoVC animated:YES completion:nil];
                
                return NO;
            }
            return YES;
        }
        
        GLLoginController *loginVC = [[GLLoginController alloc] init];
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
        return NO;

    }

    return YES;
}
//刷新界面
-(void)refreshInterface{
    
    [self.viewControllers reverseObjectEnumerator];
    
    [self addViewControllers];

}

- (void)pushToHome{
    
     self.selectedIndex = 0;
}

@end
