//
//  GLMine_updateManagerAllCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_updateManagerAllCell.h"

@interface GLMine_updateManagerAllCell()

@property (weak, nonatomic) IBOutlet UIButton *checkAllBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
//@property (nonatomic, assign)BOOL isSelecte;

@end

@implementation GLMine_updateManagerAllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.checkAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    self.isSelecte = NO;
}
- (IBAction)checkAll:(id)sender {
    
    self.returnBlock(self.model.isCheckAll,self.index);
}
- (void)setModel:(GLMine_updateManagerModel *)model {
    _model = model;
    if (self.model.isCheckAll) {
        
        [self.checkAllBtn setTitle:@"收起" forState:UIControlStateNormal];
        self.imageV.transform = CGAffineTransformMakeRotation(M_PI);//旋转
        
    }else{
        
        [self.checkAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
         self.imageV.transform = CGAffineTransformMakeRotation(0);//旋转
    }

}

@end
