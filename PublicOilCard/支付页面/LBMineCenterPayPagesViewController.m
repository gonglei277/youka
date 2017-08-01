//
//  LBMineCenterPayPagesViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterPayPagesViewController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
#import "GLMineHomeController.h"
#import "GLSet_MaskVeiw.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LBPayFooterView.h"
#import "GLPay_OfflineController.h"

@interface LBMineCenterPayPagesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
//    GLOrderPayView *_contentView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ensurePayBtnHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (strong, nonatomic)  NSArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UILabel *order_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderMTitleLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (nonatomic, strong)NSDictionary *dataDic;

@property (strong, nonatomic)LBPayFooterView *payFooterView;

@end

@implementation LBMineCenterPayPagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"支付页面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectIndex = -1;

    self.ensurePayBtnHeight.constant = 45 *autoSizeScaleY;
    
    self.payFooterView = [[LBPayFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 230)];
    
    self.payFooterView.noticeLabel.text = @"         会员二次油卡消费再充值，不能在线下任何加油站进行充值，充值卡存在被格式化的风险，系统将无法对会员二次充值及加油站的交易进行结算，从而导致无法对会员消费进行相应奖励及优惠; 会员须自己在系统指定的充值端口线上进行充值；如因个人原因操作不当导致系统不能结算并无法提供奖励及优惠均由会员自行负责，特此公告!";
    
    self.payFooterView.namelebel.text = @"温馨提示";
    self.tableview.tableFooterView = self.payFooterView;
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterPayPagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterPayPagesTableViewCell"];
    
//    self.goodsNumLabel.text = self.goods_num;
    self.order_numLabel.text = self.order_num;
    self.addtimeLabel.text = self.addtime;
    self.orderMoney.text = [NSString stringWithFormat:@"¥ %@",self.realy_price];

    for (int i=0; i<_dataarr.count; i++) {
        
        [self.selectB addObject:@NO];
        
    }
    
    if (self.pushIndex == 3 || self.pushIndex== 2) {
        self.topViewHeight.constant = 0;
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];

//    [self initData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
}

//支付宝客户端支付成功之后 发送通知
-(void)Alipaysucess{
    
    self.hidesBottomBarWhenPushed = YES;
    if(self.pushIndex == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else if(self.pushIndex == 2){
        
        for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[GLMineHomeController class]]) { //这里判断是否为你想要跳转的页面
                [self.navigationController popToViewController:controller animated:YES]; //跳转
            }
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateManagerNotification" object:nil];
    }

    self.hidesBottomBarWhenPushed = NO;

}
-(void)wxpaysucess{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterPayPagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterPayPagesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payimage.image = [UIImage imageNamed:_dataarr[indexPath.row][@"image"]];
    cell.paytitile.text = _dataarr[indexPath.row][@"title"];

    if ([self.selectB[indexPath.row]boolValue] == NO) {
        
        cell.selectimage.image = [UIImage imageNamed:@"支付未选中"];
    }else{
    
        cell.selectimage.image = [UIImage imageNamed:@"支付选中"];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectIndex == -1) {
        
        BOOL a=[self.selectB[indexPath.row]boolValue];
        [self.selectB replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!a]];
        self.selectIndex = indexPath.row;
        
    }else{
        
        if (self.selectIndex == indexPath.row) {
            return;
        }
        
        if (self.pushIndex == 1) {
            
        }
        
        BOOL a=[self.selectB[indexPath.row] boolValue];
        [self.selectB replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!a]];
        [self.selectB replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = indexPath.row;
    
    }

    [self.tableview reloadData];
}

