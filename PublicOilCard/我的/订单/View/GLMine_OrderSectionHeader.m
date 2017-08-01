//
//  GLMine_OrderSectionHeader.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_OrderSectionHeader.h"

@interface GLMine_OrderSectionHeader()
@property (weak, nonatomic) IBOutlet UIButton *payNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation GLMine_OrderSectionHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.payNowBtn.layer.cornerRadius = 5.f;
    self.payNowBtn.layer.borderWidth = 1;
    self.payNowBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    
    self.cancelBtn.layer.cornerRadius = 5.f;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgestureSection)];
    [self addGestureRecognizer:tapgesture];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}

- (void)setSectionModel:(GLMine_OrderSectionModel *)sectionModel{
    _sectionModel = sectionModel;

     self.orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",_sectionModel.order_num];
     self.dateLabel.text = [formattime formateTime:[NSString stringWithFormat:@"%@",_sectionModel.addtime]];
    //订单状态(0订单异常1 已下单,未付款2 已付款,待发货3 已发货,待验收4 已验收,待用户确认订单生效5 确认订单生效6 交易失败7 申请退款8 退款成功9 退款失败10取消订单 11待评论
    switch ([_sectionModel.order_status integerValue]) {
        case 0:
            self.statusLabel.text = @"未支付";
            [self.payNowBtn setTitle:@"立即支付" forState:UIControlStateNormal];
            [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            self.payNowBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            break;
        case 1:
            self.statusLabel.text = @"待充值";
            self.payNowBtn.hidden = YES;
            self.cancelBtn.hidden = YES;
//              [self.payNowBtn setTitle:@"删除" forState:UIControlStateNormal];
            break;
        case 2:
            self.statusLabel.text = @"支付失败";
            [self.payNowBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.payNowBtn.hidden = NO;
            self.cancelBtn.hidden = YES;
            break;
        case 3:
            self.statusLabel.text = @"取消订单";
            [self.payNowBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.payNowBtn.hidden = NO;
            self.cancelBtn.hidden = YES;
            break;
        case 4:
            self.statusLabel.text = @"已完成";
            [self.payNowBtn setTitle:@"删除" forState:UIControlStateNormal];
            self.payNowBtn.hidden = NO;
            self.cancelBtn.hidden = YES;
            break;
        case 5:
            self.statusLabel.text = @"审核失败";
            self.payNowBtn.hidden = YES;
            self.cancelBtn.hidden = YES;
            break;
        
        default:
            break;
    }
}
//取消订单
- (IBAction)cancelEvent:(UIButton *)sender {
    
    [self.delegete orderCancel:self.section];
}
//立即支付
- (IBAction)payEvent:(UIButton *)sender {
    
    [self.delegete orderpay:self.section];
}


-(void)tapgestureSection{
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    if (self.expandCallback) {
        self.expandCallback(self.sectionModel.isExpanded);
    }
}
@end
