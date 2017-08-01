//
//  GLMine_CollectCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_CollectModel.h"
#import "LBWaitOrdersListModel.h"

@interface GLMine_CollectCell : UITableViewCell

@property (nonatomic, strong)GLMine_CollectModel *model;
@property (strong, nonatomic)LBWaitOrdersListModel *WaitOrdersListModel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end
