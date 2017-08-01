//
//  GLMineHomeController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineHomeController.h"
//#import <Masonry/Masonry.h>
#import "GLMine_HeaderView.h"
#import "GLMine_collectionCell.h"
#import "GLMine_CollectController.h"
#import "GLMine_OpenCardController.h"
#import "GLMine_InfoController.h"
#import "GLMine_PersonInfoController.h"
#import "GLMine_OrderController.h"
#import "GLMine_RecommendController.h"
#import "GLMine_updateManagerController.h"
#import "GLMine_SetController.h"
#import "GLMine_ExchangeRecordController.h"
#import "GLMine_OpenController.h"
#import "GLMine_RelationshipController.h"
#import "LBExchangeViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "GLMine_CompleteInfoView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "GLCompleteInfoController.h"
#import "QQPopMenuView.h"
#import "GLHome_jifenRecordController.h"
#import "GLMine_SpendingRecordCountController.h"
#import "GLMine_Order_OffLineController.h"
#import "GLMine_ConsumeController.h"

@interface GLMineHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    GLMine_HeaderView *_header;
    LoadWaitView *_loadV;
}

@property (nonatomic, strong)UICollectionView *collectionV;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageArr;

@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property(assign , nonatomic)CGFloat headerImageHeight;

@property (nonatomic, strong)UIView *maskV;
@property (nonatomic, strong)GLMine_CompleteInfoView *contentV;

@property (nonatomic, strong)NSMutableArray *bannerArrM;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;

@end

