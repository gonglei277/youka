//
//  GLMine_PersonInfoCell.h
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMine_PersonInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;

@property (assign, nonatomic)NSInteger index;

@property (copy, nonatomic)void(^returnEditing)(NSString *content,NSInteger index);

@end
