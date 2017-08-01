//
//  LBExchangeFooterView.m
//  PublicOilCard
//
//  Created by 四川三君科技有限公司 on 2017/6/19.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBExchangeFooterView.h"
#import <Masonry/Masonry.h>

@implementation LBExchangeFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];
        
        self.backgroundColor=YYSRGBColor(235, 235, 235, 1);
    }
    return self;
    
}

-(void)loadUI{

    [self addSubview:self.namelebel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.noticeLabel];
    [self addSubview:self.Remarks];
    
    [self.Remarks mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(15);

    }];
    
    [self.namelebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(0);
       make.top.equalTo(self.Remarks.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
    [self.noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self.namelebel.mas_bottom).offset(10);
//        make.bottom.equalTo(self).offset(20);
    }];
}

-(UILabel*)namelebel{
    
    if (!_namelebel) {
        _namelebel=[[UILabel alloc]init];
        _namelebel.backgroundColor=[UIColor clearColor];
        _namelebel.textColor=YYSRGBColor(50, 50, 50, 1);
        _namelebel.font=[UIFont systemFontOfSize:14];
        _namelebel.textAlignment=NSTextAlignmentCenter;
       _namelebel.text = @"兑换须知";
    }
    return _namelebel;
    
}


-(UILabel*)Remarks{
    
    if (!_Remarks) {
        _Remarks=[[UILabel alloc]init];
        _Remarks.backgroundColor=[UIColor clearColor];
        _Remarks.textColor=[UIColor darkGrayColor];
        _Remarks.font=[UIFont systemFontOfSize:12];
        _Remarks.textAlignment = NSTextAlignmentLeft;
        _Remarks.numberOfLines = 0;
        
    }
    return _Remarks;
    
}


-(UILabel*)noticeLabel{
    
    if (!_noticeLabel) {
        _noticeLabel=[[UILabel alloc]init];
        _noticeLabel.backgroundColor=[UIColor clearColor];
        _noticeLabel.textColor=[UIColor darkGrayColor];
        _noticeLabel.font=[UIFont systemFontOfSize:13];
        _noticeLabel.textAlignment = NSTextAlignmentLeft;
        _noticeLabel.numberOfLines = 0;

    }
    return _noticeLabel;
    
}

@end
