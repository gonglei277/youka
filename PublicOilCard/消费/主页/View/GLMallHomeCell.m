//
//  GLMallHomeCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMallHomeCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMallHomeCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation GLMallHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLMallHomeGoodsModel *)model {
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"产品占位图"]];
    self.titleLabel.text = model.goods_name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.discount];;
    self.countLabel.text = [NSString stringWithFormat:@"销量:%@",model.salenum];
}
@end
