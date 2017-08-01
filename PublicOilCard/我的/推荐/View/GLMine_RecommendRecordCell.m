//
//  GLMine_RecommendRecordCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RecommendRecordCell.h"
#import "formattime.h"

@interface GLMine_RecommendRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLMine_RecommendRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(GLMine_RecommendRecordModel *)model {
    _model = model;
    self.IDLabel.text = model.user_name;
    self.trueNameLabel.text = model.truename;

    self.dateLabel.text = [formattime formateTime:model.regtime];
}
- (void)setCountModel:(GLMine_SpendingCountModel *)countModel{
    _countModel = countModel;
    self.IDLabel.text = countModel.user_name;
    self.trueNameLabel.text = countModel.truename;
    self.dateLabel.textColor = [UIColor redColor];
    self.dateLabel.text = countModel.money;
}
@end
