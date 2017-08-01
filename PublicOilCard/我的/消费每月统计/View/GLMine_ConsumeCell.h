//
//  GLMine_ConsumeCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ConsumeModel.h"

@interface GLMine_ConsumeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong)GLMine_ConsumeModel *model;

@end
