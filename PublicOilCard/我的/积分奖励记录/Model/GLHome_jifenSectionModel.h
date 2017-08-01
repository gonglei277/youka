//
//  GLHome_jifenSectionModel.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_jifenSectionModel : NSObject

@property (nonatomic, copy)NSString *money;

@property (nonatomic, copy)NSString *time;

@property (nonatomic, copy)NSString *type;

@property (strong, nonatomic)NSMutableArray *log_listArr;

@property (assign, nonatomic)BOOL isExpanded;//是否展开

@end
