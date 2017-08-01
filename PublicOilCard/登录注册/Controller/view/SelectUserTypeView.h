//
//  SelectUserTypeView.h
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectUserTypeView : UIView
//会员
@property (weak, nonatomic) IBOutlet UIButton *shanBt;
//首期招商总管
@property (weak, nonatomic) IBOutlet UIButton *lingBt;
//二期招商总管
@property (weak, nonatomic) IBOutlet UIButton *secondDelegateBtn;
//经理
@property (weak, nonatomic) IBOutlet UIButton *ServiceBt;
//总监
@property (weak, nonatomic) IBOutlet UIButton *ManufacturerBt;
//部长
@property (weak, nonatomic) IBOutlet UIButton *TraderBt;
////零售
//@property (weak, nonatomic) IBOutlet UIButton *lingshouBt;


@end
