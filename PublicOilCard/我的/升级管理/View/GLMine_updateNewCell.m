//
//  GLMine_updateNewCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_updateNewCell.h"

@implementation GLMine_updateNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.openBtn.layer.borderWidth = 1;
    self.openBtn.layer.borderColor = TABBARTITLE_COLOR.CGColor;
    self.openBtn.layer.cornerRadius = 5.f;
    
}

- (IBAction)open:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(open:)]){
        [self.delegate open:self.index];
    }
}

@end
