//
//  GLHome_jifenHeaderView.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_jifenHeaderView.h"

@interface GLHome_jifenHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLHome_jifenHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgestureSection)];
    [self addGestureRecognizer:tapgesture];
    self.contentView.backgroundColor = [UIColor whiteColor];
}
-(void)tapgestureSection{
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    if (self.expandCallback) {
        self.expandCallback(self.sectionModel.isExpanded);
    }
}
- (void)setSectionModel:(GLHome_jifenSectionModel *)sectionModel{
    _sectionModel = sectionModel;
    self.moneyLabel.text = [NSString stringWithFormat:@"+%@",sectionModel.money];
    self.dateLabel.text = sectionModel.time;
//    //时间戳转化成时间
//    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
//    [stampFormatter setDateFormat:@"YYYY-MM-dd"];
//    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
//    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[sectionModel.time integerValue]];
////    NSLog(@"时间戳转化时间 >>> %@",[stampFormatter stringFromDate:stampDate2]);
//
//    self.dateLabel.text = [stampFormatter stringFromDate:stampDate2];
}
@end
