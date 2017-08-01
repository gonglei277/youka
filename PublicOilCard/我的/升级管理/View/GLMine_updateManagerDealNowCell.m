//
//  GLMine_updateManagerDealNowCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_updateManagerDealNowCell.h"

@interface GLMine_updateManagerDealNowCell ()
@property (weak, nonatomic) IBOutlet UIButton *dealBtn;

@end

@implementation GLMine_updateManagerDealNowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dealBtn.layer.borderWidth = 1;
    self.dealBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
