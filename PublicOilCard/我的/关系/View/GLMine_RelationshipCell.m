//
//  GLMine_RelationshipCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RelationshipCell.h"

@interface GLMine_RelationshipCell ()
@property (weak, nonatomic) IBOutlet UILabel *subordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *delegateOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *delegateTwoLabel;

@end

@implementation GLMine_RelationshipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLMine_RelationshipModel *)model{
    _model = model;
    if ([[UserModel defaultUser].group_id integerValue] == 2) {
        self.subordinateLabel.text = [NSString stringWithFormat:@"经理:无权限开通"];

    }else{
        
        self.subordinateLabel.text = [NSString stringWithFormat:@"经理:%@人",model.jl];
    }
    self.memberLabel.text = [NSString stringWithFormat:@"会员:%@人",model.hy];
    self.delegateOneLabel.text = [NSString stringWithFormat:@"首期招商总管:%@人",model.ad];
    self.delegateTwoLabel.text = [NSString stringWithFormat:@"二期招商总管:%@人",model.bd];
}
@end
