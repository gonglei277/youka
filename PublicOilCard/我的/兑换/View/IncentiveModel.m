//
//  IncentiveModel.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "IncentiveModel.h"

@interface IncentiveModel ()

@property (strong, nonatomic)NSArray *buttonarr;

@end

@implementation IncentiveModel

-(instancetype)initWithFrame:(CGRect)frame buttonArr:(NSArray*)arr{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.buttonarr = arr;
        UIImageView *imagev=[[UIImageView alloc]initWithFrame:frame];
        imagev.image = [UIImage imageNamed:@"imcc_record_bg"];
        [self addSubview:imagev];
        [self initdataSorce];
    }

    return self;
}

-(void)initdataSorce{

    CGFloat Height = 0;
    for (int i = 0; i < self.buttonarr.count; i++) {
        Height = 35 * i + 5 ;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, Height, self.bounds.size.width, 30)];
        [button setTitle:_buttonarr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = 10 + i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonevent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

}

-(void)buttonevent:(UIButton*)sender{
    [self.delegete choosebutton:sender.tag typeIndex:self.typeIndex];
}
@end
