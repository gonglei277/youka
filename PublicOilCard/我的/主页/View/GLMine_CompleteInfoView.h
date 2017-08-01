//
//  GLMine_CompleteInfoView.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_CompleteInfoView : UIView
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextField *qtIDTextF;
@property (weak, nonatomic) IBOutlet UITextField *oilCardTextF;
@property (weak, nonatomic) IBOutlet UITextField *oilCardTextF2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *petroChinaViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SinopecViewHeight;
@property (weak, nonatomic) IBOutlet UIView *youView;
@property (weak, nonatomic) IBOutlet UIView *huaView;

@end
