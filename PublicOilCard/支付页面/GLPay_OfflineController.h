//
//  GLPay_OfflineController.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLPay_OfflineController : UIViewController

@property (nonatomic, strong)NSString *goods_name;//名字

@property (nonatomic, strong)NSString *realy_price;//金额

//@property (nonatomic, strong)NSString *order_num;

@property (nonatomic, strong)NSString *goods_num;//数量

@property (nonatomic, strong)NSString *goods_id;

@property (nonatomic, assign)NSInteger pushIndex;//1: 商品消费  2:代理商申请

@property (nonatomic, assign)NSInteger upgrade;//升级类型 1首期代理 2二期代理

@end
