//
//  LBPayFooterView.m
//  PublicOilCard
//
//  Created by 四川三君科技有限公司 on 2017/7/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "LBPayFooterView.h"
#import <Masonry/Masonry.h>

@implementation LBPayFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];
        
        self.backgroundColor=YYSRGBColor(255, 255, 255, 1);
    }
    return self;
    
}

-(void)loadUI{
    
    [self addSubview:self.namelebel];
    [self addSubview:self.noticeLabel];

    [self.namelebel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
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
        _namelebel.textColor=[UIColor redColor];
        _namelebel.font=[UIFont systemFontOfSize:14];
        _namelebel.textAlignment=NSTextAlignmentLeft;
        _namelebel.text = @"温馨提示: ";
    }
    return _namelebel;
    
}


-(UILabel*)noticeLabel{
    
    if (!_noticeLabel) {
        _noticeLabel=[[UILabel alloc]init];
        _noticeLabel.backgroundColor=[UIColor clearColor];
        _noticeLabel.textColor=[UIColor darkGrayColor];
        _noticeLabel.font=[UIFont systemFontOfSize:11];
        _noticeLabel.textAlignment = NSTextAlignmentLeft;
        _noticeLabel.numberOfLines = 0;
        
    }
    return _noticeLabel;
    
}


@end
