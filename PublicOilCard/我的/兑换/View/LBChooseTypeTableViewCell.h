//
//  LBChooseTypeTableViewCell.h
//  PublicOilCard
//
//  Created by 四川三君科技有限公司 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBChooseTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imagev;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;

@end
