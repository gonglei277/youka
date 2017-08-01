//
//  GLMine_OrderSectionModel.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_OrderSectionModel : NSObject
//用户名
@property (nonatomic, copy)NSString *user_name;
//订单编号
@property (nonatomic, copy)NSString *order_num;
//订单应付款
@property (nonatomic, copy)NSString *realy_price;
//时间
@property (nonatomic, copy)NSString *addtime;
// 订单总数量
@property (nonatomic, copy)NSString *total;
//订单状态(0订单异常1 已下单,未付款2 已付款,待发货3 已发货,待验收4 已验收,待用户确认订单生效5 确认订单生效6 交易失败7 申请退款8 退款成功9 退款失败10取消订单 11待评论
@property (nonatomic, copy)NSString *order_status;

@property (nonatomic, copy)NSString *sh_status;
// 订单ID
@property (nonatomic, copy)NSString *order_id;

@property (strong, nonatomic)NSMutableArray *dataArr;

@property (assign, nonatomic)BOOL isExpanded;//是否展开

@end
