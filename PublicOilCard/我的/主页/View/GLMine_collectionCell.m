//
//  GLMine_collectionCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_collectionCell.h"

@interface GLMine_collectionCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picImageVWidth;

@end

@implementation GLMine_collectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageVWidth.constant = 65 * autoSizeScaleX;
    self.titleLabel.font = [UIFont systemFontOfSize:13 * autoSizeScaleY];
}

@end
