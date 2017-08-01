//
//  recordeManger.h
//  PublicOilCard
//
//  Created by 四川三君科技有限公司 on 2017/6/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordeManger : NSObject

@property (nonatomic, copy)NSString  *recordeType;//记录类型
+(recordeManger*)defaultUser;
@end