- (void)dismiss{
    
//    [_contentView.passwordF resignFirstResponder];
//    [UIView animateWithDuration:0.3 animations:^{
//        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
//    }completion:^(BOOL finished) {
//        [_maskV removeFromSuperview];
//    }];
    
}
- (IBAction)surebutton:(UIButton *)sender {
    
    if (![self.selectB containsObject:@(YES)]){
        [MBProgressHUD showError:@"请选择支付方式"];
        return;
    }
    
    if ( self.selectIndex == 0) {
        if(self.pushIndex == 1 || self.pushIndex == 3){
//            self.hidesBottomBarWhenPushed = YES;
//            
//            GLPay_OfflineController *payOffVC = [[GLPay_OfflineController alloc] init];
//            
//            payOffVC.goods_name = self.goods_name;
//            payOffVC.realy_price = self.realy_price;
//            payOffVC.order_num = self.order_num;
//            payOffVC.goods_num = self.goods_num;
//            payOffVC.goods_id = self.goods_id;
//            payOffVC.pushIndex = self.pushIndex;
//            
//            [self.navigationController pushViewController:payOffVC animated:YES];
        }else{
            
            [self alipayAndWeChatPay:@"1"];
        }
    }else if(self.selectIndex == 1){
        
        [MBProgressHUD showError:@"暂不支持"];
        return;
//        [self alipayAndWeChatPay:@"1"];
        
    }
    
 }


- (void)alipayAndWeChatPay:(NSString *)payType{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *urlstr = [[NSString alloc]init];
    if(self.pushIndex == 1){
       
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"order_id"] = self.order_id;
        dict[@"paytype"] = payType;
        dict[@"realy_price"] = self.realy_price;
        dict[@"order_num"] = self.order_num;
        dict[@"goods_id"] = self.goods_id;
        dict[@"goods_num"] = self.goods_num;
        urlstr = kORDER_PAY_URL;
        
    }else if(self.pushIndex == 2){
       
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"pay_fun"] = payType;
        dict[@"card_fun"] = [NSString stringWithFormat:@"%zd",self.openCardType + 1];
        urlstr = kOPENCARD_URL;
        
    }else if(self.pushIndex == 3){
        
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"user_name"] = [UserModel defaultUser].username;
        dict[@"upgrade"] = @(self.upgrade);
        dict[@"pay_fun"] = payType;
        urlstr = kUPGRADE_URL;
    }
    
    [NetworkManager requestPOSTWithURLStr:urlstr paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        if ([responseObject[@"code"] integerValue] == 1){
            
            NSString *alipay = [[NSString alloc]init];
            alipay = responseObject[@"data"][@"alipay"];
            
           [ [AlipaySDK defaultService] payOrder:alipay fromScheme:@"publicOilCardAlipay" callback:^(NSDictionary *resultDic) {
               
               NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
               if (orderState==9000) {
                   self.hidesBottomBarWhenPushed = YES;
                   
                   if(self.pushIndex == 1){
                       [self.navigationController popToRootViewControllerAnimated:YES];
       
                   }else if(self.pushIndex == 2){
                       
                       for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
                           if ([controller isKindOfClass:[GLMineHomeController class]]) { //这里判断是否为你想要跳转的页面
                                [self.navigationController popToViewController:controller animated:YES]; //跳转
                           }
                       }
                       
                   }else{
                       
                       [self.navigationController popViewControllerAnimated:YES];
                       [[NSNotificationCenter defaultCenter] postNotificationName:@"updateManagerNotification" object:nil];
                   }
                   self.hidesBottomBarWhenPushed = NO;
                
               }else{
                   NSString *returnStr;
                   switch (orderState) {
                       case 8000:
                            returnStr=@"订单正在处理中";
                           break;
                       case 4000:
                           returnStr=@"订单支付失败";
                           break;
                       case 6001:
                           returnStr=@"订单取消";
                           break;
                       case 6002:
                           returnStr=@"网络连接出错";
                           break;
                           
                       default:
                           break;
                   }
                   
                    [MBProgressHUD showError:returnStr];
                   
               }
    
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];
}


//支付请求
- (void)postRepuest:(NSNotification *)sender {

  
}

-(NSArray*)dataarr{

    if (!_dataarr) {
   
        if(self.pushIndex == 1){
            _dataarr = [NSArray arrayWithObjects:@{@"image":@"微信",@"title":@"线下支付"}, nil];
            
        }else{
//
            _dataarr = [NSArray arrayWithObjects:@{@"image":@"支付宝",@"title":@"支付宝支付"},@{@"image":@"微信",@"title":@"微信支付"}, nil];
        }

    }

    return _dataarr;
}

-(NSMutableArray*)selectB{

    if (!_selectB) {
        _selectB=[NSMutableArray array];
    }
    
    return _selectB;

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.sureBt.layer.cornerRadius = 4;
    self.sureBt.clipsToBounds = YES;

}

@end
