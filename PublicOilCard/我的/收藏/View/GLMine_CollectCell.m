//
//  GLMine_CollectCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CollectCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMine_CollectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GLMine_CollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(GLMine_CollectModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:kGOODS_PlaceHolder]];
    self.titleLabel.text = model.goods_name;
    self.detailLabel.text = model.goods_info;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.discount];
    
}

-(void)setWaitOrdersListModel:(LBWaitOrdersListModel *)WaitOrdersListModel{
    _WaitOrdersListModel =WaitOrdersListModel;

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:_WaitOrdersListModel.thumb] placeholderImage:[UIImage imageNamed:kGOODS_PlaceHolder]];
    self.titleLabel.text =  [NSString stringWithFormat:@"名称: %@",_WaitOrdersListModel.goods_name];
    self.detailLabel.text =  [NSString stringWithFormat:@"%@",_WaitOrdersListModel.goods_info];
    self.priceLabel.text =  [NSString stringWithFormat:@"¥%@",_WaitOrdersListModel.goods_price];
    self.countLabel.text =  [NSString stringWithFormat:@"x%@",_WaitOrdersListModel.goods_num];
    
    if ([self.titleLabel.text rangeOfString:@"null"].location != NSNotFound) {
        self.titleLabel.text =  [NSString stringWithFormat:@"名称: "];
    }
    if ([self.detailLabel.text rangeOfString:@"null"].location != NSNotFound || self.detailLabel.text.length <= 0) {
        self.detailLabel.text =  [NSString stringWithFormat:@"暂无描述"];
    }
   
}
@end
