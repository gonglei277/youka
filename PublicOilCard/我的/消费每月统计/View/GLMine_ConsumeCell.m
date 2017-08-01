//
//  GLMine_ConsumeCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ConsumeCell.h"

@implementation GLMine_ConsumeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_ConsumeModel *)model{
    _model = model;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额:%@",model.money];
    self.dateLabel.text = model.time;
}

@end