static NSString *cellID = @"GLMine_collectionCell";
static NSString *headerID = @"GLMine_HeaderView";
@implementation GLMineHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
 
      [self.view addSubview:self.collectionV];
    self.headerImageHeight = 80 * autoSizeScaleY;
    //注册头视图

    [self.collectionV registerNib:[UINib nibWithNibName:@"GLMine_HeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    [self.collectionV registerNib:[UINib nibWithNibName:@"GLMine_collectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
//    [self completeInfo];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)YYSRGBColor(255, 80, 0, 1).CGColor,(__bridge id)YYSRGBColor(246, 109, 2, 1).CGColor];
//    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.type = kCAGradientLayerAxial;
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.topView.bounds;
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.topView.bounds];
    [backgroundView.layer addSublayer:gradientLayer];
    
    [self.topView insertSubview:backgroundView atIndex:0];

}
//移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
   if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3 ) {
        
       self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }
    [self refresh];
}
- (void)refresh {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;

    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {
  
        if ([responseObject[@"code"] integerValue]==1) {
            [UserModel defaultUser].pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pic"]];
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
            [UserModel defaultUser].IDCard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"IDCard"]];
            [UserModel defaultUser].KfPhone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"KfPhone"]];
            [UserModel defaultUser].s_meber = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"s_meber"]];
            [UserModel defaultUser].hua_card = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"hua_card"]];
            [UserModel defaultUser].hua_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"hua_status"]];
            [UserModel defaultUser].plain_mark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"plain_mark"]];
            [UserModel defaultUser].congig_card = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"congig_card"]];
            
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].pic] rangeOfString:@"null"].location != NSNotFound) {
                [UserModel defaultUser].pic = @"";
             }
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
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].IDCard] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].IDCard = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].KfPhone] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].KfPhone = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].hua_card] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].hua_card = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].hua_status] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].hua_status = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].plain_mark] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].plain_mark = @"";
            }
            if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].congig_card] rangeOfString:@"null"].location != NSNotFound) {
                
                [UserModel defaultUser].congig_card = @"";
            }
            [usermodelachivar achive];
            
            [self.bannerArrM removeAllObjects];
            for (NSDictionary *dic in responseObject[@"data"][@"banner"]) {
                [self.bannerArrM addObject:dic[@"banner_pic"]];
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.collectionV reloadData];
        
    } enError:^(NSError *error) {
  
        [MBProgressHUD showError:error.localizedDescription];
    }];
}
//设置
- (IBAction)set:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_SetController *setVC = [[GLMine_SetController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//消息
- (IBAction)info:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_InfoController *infoVC = [[GLMine_InfoController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//个人信息
- (void)personInfo{
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfoController *perosnInfoVC = [[GLMine_PersonInfoController alloc] init];
    [self.navigationController pushViewController:perosnInfoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//开卡
- (void)openCard {
    
    self.hidesBottomBarWhenPushed = YES;
    
    if ([[UserModel defaultUser].isHaveOilCard integerValue] == 1 && [[UserModel defaultUser].hua_status integerValue] == 1) {
        [MBProgressHUD showError:@"不能重复开卡"];
        return;
    }
    __weak typeof(self) weakself = self;
    
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:@[@{@"title":@"中石油",@"imageName":@""}, @{@"title":@"中石化",@"imageName":@""}] width:100 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 64 + 10 + 30 + 5 ) action:^(NSInteger index) {
        
        if (index == 0) {
            if ([[UserModel defaultUser].isHaveOilCard integerValue] == 1){
                [MBProgressHUD showError:@"已拥有中石油油卡"];
                return ;
            }
        }else{
            if ([[UserModel defaultUser].hua_status integerValue] == 1){
                [MBProgressHUD showError:@"已拥有中石化油卡"];
                return ;
            }
        }
        
        GLMine_OpenCardController *openVC = [[GLMine_OpenCardController alloc] init];
        openVC.type = index;
        [weakself.navigationController pushViewController:openVC animated:YES];
        weakself.hidesBottomBarWhenPushed = NO;
        
    }];
    
    popview.isHideImage = YES;
    
    [popview show];
}
//兑换
- (void)exchange {
    self.hidesBottomBarWhenPushed = YES;

    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:@[@{@"title":@"普通积分",@"imageName":@""}, @{@"title":@"即时积分",@"imageName":@""}] width:110 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 64 + 80) action:^(NSInteger index) {

        LBExchangeViewController *exchangeVC = [[LBExchangeViewController alloc] init];
        exchangeVC.type = 2;
        
        if(index != 1){

            exchangeVC.type = 1;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM"];
            
            NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
            [formatter2 setDateFormat:@"yyyy-MM-dd"];
            
//            NSString *str = @"2017-07-31";
//            NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
//            formatter4.dateFormat = @"yyyy-MM-dd";
//            NSDate *date = [formatter4 dateFromString:str];
    
            NSString *dateTime = [formatter stringFromDate:[NSDate date]];
            NSString *dateTime2 = [formatter2 stringFromDate:[NSDate date]];
            NSString *dateStr = [self getMonthBeginAndEndWith:dateTime];
            
            if (![dateTime2 isEqualToString:dateStr]) {
                [MBProgressHUD showError:@"普通积分只能在月末兑换"];
                return ;
            }
        }
        
        [weakself.navigationController pushViewController:exchangeVC animated:YES];

        weakself.hidesBottomBarWhenPushed = NO;
    }];
    popview.isHideImage = YES;
    
    [popview show];

}

//积分
- (void)jifenBtnClick{
    self.hidesBottomBarWhenPushed = YES;
    
    __weak typeof(self) weakself = self;
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:@[@{@"title":@"普通积分",@"imageName":@""}, @{@"title":@"即时积分",@"imageName":@""}] width:110 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 64 + 120) action:^(NSInteger index) {
        
        GLHome_jifenRecordController *jifenVC = [[GLHome_jifenRecordController alloc] init];
        jifenVC.type = 1;

        if(index != 1){
            
            jifenVC.type = 3;
            
        }
        
        [weakself.navigationController pushViewController:jifenVC animated:YES];
        
        weakself.hidesBottomBarWhenPushed = NO;
    }];
    popview.isHideImage = YES;
    
    [popview show];

}
-(void)jifenRecord {
    
    self.hidesBottomBarWhenPushed = YES;
    
    //    __weak typeof(self) weakself = self;
    //    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:@[@{@"title":@"普通积分",@"imageName":@""}, @{@"title":@"即时积分",@"imageName":@""}] width:110 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 50, 64 + 80) action:^(NSInteger index) {
    //
    //    }];
    //    popview.isHideImage = YES;
    //
    //    [popview show];
    
    GLHome_jifenRecordController *jifenVC = [[GLHome_jifenRecordController alloc] init];
    jifenVC.type = 1;
    [self.navigationController pushViewController:jifenVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)yueRecord {
    
    self.hidesBottomBarWhenPushed = YES;
    GLHome_jifenRecordController *jifenVC = [[GLHome_jifenRecordController alloc] init];
    jifenVC.type = 2;
    [self.navigationController pushViewController:jifenVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
-(void)tuijianRecord {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_SpendingRecordCountController *spendingVC = [[GLMine_SpendingRecordCountController alloc] init];
    
    [self.navigationController pushViewController:spendingVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
-(void)xiaofeiRecord {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_ConsumeController *spendingVC = [[GLMine_ConsumeController alloc] init];
    
    [self.navigationController pushViewController:spendingVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
- (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@",endString];
    return s;
}
#pragma mark 完善信息

- (void)completeInfo {
    
    if ([[UserModel defaultUser].qtIdNum isEqual:[NSNull null]] || [UserModel defaultUser].qtIdNum == nil) {
        [UserModel defaultUser].qtIdNum = @"";
    }
    
    if ([UserModel defaultUser].qtIdNum.length == 0) {
        if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改信息" message:@"请输入要修改的信息" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"请输入全团ID";
                textField.tag = 13;
                textField.delegate = self;
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                
            }];
            
            __weak typeof(self) weakself = self;
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                UITextField *qtIdNumTF = alertController.textFields.firstObject;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [weakself modifyQtIdNum:qtIdNumTF.text];

                });
                
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            
            if ([[UserModel defaultUser].isHaveOilCard integerValue] == 1 || [[UserModel defaultUser].isHaveOilCard integerValue] == 2) {
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskV];
                [self.maskV addSubview:self.contentV];
                self.contentV.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
                [UIView animateWithDuration:0.2 animations:^{
                    self.contentV.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
                }];
            }
        }
    }
}
- (void)modifyQtIdNum:(NSString *)qtIdNum{
    
    if (qtIdNum.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    if (qtIdNum.length != 0) {
        
        dict[@"qtIdNum"] = qtIdNum;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kMODIFY_INFO_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            [self refresh];
            [MBProgressHUD showSuccess:responseObject[@"message"]];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
- (void)maskViewTap {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentV.transform=CGAffineTransformMakeScale(0.1, 0.00001);
        
    } completion:^(BOOL finished) {

        [self.maskV removeFromSuperview];
    }];
}
- (void)addQtIDandOilCardID{
    
    if ( self.contentV.qtIDTextF.text == nil || self.contentV.oilCardTextF.text == nil) {
        [self maskViewTap];
        
    }
    if (self.contentV.qtIDTextF.text.length == 0) {
        [MBProgressHUD showError:@"未输入全团ID"];
        return;
    }

    if (self.contentV.oilCardTextF.text.length == 0) {
        [MBProgressHUD showError:@"未输入油卡卡号"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"jyzSelfCardNum"] = self.contentV.oilCardTextF.text;
    dict[@"qtIdNum"] = self.contentV.qtIDTextF.text;

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kMODIFY_INFO_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            [self refresh];
            [self maskViewTap];
        }
            
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

#pragma mark UICollectionviewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_collectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.picImageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    
    if (indexPath.row == 0 || indexPath.row == 2) {
        
        cell.leftViewWidth.constant = 30;
        cell.rightViewWidth.constant = 8;
    }else{
        cell.leftViewWidth.constant = 8;
        cell.rightViewWidth.constant = 30;
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.topViewHeight.constant = 15;
        cell.bottomViewHeight.constant = 8;
    }else{
        cell.topViewHeight.constant = 8;
        cell.bottomViewHeight.constant = 15;
    }

    cell.cellView.layer.cornerRadius = 5;

    cell.cellView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    cell.cellView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    cell.cellView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    cell.cellView.layer.shadowRadius = 5;//阴影半径，默认3
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
        {
            if([[UserModel defaultUser].group_id integerValue] == 1 ||[[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3){

                if ([[UserModel defaultUser].group_id integerValue] == 3) {
                    [MBProgressHUD showError:@"权限不足,无法开通下级"];
                    return;
                }
                GLMine_OpenController *openVC = [[GLMine_OpenController alloc] init];
                [self.navigationController pushViewController:openVC animated:YES];
                
            }else{
                
                GLMine_CollectController *collectVC = [[GLMine_CollectController alloc] init];
                [self.navigationController pushViewController:collectVC animated:YES];
            }
        }
            break;
        case 1:
        {
            if([[UserModel defaultUser].group_id integerValue] == 1 ||[[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3){
                
                if ([[UserModel defaultUser].group_id integerValue] == 3) {
                    [MBProgressHUD showError:@"权限不足,无法查看关系"];
                    return;
                }
                GLMine_RelationshipController *vc = [[GLMine_RelationshipController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
//                GLMine_OrderController *orderVC = [[GLMine_OrderController alloc] init];
                GLMine_Order_OffLineController *orderVC = [[GLMine_Order_OffLineController alloc] init];
                [self.navigationController pushViewController:orderVC animated:YES];

            }
                }
            break;
        case 2:
        {
            if([[UserModel defaultUser].group_id integerValue] == 1 ||[[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3){
                
                LBExchangeViewController *exchageVC = [[LBExchangeViewController alloc] init];
                [self.navigationController pushViewController:exchageVC animated:YES];
            }else{
                if([[UserModel defaultUser].isHaveOilCard integerValue] == 0 && [[UserModel defaultUser].hua_status integerValue] == 0){
                    [MBProgressHUD showError:@"请先开卡"];
                    return;
                }
                GLMine_updateManagerController *updateVC = [[GLMine_updateManagerController alloc] init];
                [self.navigationController pushViewController:updateVC animated:YES];
                
            }
        }
            break;
        case 3:
        {
            if ([[UserModel defaultUser].isHaveOilCard integerValue] == 0 && [[UserModel defaultUser].hua_status integerValue] == 0 ) {
                [MBProgressHUD showError:@"请先开卡"];
                return;
            }

            GLMine_RecommendController *recommendVC = [[GLMine_RecommendController alloc] init];
            [self.navigationController pushViewController:recommendVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
             viewForSupplementaryElementOfKind:(NSString *)kind
                                   atIndexPath:(NSIndexPath *)indexPath {

    _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
    
    //跳转到个人信息界面
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personInfo)];
    [_header.picImageV addGestureRecognizer:tap];
    
    [_header.openCardBtn addTarget:self action:@selector(openCard) forControlEvents:UIControlEventTouchUpInside];
    [_header.exchangeBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    [_header.jifenBtn addTarget:self action:@selector(jifenBtnClick) forControlEvents:UIControlEventTouchUpInside];

    //数据显示
    [_header.picImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    _header.IDLabel.text = [NSString stringWithFormat:@"ID:%@",[UserModel defaultUser].username];
    _header.nameLabel.text= [NSString stringWithFormat:@"%@:%@",[UserModel defaultUser].group_name,[UserModel defaultUser].truename];
    
    if([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3){
        _header.plain_markLabel.hidden = YES;
    }else{
        _header.plain_markLabel.hidden = NO;
        _header.plain_markLabel.text= [NSString stringWithFormat:@"普通积分:%@",[UserModel defaultUser].plain_mark];
    }
    
    //手势添加
    if([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2|| [[UserModel defaultUser].group_id integerValue] == 3){
        
        UITapGestureRecognizer *jifenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jifenRecord)];
        _header.jifenImageV.hidden = NO;
        [_header.jifenView addGestureRecognizer:jifenTap];
        
    }else{
        
        UITapGestureRecognizer *xiaofeiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiaofeiRecord)];
        _header.xiaofeiImageV.hidden = NO;
        [_header.xiaofeiView addGestureRecognizer:xiaofeiTap];
    }
    
    if([[UserModel defaultUser].group_id integerValue] == 4 || [[UserModel defaultUser].group_id integerValue] == 5){
        
        _header.tuijianImageV.hidden = NO;
        UITapGestureRecognizer *tuijianTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuijianRecord)];
        [_header.tuijianView addGestureRecognizer:tuijianTap];
    }
    
    UITapGestureRecognizer *yueTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yueRecord)];
    [_header.yueView addGestureRecognizer:yueTap];
    

    //消费
    if([[UserModel defaultUser].price floatValue] > 100000){
        _header.xiaofeiLabel.text = [NSString stringWithFormat:@"%.2f万",[[UserModel defaultUser].price floatValue]/10000];
    }else{
        _header.xiaofeiLabel.text = [NSString stringWithFormat:@"%@元",[UserModel defaultUser].price];
    }
    //积分
    if([[UserModel defaultUser].mark floatValue]> 10000000){
        _header.jifenLabel.text = [NSString stringWithFormat:@"%.2f百万",[[UserModel defaultUser].mark floatValue]/1000000];
        
    }else if([[UserModel defaultUser].mark floatValue]> 100000){
        _header.jifenLabel.text = [NSString stringWithFormat:@"%.2f万",[[UserModel defaultUser].mark floatValue]/10000];
    }else{
        _header.jifenLabel.text = [NSString stringWithFormat:@"%@分",[UserModel defaultUser].mark];
    }
    //余额
    if([[UserModel defaultUser].yue floatValue]> 100000){
        _header.jiangliLabel.text = [NSString stringWithFormat:@"%.2f万",[[UserModel defaultUser].yue floatValue]/10000];
    }else{
        _header.jiangliLabel.text = [NSString stringWithFormat:@"%@元",[UserModel defaultUser].yue];
    }
    //推荐
    _header.tuijianLabel.text = [NSString stringWithFormat:@"%@人",[UserModel defaultUser].recNumber];
    
    //判断是否显示vip标志
    if ([[UserModel defaultUser].isHaveOilCard integerValue] == 1 && [[UserModel defaultUser].hua_status integerValue] == 1) {
        _header.vipImageV.hidden = NO;
        [_header.openCardBtn setTitle:@"已开卡" forState:UIControlStateNormal];
        [_header.openCardBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _header.openCardBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }else{
        [_header.openCardBtn setTitle:@"开卡" forState:UIControlStateNormal];
        [_header.openCardBtn setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
        _header.openCardBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
        _header.vipImageV.hidden = YES;
    }
    
    [_header addSubview:self.cycleScrollView];
    
    //区分会员与其他身份的界面
    if ([[UserModel defaultUser].group_id integerValue] == 1|| [[UserModel defaultUser].group_id integerValue] == 2|| [[UserModel defaultUser].group_id integerValue] == 3) {

        _header.openCardBtn.hidden = YES;
        _header.exchangeBtn.hidden = YES;
        _header.jifenBtn.hidden = YES;
        _header.middleViewBottom.constant = 0;
        self.cycleScrollView.frame = CGRectMake(0, 200 * autoSizeScaleY + 25, SCREEN_WIDTH, 0);
        _header.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        _header.openCardBtn.hidden = NO;
        _header.exchangeBtn.hidden = NO;
        _header.jifenBtn.hidden = NO;
        _header.middleViewBottom.constant = _headerImageHeight;
        self.cycleScrollView.frame = CGRectMake(0, 200 * autoSizeScaleY + 25, SCREEN_WIDTH, _headerImageHeight);
        self.cycleScrollView.imageURLStringsGroup = self.bannerArrM;
        _header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
    return _header;
}
// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([[UserModel defaultUser].group_id integerValue] == 1|| [[UserModel defaultUser].group_id integerValue] == 2|| [[UserModel defaultUser].group_id integerValue] == 3) {//非会员
        
        return CGSizeMake(SCREEN_WIDTH, 200 * autoSizeScaleY);
        
    }else{//会员
        
        return CGSizeMake(SCREEN_WIDTH, 200 * autoSizeScaleY + _headerImageHeight +25);
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.contentV.oilCardTextF && [string isEqualToString:@"\n"]) {
        [self.contentV.qtIDTextF becomeFirstResponder];
        return NO;
        
    }else if (textField == self.contentV.qtIDTextF && [string isEqualToString:@"\n"]){
        
        [self.view endEditing:YES];
        return NO;
    }

    if (textField == self.contentV.oilCardTextF) {//油卡只能输入数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest){
            [MBProgressHUD showError:@"油卡号输入不合法"];
            return NO;
        }
        
    }else if(textField == self.contentV.qtIDTextF){//全团ID号 只能输入数字和字母
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest){
            [MBProgressHUD showError:@"全团ID号输入不合法"];
            return NO;
        }
    }
    return YES;
    
}

#pragma mark 懒加载

-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headerImageHeight)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"轮播占位图"]];
        
        _cycleScrollView.localizationImageNamesGroup = @[];
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.titleLabelBackgroundColor = YYSRGBColor(241, 242, 243, 1);// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"轮播占位图"];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }
    
    return _cycleScrollView;
    
}

-(UICollectionView *)collectionV{
    
    if (!_collectionV) {
        
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:10];
        
        
        _collectionV =[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3 ) {
            
            _collectionV.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 5,(SCREEN_HEIGHT-64- 200 * autoSizeScaleY)/2 - 10);
        }else{//会员身份
            _collectionV.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
            flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 5, 140*autoSizeScaleY);
            
        }
        _collectionV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //        _collectionV.backgroundColor = YYSRGBColor(249, 250, 251, 1);
        _collectionV.alwaysBounceVertical = YES;
        _collectionV.showsVerticalScrollIndicator = NO;
        //        [_collectionV setContentInset:UIEdgeInsetsMake(0, 20, 0, 20)];
        //设置招商总管
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
    }
    return _collectionV;
}
- (NSArray *)titleArr{
    if (!_titleArr) {

        if ([[UserModel defaultUser].group_id integerValue] == 6 || [[UserModel defaultUser].group_id integerValue] == 4 || [[UserModel defaultUser].group_id integerValue] == 5) {
             _titleArr=[NSArray arrayWithObjects:@"收藏",@"订单",@"升级管理",@"推荐", nil];
        }else if([[UserModel defaultUser].group_id integerValue] == 1 ||[[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3){
            _titleArr=[NSArray arrayWithObjects:@"开通",@"关系",@"兑换",@"推荐", nil];
        }
    }
    return _titleArr;
}
- (NSArray *)imageArr{
    if (!_imageArr) {
       if ([[UserModel defaultUser].group_id integerValue] == 6 || [[UserModel defaultUser].group_id integerValue] == 4||[[UserModel defaultUser].group_id integerValue] == 5) {
           
           _imageArr = [NSArray arrayWithObjects:@"收藏",@"订单",@"升级管理",@"推荐", nil];
       }else{
           _imageArr = [NSArray arrayWithObjects:@"开通",@"关系",@"兑换",@"推荐", nil];
       }
    }
    return _imageArr;
}
- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskV.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *maskViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        [_maskV addGestureRecognizer:maskViewTap];
    }
    return _maskV;
}

- (GLMine_CompleteInfoView *)contentV{
    if (!_contentV) {
        _contentV = [[NSBundle mainBundle] loadNibNamed:@"GLMine_CompleteInfoView" owner:nil options:nil].lastObject;
        
        _contentV.layer.cornerRadius = 5.f;
        
        _contentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 40, 170);
        
        [_contentV.cancelBtn addTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentV.okBtn addTarget:self action:@selector(addQtIDandOilCardID) forControlEvents:UIControlEventTouchUpInside];
        
        _contentV.oilCardTextF.delegate = self;
        _contentV.qtIDTextF.delegate = self;
  
    }
    return _contentV;
}
- (NSMutableArray *)bannerArrM{
    if (!_bannerArrM) {
        _bannerArrM = [NSMutableArray array];
    }
    return _bannerArrM;
}
@end
