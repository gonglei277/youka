//
//  GLMine_Order_OffLineCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Order_OffLineCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMine_Order_OffLineCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;



@end

@implementation GLMine_Order_OffLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.deleteBtn.layer.cornerRadius = 5.f;
    self.deleteBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.deleteBtn.layer.borderWidth = 1;
    
}
- (IBAction)clickTheDelegate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteOrder:)]) {
        [self.delegate deleteOrder:self.index];
    }
}

- (void)setModel:(GLMine_Order_OffLineModel *)model{
    _model = model;
    
    if ([[NSString stringWithFormat:@"%@",model.l_o_num] rangeOfString:@"null"].location != NSNotFound) {
        
        model.l_o_num = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.time] rangeOfString:@"null"].location != NSNotFound) {
        
        model.time = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.num] rangeOfString:@"null"].location != NSNotFound) {
        
        model.num = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.goods_price] rangeOfString:@"null"].location != NSNotFound) {
        
        model.goods_price = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.code] rangeOfString:@"null"].location != NSNotFound) {
        
        model.code = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.goods_name] rangeOfString:@"null"].location != NSNotFound) {
        
        model.goods_name = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.l_pic] rangeOfString:@"null"].location != NSNotFound) {
        
        model.l_pic = @"";
    }
    if ([[NSString stringWithFormat:@"%@",model.status] rangeOfString:@"null"].location != NSNotFound) {
        
        model.status = @"8";
    }
    
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",model.l_o_num];
    self.dateLabel.text = [NSString stringWithFormat:@"下单时间:%@",model.time];
    self.countLabel.text = [NSString stringWithFormat:@"数量:%@",model.num];
    self.priceLabel.text = [NSString stringWithFormat:@"单价:%@",model.goods_price];
    self.codeLabel.text = [NSString stringWithFormat:@"交易码:%@",model.code];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.goods_name];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.l_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if ([model.status integerValue] == 0) {
        self.statusLabel.text = @"审核失败";
        self.deleteBtn.hidden = YES;
        self.lineView.hidden = YES;
    }else if([model.status integerValue] == 1){
        self.statusLabel.text = @"审核成功";
        self.deleteBtn.hidden = NO;
        self.lineView.hidden = NO;
    }else if([model.status integerValue] == 2){
        self.statusLabel.text = @"未审核";
        self.deleteBtn.hidden = YES;
        self.lineView.hidden = YES;
    }else{
        self.statusLabel.text = @"";
        self.deleteBtn.hidden = YES;
        self.lineView.hidden = YES;
    }
    
    
}
@end
