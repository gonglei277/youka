//
//  UserModel.h
//  813DeepBreathing
//
//  Created by rimi on 15/8/13.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>
@property (nonatomic, assign) BOOL needAutoLogin;

@property (nonatomic, assign)BOOL   loginstatus;//登陆状态

@property (nonatomic, copy)NSString  *token;//token 校验码
@property (nonatomic, copy)NSString  *uid;//用户uid
@property (nonatomic, copy)NSString  *pic;//头像地址
@property (nonatomic, copy)NSString  *username;//用户ID
@property (nonatomic ,copy)NSString  *truename;//真实姓名
@property (nonatomic ,copy)NSString  *IDCard;//身份证
@property (nonatomic, copy)NSString  *phone;//用户手机号
@property (nonatomic ,copy)NSString  *address;//地址
@property (nonatomic ,copy)NSString  *recommendID;//推荐人
@property (nonatomic ,copy)NSString  *recommendUser;//推荐人姓名
@property (nonatomic, copy)NSString  *price;//消费金额
@property (nonatomic, copy)NSString  *mark;//全团积分
@property (nonatomic, copy)NSString  *recNumber;//推荐(的人)数量
@property (nonatomic, copy)NSString  *group_id;//用户组id
@property (nonatomic, copy)NSString  *group_name;//用户组
@property (nonatomic, copy)NSString  *qtIdNum;//全团id号
@property (nonatomic, copy)NSString  *banknumber;//银行卡号
@property (nonatomic, copy)NSString  *openbank;//开户行
@property (nonatomic, copy)NSString  *version;//版本号
@property (nonatomic, copy)NSString  *isBqInfo;//是否补全信息
@property (nonatomic, copy)NSString  *isHaveNewMsg;//是否存在新的消息
@property (nonatomic, copy)NSString  *isHaveOilCard;//是否已经开卡
@property (nonatomic, copy)NSString  *banner;
@property (nonatomic, copy)NSString  *jyzSelfCardNum;//中石油卡号
@property (nonatomic, copy)NSString  *hua_card;//中石化卡号
@property (nonatomic, copy)NSString  *cost;//中石油开卡费
@property (nonatomic, copy)NSString  *cost2;//中石化开卡费
@property (nonatomic, copy)NSString  *hua_status;//中石化卡:0 未开卡  1:已开卡
@property (nonatomic, copy)NSString  *s_meber;//招商总管网体剩余见点奖励数量
@property (nonatomic, copy)NSString  *congig_card;//对公账号
@property (nonatomic, copy)NSString  *plain_mark;//普通积分

@property (nonatomic, copy)NSString  *yue;//余额
@property (nonatomic, copy)NSString  *KfPhone;//客服电话


+(UserModel*)defaultUser;

@end
