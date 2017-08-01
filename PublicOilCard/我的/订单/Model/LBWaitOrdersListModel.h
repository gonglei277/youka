//
//  LBWaitOrdersListModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBWaitOrdersListModel : NSObject

@property (copy, nonatomic)NSString *order_id;
// 订单ID
@property (copy, nonatomic)NSString *goods_num;
// 产品数量
@property (copy, nonatomic)NSString *goods_price;
//产品单价
@property (copy, nonatomic)NSString *total_price;
// 产品总价
@property (copy, nonatomic)NSString *thumb;
// 订单产品ID
@property (copy, nonatomic)NSString *goods_id;
// 订单产品描述
@property (copy, nonatomic)NSString *goods_info;
// 订单产品名字
@property (copy, nonatomic)NSString *goods_name;

@end
