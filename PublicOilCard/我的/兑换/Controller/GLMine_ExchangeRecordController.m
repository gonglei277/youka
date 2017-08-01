//
//  GLMine_ExchangeRecordController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ExchangeRecordController.h"
#import "GLMine_ExchangeRecord_SuccessController.h"
#import "GLMine_ExchangeRecord_FailController.h"
#import "GLMine_ExchangeRecord_UnCheckController.h"
#import "recordeManger.h"
#import "QQPopMenuView.h"
#import "recordeManger.h"

@interface GLMine_ExchangeRecordController ()
@property (strong, nonatomic)UIButton *buttonedt;
@end

@implementation GLMine_ExchangeRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"兑换记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];
    [self selectTagByIndex:0 animated:YES];
    
    self.hidesBottomBarWhenPushed=YES;
    
    _buttonedt=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 60)];
    [_buttonedt setTitle:@"筛选" forState:UIControlStateNormal];
    [_buttonedt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    _buttonedt.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonedt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonedt addTarget:self action:@selector(edtingInfo) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_buttonedt];

}
//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:45])
    {
        
    }
    return self;
}
-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 3, 45);
    
    NSArray *titleArray = @[
                            @"成功",
                            @"未审核",
                            @"失败",
                            ];
    
    NSArray *classNames = @[
                            [GLMine_ExchangeRecord_SuccessController class],
                            [GLMine_ExchangeRecord_UnCheckController class],
                            [GLMine_ExchangeRecord_FailController class],
                            ];
    
    self.normalTitleColor = [UIColor blackColor];
    self.selectedTitleColor = TABBARTITLE_COLOR;
    self.selectedIndicatorColor = TABBARTITLE_COLOR;
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

//筛选
-(void)edtingInfo{
    
    NSArray *arr;
    
    if([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3 ){
        arr = @[@{@"title":@"兑换余额",@"imageName":@""},@{@"title":@"即时积分",@"imageName":@""}];
    }else{
        arr = @[@{@"title":@"兑换余额",@"imageName":@""},@{@"title":@"即时积分",@"imageName":@""},@{@"title":@"普通积分",@"imageName":@""}];
    }
    
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:arr width:100 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5)action:^(NSInteger index) {
        
        [recordeManger defaultUser].recordeType = [NSString stringWithFormat:@"%zd",index];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"filterExtensionCategories" object:nil userInfo:nil];
        
    }];
    
    popview.isHideImage = YES;
    
    [popview show];
    
    
}
@end
