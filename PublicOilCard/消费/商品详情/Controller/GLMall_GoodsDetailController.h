//
//  GLMall_GoodsDetailController.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMall_GoodsDetailController : UIViewController

@property (nonatomic, copy)NSString  *goods_id;

@property (nonatomic, assign)NSInteger pushIndex;//1:从商城跳转 2:从收藏列表里跳转
@end
