//
//  GLHome_jifenHeaderView.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHome_jifenSectionModel.h"

typedef void(^OrderHeadViewExpandCallback)(BOOL isExpanded);

@interface GLHome_jifenHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy)OrderHeadViewExpandCallback expandCallback;

@property (assign, nonatomic)  NSInteger  section;

@property (nonatomic, strong)GLHome_jifenSectionModel *sectionModel;

@end
