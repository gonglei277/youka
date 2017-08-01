//
//  GLMine_RecommendRecordCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_RecommendRecordModel.h"
#import "GLMine_SpendingCountModel.h"

@interface GLMine_RecommendRecordCell : UITableViewCell

@property (nonatomic, strong)GLMine_RecommendRecordModel *model;

@property (nonatomic, strong)GLMine_SpendingCountModel *countModel;

@end
