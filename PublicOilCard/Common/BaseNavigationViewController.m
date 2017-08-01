//
//  BaseNavigationViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = TABBARTITLE_COLOR;
    self.navigationBar.tintColor=[UIColor whiteColor];
//    self.navigationBarHidden = YES;
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];

//    self.navigationBar.translucent = YES;
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//
//    gradientLayer.colors = @[(__bridge id)YYSRGBColor(255, 80, 0, 1).CGColor,(__bridge id)YYSRGBColor(246, 109, 2, 1).CGColor];
//    gradientLayer.locations = @[@0.5, @1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = CGRectMake(0, -20, self.view.frame.size.width, 64);
//    [self.navigationBar.layer addSublayer:gradientLayer];
    //    //设置渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)YYSRGBColor(255, 80, 0, 1).CGColor,(__bridge id)YYSRGBColor(246, 109, 2, 1).CGColor];
    //    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.type = kCAGradientLayerAxial;
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 64)];
    [backgroundView.layer addSublayer:gradientLayer];
    
    [self.navigationBar insertSubview:backgroundView belowSubview:self.navigationItem.titleView];
}

//+(void)initialize
//{
//    UINavigationBar *naBar = [UINavigationBar appearance];
//    naBar.tintColor = YYSRGBColor(230, 38, 7);
//    naBar.backgroundColor = YYSRGBColor(230, 38, 7);
//    naBar.translucent = NO;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[NSForegroundColorAttributeName] = YYSRGBColor(230, 38, 7);
//    [naBar setTitleTextAttributes:dict];
//}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated

{
    // viewController.hidesBottomBarWhenPushed = YES; //隐藏底部标签栏
    
    [super pushViewController:viewController animated:animated];
    
    
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
//    self.visibleViewController.navigationItem.backBarButtonItem = backButtonItem;
    
    [self.visibleViewController.navigationItem setHidesBackButton:YES];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"iv_back"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, -5, 5, 25)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.visibleViewController.navigationItem.leftBarButtonItem = ba;
    
}

-(UIBarButtonItem*) createBackButton

{
    
    return [[UIBarButtonItem alloc]
            
            initWithTitle:@"返回"
            
            style:UIBarButtonItemStylePlain
            
            target:self 
            
            action:@selector(popself)];
    
}

-(void)popself

{
    
    [self popViewControllerAnimated:YES];
    
}

@end
