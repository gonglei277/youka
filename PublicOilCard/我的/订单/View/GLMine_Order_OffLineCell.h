//
//  GLMine_Order_OffLineCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Order_OffLineModel.h"

@protocol GLMine_Order_OffLineCellDelegate <NSObject>

- (void)deleteOrder:(NSInteger)index;

@end

@interface GLMine_Order_OffLineCell : UITableViewCell

@property (nonatomic, strong)GLMine_Order_OffLineModel *model;
@property (nonatomic, weak)id<GLMine_Order_OffLineCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign)NSInteger index;


@end
