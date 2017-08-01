//
//  GLMine_updateNewCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_updateNewCellDelegate <NSObject>

- (void)open:(NSInteger )index;

@end

@interface GLMine_updateNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)id <GLMine_updateNewCellDelegate>delegate;

@end
