//
//  GLMine_RelationshipHeader.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RelationshipHeader.h"
#import <Masonry/Masonry.h>

@implementation GLMine_RelationshipHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
    }
    
    return self;
}
-(void)initerface{
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureSection)];
    [self addGestureRecognizer:tapgesture];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.IDLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.dateLabel];
    
    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(self);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(self);
    }];
   
}

-(void)setSectionModel:(GLMine_RelationshipModel *)sectionModel{
    
    if (_sectionModel != sectionModel) {
        _sectionModel = sectionModel;
    }
    
    self.IDLabel.text = [NSString stringWithFormat:@"%@", sectionModel.user_name];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", sectionModel.truename];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [formattime formateTime:sectionModel.regtime]];
}

-(void)tapgestureSection{
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    
    if (self.expandCallback) {
        self.expandCallback(self.sectionModel.isExpanded);
    }
}

#pragma 懒加载

-(UILabel*)IDLabel{
    
    if (!_IDLabel) {
        _IDLabel=[[UILabel alloc]init];
        _IDLabel.backgroundColor=[UIColor clearColor];
        _IDLabel.textColor=[UIColor blackColor];
        _IDLabel.font=[UIFont systemFontOfSize:13];
    }
    
    return _IDLabel;
}
-(UILabel*)nameLabel{
    
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.font=[UIFont systemFontOfSize:13];
    }
    
    return _nameLabel;
}
-(UILabel*)dateLabel{
    
    if (!_dateLabel) {
        _dateLabel=[[UILabel alloc]init];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.textColor=[UIColor blackColor];
        _dateLabel.font=[UIFont systemFontOfSize:13];
    }
    
    return _dateLabel;
}
@end
