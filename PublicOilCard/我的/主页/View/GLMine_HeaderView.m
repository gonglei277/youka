//
//  GLMine_HeaderView.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_HeaderView.h"
#import <Masonry/Masonry.h>

@interface GLMine_HeaderView ()

@property (nonatomic, strong)UIImageView *levelImageV;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)UIView *lineView2;

@property (nonatomic, strong)UIView *lineView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picImageVHeight;

@property (weak, nonatomic) IBOutlet UILabel *xiaofeiLabel1;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLabel1;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel1;

@end

@implementation GLMine_HeaderView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _openCardBtn.layer.borderWidth = 1;
    _openCardBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    
    _exchangeBtn.layer.borderWidth = 1;
    _exchangeBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    
    _jifenBtn.layer.borderWidth = 1;
    _jifenBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    
    self.picImageVHeight.constant = 80 *autoSizeScaleY;
    self.picImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageV.layer.cornerRadius = self.picImageVHeight.constant /2;

    self.IDLabel.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];
    self.nameLabel.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];
    self.plain_markLabel.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];

    [self.openCardBtn.titleLabel setFont:[UIFont systemFontOfSize:11 * autoSizeScaleY]];
    [self.exchangeBtn.titleLabel setFont:[UIFont systemFontOfSize:11 * autoSizeScaleY]];
    [self.jifenBtn.titleLabel setFont:[UIFont systemFontOfSize:11 * autoSizeScaleY]];
    
    self.xiaofeiLabel.font = [UIFont systemFontOfSize:11 * autoSizeScaleY];
    self.jifenLabel.font = [UIFont systemFontOfSize:11 * autoSizeScaleY];
    self.tuijianLabel.font = [UIFont systemFontOfSize:11 * autoSizeScaleY];
    self.jiangliLabel.font = [UIFont systemFontOfSize:11 * autoSizeScaleY];
    
    self.xiaofeiLabel1.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];
    self.jifenLabel1.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];
    self.tuijianLabel1.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];
    self.yueLabel1.font = [UIFont systemFontOfSize:10 * autoSizeScaleY];
    
    
}

@end
