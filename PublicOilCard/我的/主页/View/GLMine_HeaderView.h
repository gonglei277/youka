//
//  GLMine_HeaderView.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_HeaderView : UICollectionReusableView

//@property (nonatomic, strong)UIImageView *picImagaV;
//@property (nonatomic, strong)UIButton *openCardBtn;
//@property (nonatomic, strong)UIButton *exchangeBtn;
//@property (nonatomic, strong)UILabel *positionLabel;
//@property (nonatomic, strong)UILabel  *IDLabel;
//@property (nonatomic, strong)UILabel *nameLabel;
//
//@property (nonatomic, strong)UIView *middleView;
//@property (nonatomic, strong)UIView *xiaofeiView;
//@property (nonatomic, strong)UIView *jifenView;
//@property (nonatomic, strong)UIView *tuijianView;
//@property (nonatomic, strong)UILabel *xiaofeiLabel;
//@property (nonatomic, strong)UILabel *xiaofeiL;
//@property (nonatomic, strong)UILabel *jifenLabel;
//@property (nonatomic, strong)UILabel *jifenL;
//@property (nonatomic, strong)UILabel *tuijianLabel;
//@property (nonatomic, strong)UILabel *tuijianL;
//
//@property (nonatomic, strong)UIImageView *adImageV;
@property (weak, nonatomic) IBOutlet UIButton *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *plain_markLabel;

@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *openCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *jifenBtn;


@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewBottom;

@property (weak, nonatomic) IBOutlet UILabel *xiaofeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuijianLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiangliLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageV;

@property (weak, nonatomic) IBOutlet UIView *jifenView;
@property (weak, nonatomic) IBOutlet UIView *yueView;
@property (weak, nonatomic) IBOutlet UIView *tuijianView;
@property (weak, nonatomic) IBOutlet UIView *xiaofeiView;

@property (weak, nonatomic) IBOutlet UIImageView *tuijianImageV;
@property (weak, nonatomic) IBOutlet UIImageView *jifenImageV;
@property (weak, nonatomic) IBOutlet UIImageView *xiaofeiImageV;

@end
