//
//  GLMine_updateManagerCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_updateManagerCell.h"

@interface GLMine_updateManagerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dotImageV;

@end

@implementation GLMine_updateManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dotImageV.layer.cornerRadius = 5.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
