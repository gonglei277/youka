//
//  GLMine_updateManagerAllCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_updateManagerModel.h"

typedef void(^block)(BOOL isCheckAll,NSInteger index);

@interface GLMine_updateManagerAllCell : UITableViewCell

@property (nonatomic, copy)block returnBlock;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)GLMine_updateManagerModel *model;

@end
