//
//  GLMine_SpendingController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SpendingController.h"
#import "GLMine_SpendingRecordCountController.h"

@interface GLMine_SpendingController ()

@property (strong, nonatomic)GLMine_SpendingRecordCountController *fristVc;
@property (strong, nonatomic)GLMine_SpendingRecordCountController *secondVc;
@property (strong, nonatomic)UIViewController *currentVC;
@property (nonatomic, strong)UISegmentedControl *seg ;

@property (assign, nonatomic)BOOL firstBool;
@property (assign, nonatomic)BOOL secondBool;@end

@implementation GLMine_SpendingController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.seg = [[UISegmentedControl alloc] initWithItems:@[@"中石油",@"中石化"]];
    self.seg.frame = CGRectMake(0, 0, 100, 30);
    [self.seg addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.seg;
    
    self.fristVc = [[GLMine_SpendingRecordCountController alloc] init];
    self.fristVc.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);

    [self addChildViewController:self.fristVc];
    
    self.secondVc = [[GLMine_SpendingRecordCountController alloc] init];
    self.secondVc.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self addChildViewController:self.secondVc];
    
    //设置默认控制器为fristVc
    self.currentVC = self.fristVc;
    [self.view addSubview:self.fristVc.view];
    
    self.firstBool = NO;
    self.secondBool =NO;
    
    self.seg.selectedSegmentIndex = 0;
    
    [self doSomethingInSegment:self.seg];

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    
}
- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{
    /**
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController    当前显示在父视图控制器中的子视图控制器
     *  toViewController        将要显示的姿势图控制器
     *  duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options              动画效果(渐变,从下往上等等,具体查看API)UIViewAnimationOptionTransitionCrossDissolve
     *  animations            转换过程中得动画
     *  completion            转换完成
     */
    if (self.currentVC == newVc) {
        return;
    }
    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
    }];
}

-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    switch (Seg.selectedSegmentIndex) {
        case 0:
//            self.chooseBt.selected = self.firstBool;
            [self replaceFromOldViewController:self.secondVc toNewViewController:self.fristVc];
            break;
        case 1:
//            self.chooseBt.selected = self.secondBool;
            [self replaceFromOldViewController:self.fristVc toNewViewController:self.secondVc];
            break;
        default:
            break;
    }
}
@end
