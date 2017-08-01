//
//  GLMine_SetController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SetController.h"
#import "GLMine_SetCell.h"
#import "LBModifyPasswordViewController.h"
#import "GLRecommendController.h"
#import "LBViewProtocolViewController.h"
#import "MinePhoneAlertView.h"
#import "BasetabbarViewController.h"


@interface GLMine_SetController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic , assign)float folderSize;//缓存
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property(nonatomic ,strong)MinePhoneAlertView  *phoneView;
@property(nonatomic ,strong)NSString  *phonestr;//服务热线

@end

@implementation GLMine_SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phonestr = [UserModel defaultUser].KfPhone;
    self.navigationItem.title = @"设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_SetCell" bundle:nil] forCellReuseIdentifier:@"GLMine_SetCell"];
    _dataArr = @[@"密码修改",@"内存清理",@"关于公司",@"联系客服"];
    self.quitBtn.layer.cornerRadius = 5.f;
    self.folderSize = [self filePath];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
//退出登录
- (IBAction)quitLogin:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag == 10) {
            
            [UserModel defaultUser].loginstatus = NO;
            [UserModel defaultUser].pic = @"";
            [UserModel defaultUser].group_id = @"0";
            [usermodelachivar achive];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
//            [self.navigationController popViewControllerAnimated:YES];
            BasetabbarViewController *baseVc = [[BasetabbarViewController alloc] init];
            [self presentViewController:baseVc animated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[BasetabbarViewController alloc] init];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInterface" object:nil];
            
        }else if (alertView.tag == 11){
            
            [self clearFile];//清楚缓存
        }
        
    }
    
}
#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_SetCell"];
    cell.selectionStyle = 0;
    cell.titleLabel.text = _dataArr[indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBModifyPasswordViewController *vc=[[LBModifyPasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"清理缓存%.2fM",self.folderSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 11;
            [alert show];
        }
            break;
        case 2:
        {
            self.hidesBottomBarWhenPushed = YES;
            LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
            vc.webUrl = ABOUTUS_URL;
            vc.navTitle = @"关于公司";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            self.phoneView.transform=CGAffineTransformMakeScale(0, 0);

                NSString *str=[NSString stringWithFormat:@"是否拨打电话? %@",self.phonestr];
                NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
                NSRange rangel = [[textColor string] rangeOfString:self.phonestr];
                [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76/255.0 green:140/255.0 blue:247/255.0 alpha:1] range:rangel];
                //[textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangel];
                [_phoneView.titleLb setAttributedText:textColor];
          
            [[UIApplication sharedApplication].keyWindow addSubview:self.phoneView];
            
            [UIView animateWithDuration:0.3 animations:^{
                _phoneView.transform=CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
//        case 4:
//        {
//            self.hidesBottomBarWhenPushed = YES;
//            GLRecommendController *vc=[[GLRecommendController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
            
        default:
            break;
    }

}
//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];

    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

-(void)clearCachSuccess{
    self.folderSize=[self filePath];
    
}
-(MinePhoneAlertView *)phoneView{
    
    if (!_phoneView) {
        _phoneView=[[NSBundle mainBundle]loadNibNamed:@"MinePhoneAlertView" owner:nil options:nil].firstObject;
        _phoneView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _phoneView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_phoneView.cancelBt addTarget:self action:@selector(cancelbutton) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView.sureBt addTarget:self action:@selector(surebuttonE) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _phoneView;
}
-(void)cancelbutton{
    [UIView animateWithDuration:0.3 animations:^{
        _phoneView.transform=CGAffineTransformMakeScale(0.000001, 0.000001);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [_phoneView removeFromSuperview];
        }
    }];
    
}
-(void)surebuttonE{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phonestr]]]; //拨号
    
}

@end
