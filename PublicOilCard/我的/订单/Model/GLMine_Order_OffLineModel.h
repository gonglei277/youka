//
//  GLMine_Order_OffLineModel.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Order_OffLineModel : NSObject

@property (copy, nonatomic)NSString *l_o_num;//订单号

@property (copy, nonatomic)NSString *time;//时间

@property (copy, nonatomic)NSString *num;//商品数量

@property (copy, nonatomic)NSString *goods_price;//产品单价

@property (copy, nonatomic)NSString *l_pic;//产品图片

@property (copy, nonatomic)NSString *goods_id;//产品id

@property (copy, nonatomic)NSString *goods_name;// 订单产品名字

@property (copy, nonatomic)NSString *status;// 订单状态

@property (copy, nonatomic)NSString *code;// 交易码

@property (copy, nonatomic)NSString *lid;// 线下订单ID

@property (copy, nonatomic)NSString *l_money;// 产品总价

@property (copy, nonatomic)NSString *goods_info;// 订单产品描述


@end
