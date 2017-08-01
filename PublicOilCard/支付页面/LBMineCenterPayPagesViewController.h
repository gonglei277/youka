//
//  LBMineCenterPayPagesViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineCenterPayPagesViewController : UIViewController

//@property (nonatomic, assign) NSInteger payType; // 支付类型 1普通消费支付  2 积分支付

@property (nonatomic, copy) NSString *order_id;//订单id

@property (nonatomic, copy) NSString *order_num;//订单号

@property (nonatomic, copy) NSString *addtime;//下单时间

@property (nonatomic, copy) NSString *realy_price;//支付金额

@property (nonatomic, strong)NSString *goods_name;

@property (nonatomic, copy)NSString *goods_id;

@property (nonatomic, copy)NSString *goods_num;

@property (nonatomic, assign)NSInteger pushIndex;//记录从哪个控制器push的 1从商品详情跳转过去 2开卡跳转过去  3申请招商总管
@property (nonatomic, assign)NSInteger openCardType;//1:中石油卡  2:中石化卡
@property (nonatomic, assign)NSInteger upgrade;//1首期招商总管 2二期招商总管

@end
