//
//  GLMine_RelationshipHeader.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_RelationshipModel.h"

typedef void(^GXHeadViewExpandCallback)(BOOL isExpanded);
@interface GLMine_RelationshipHeader : UITableViewHeaderFooterView

@property (nonatomic, copy)GXHeadViewExpandCallback expandCallback;
@property (nonatomic, strong)GLMine_RelationshipModel *sectionModel;

@property(nonatomic , strong) UILabel *IDLabel;
@property(nonatomic , strong) UILabel *nameLabel;
@property(nonatomic , strong) UILabel *dateLabel;

@end
