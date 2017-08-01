//
//  GLMine_InfoCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_InfoCell.h"

@interface GLMine_InfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *dotImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLMine_InfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dotImageV.layer.cornerRadius = 4.f;
    
}
- (void)setModel:(GLMine_InfoModel *)model {
    _model = model;
    self.nameLabel.text = model.title;
    self.detailLabel.text = model.content;
    self.dateLabel.text = model.addtime;
}


@end
