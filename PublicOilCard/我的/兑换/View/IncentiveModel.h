//
//  IncentiveModel.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IncentiveModelDelegete <NSObject>

-(void)choosebutton:(NSInteger)tag typeIndex:(NSInteger)typeIndex;

@end

@interface IncentiveModel : UIView

@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *sixButton;
@property (assign, nonatomic)id<IncentiveModelDelegete> delegete;

@property (assign, nonatomic)NSInteger typeIndex;

-(instancetype)initWithFrame:(CGRect)frame buttonArr:(NSArray*)arr;
@end
