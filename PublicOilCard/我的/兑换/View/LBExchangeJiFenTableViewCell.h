//
//  LBExchangeJiFenTableViewCell.h
//  PublicOilCard
//
//  Created by 四川三君科技有限公司 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBExchangeJiFenTableViewCellDelegete <NSObject>

-(void)showExchangeType:(NSIndexPath*)indexpath;

@end

@interface LBExchangeJiFenTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *textf;
@property (assign, nonatomic)id<LBExchangeJiFenTableViewCellDelegete> delegete;
@property (strong , nonatomic)NSIndexPath *indexpath;
@end
