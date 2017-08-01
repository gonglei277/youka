//
//  GLMall_GoodsHeaderView.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_GoodsHeaderView.h"
#import "JZAlbumViewController.h"

@interface GLMall_GoodsHeaderView ()<SDCycleScrollViewDelegate>
{
    NSInteger _sum;
}
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation GLMall_GoodsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)changeNum:(UIButton *)sender {
    
    if (sender == self.reduceBtn) {
        self.numberLabel.text = [NSString stringWithFormat:@"%zd",[self.numberLabel.text integerValue] - 1];
        
        if([self.numberLabel.text integerValue] <= 1){
            self.numberLabel.text = @"1";
        }
        
    }else{
        
        if([self.numberLabel.text integerValue] >= [self.stockNum integerValue]){
            [MBProgressHUD showError:@"库存不足"];
            return;
        }
        self.numberLabel.text = [NSString stringWithFormat:@"%zd",[self.numberLabel.text integerValue] + 1];
    }
    if ([_delegate respondsToSelector:@selector(changeNum:)]) { // 如果协议响应
        
        [_delegate changeNum:self.numberLabel.text];
    }

}
//收藏
- (IBAction)collectionEvent:(UIButton *)sender {
    
    [self.delegate collect:self.collectionBt];
    
}


@end
