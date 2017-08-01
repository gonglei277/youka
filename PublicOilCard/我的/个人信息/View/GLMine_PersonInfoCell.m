//
//  GLMine_PersonInfoCell.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoCell.h"

@interface GLMine_PersonInfoCell()<UITextFieldDelegate>

@end

@implementation GLMine_PersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.returnEditing) {
        self.returnEditing(textField.text , self.index);
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
//    if ([[UserModel defaultUser].usrtype isEqualToString:Retailer] && [[UserModel defaultUser].AudiThrough isEqualToString:@"1"]) {
//        
//        if (self.index == 5) {
//            for(int i=0; i< [string length];i++){
//                
//                int a = [string characterAtIndex:i];
//                
//                if( a >= 0x4e00 && a <= 0x9fff)
//                    
//                    return NO;
//            }
//        }
//        
//    }
    
    return YES;
    
}
@end
