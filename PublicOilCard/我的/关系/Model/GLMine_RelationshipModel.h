//
//  GLMine_RelationshipModel.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_RelationshipModel : NSObject

@property (nonatomic, copy)NSString *group_id;

@property (nonatomic, copy)NSString *uid;

@property (nonatomic, copy)NSString *user_name;

@property (nonatomic, copy)NSString *truename;

@property (nonatomic, copy)NSString *regtime;

@property (nonatomic, copy)NSString *jl;//经理个数

@property (nonatomic, copy)NSString *hy;//会员个数

@property (nonatomic, copy)NSString *ad;//首期招商总管

@property (nonatomic, copy)NSString *bd;//二期招商总管

@property (nonatomic, assign)BOOL isExpanded;//是否展开

@end
