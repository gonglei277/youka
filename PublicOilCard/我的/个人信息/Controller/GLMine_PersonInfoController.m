//
//  GLMine_PersonInfoController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"
#import "GLMine_PersonInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GLMine_PersonInfoCodeView.h"
#import "GLMine_CompleteInfoView.h"


@interface GLMine_PersonInfoController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    //假数据源
    NSArray *_keyArr;
//    NSArray *_vlaueArr;
    NSString *_qtNum;
    NSString *_youCardNum;
    NSString *_huaCardNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic)LoadWaitView *loadV;

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, strong)NSMutableArray *canEditArr;

@property (nonatomic, strong)NSMutableArray *vlaueArr;

@property (nonatomic, copy)NSString *bankNum;

@property (nonatomic, copy)NSString *oilCardNum;

@property (strong, nonatomic)UIImage *picImage;//头像

@property (strong, nonatomic)UIImage *codeImage;//二维码

@property (nonatomic, strong)UIView *maskV;

@property (nonatomic, strong)GLMine_PersonInfoCodeView *contentV;

@property (nonatomic, strong)GLMine_CompleteInfoView *infoContentV;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self updateInfo];
    
    //自定义右键
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self  action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 80, 40);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_PersonInfoCell" bundle:nil] forCellReuseIdentifier:@"GLMine_PersonInfoCell"];
}

- (void)updateInfo{
    if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3) {
        _keyArr = @[@"头像",@"真实姓名",@"ID",@"二维码",@"身份证号码",@"开户银行",@"银行卡号",@"全团了ID",@"推荐人",@"推荐人ID"];
    }else if([[UserModel defaultUser].group_id integerValue] == 6){
        
        _keyArr = @[@"头像",@"真实姓名",@"ID",@"二维码",@"身份证号码",@"开户银行",@"银行卡号",@"中石油卡号",@"中石化卡号",@"全团了ID",@"推荐人",@"推荐人ID"];
    }else{
    _keyArr = @[@"头像",@"真实姓名",@"ID",@"二维码",@"身份证号码",@"开户银行",@"银行卡号",@"中石油卡号",@"中石化卡号",@"全团了ID",@"剩余见点奖励数量",@"推荐人",@"推荐人ID"];
    }

    if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3) {
        
        self.vlaueArr = [NSMutableArray arrayWithObjects:
                         [UserModel defaultUser].pic,
                         [UserModel defaultUser].truename,
                         [UserModel defaultUser].username,
                         [UserModel defaultUser].username,
                         [UserModel defaultUser].IDCard,
                         [UserModel defaultUser].openbank,
                         [UserModel defaultUser].banknumber,
                         [UserModel defaultUser].qtIdNum,
                         [UserModel defaultUser].recommendUser,
                         [UserModel defaultUser].recommendID, nil];

    } else if([[UserModel defaultUser].group_id integerValue] == 6 ){
        
        self.vlaueArr = [NSMutableArray arrayWithObjects:
                         [UserModel defaultUser].pic,
                         [UserModel defaultUser].truename,
                         [UserModel defaultUser].username,
                         [UserModel defaultUser].username,
                         [UserModel defaultUser].IDCard,
                         [UserModel defaultUser].openbank,
                         [UserModel defaultUser].banknumber,
                         [UserModel defaultUser].jyzSelfCardNum,
                         [UserModel defaultUser].hua_card,
                         [UserModel defaultUser].qtIdNum,
                         [UserModel defaultUser].recommendUser,
                         [UserModel defaultUser].recommendID, nil];
    }else{
    
        self.vlaueArr = [NSMutableArray arrayWithObjects:
                         [UserModel defaultUser].pic,
                         [UserModel defaultUser].truename,
                         [UserModel defaultUser].username,
                         [UserModel defaultUser].username,
                         [UserModel defaultUser].IDCard,
                         [UserModel defaultUser].openbank,
                         [UserModel defaultUser].banknumber,
                         [UserModel defaultUser].jyzSelfCardNum,
                         [UserModel defaultUser].hua_card,
                         [UserModel defaultUser].qtIdNum,
                         [UserModel defaultUser].s_meber,
                         [UserModel defaultUser].recommendUser,
                         [UserModel defaultUser].recommendID, nil];
    
    }
    
}
//MARK: 二维码中间内置图片,可以是公司logo
-(UIImage *)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [[UserModel defaultUser].username dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@""];
    
    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    //设置图片
    return finalyImage;
}

- (void)edit:(UIButton *)sender {
    
    if (([[UserModel defaultUser].group_id integerValue] == 3 || [[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 ) && [UserModel defaultUser].qtIdNum.length != 0) {
        [MBProgressHUD showError:@"已完善资料"];
        return;
    }
    
    if ([[UserModel defaultUser].qtIdNum isEqual:[NSNull null]] || [UserModel defaultUser].qtIdNum == nil) {
        [UserModel defaultUser].qtIdNum = @"";
    }

    [self.navigationController.view addSubview:self.maskV];
    [self.maskV addSubview:self.infoContentV];

    if ([UserModel defaultUser].qtIdNum.length != 0) {
        
        self.infoContentV.qtIDTextF.text = [UserModel defaultUser].qtIdNum;
        self.infoContentV.qtIDTextF.enabled = NO;
    }
    
    if ([[UserModel defaultUser].isHaveOilCard integerValue] == 0) {
        self.infoContentV.oilCardTextF.enabled = NO;
        self.infoContentV.oilCardTextF.placeholder = @"还未开通中石油油卡";
    }else{
        if ([UserModel defaultUser].jyzSelfCardNum.length != 0) {
            
            self.infoContentV.oilCardTextF.text = [UserModel defaultUser].jyzSelfCardNum;
        }
    }

    if([[UserModel defaultUser].hua_status integerValue] == 0){
        
        self.infoContentV.oilCardTextF2.enabled = NO;
        self.infoContentV.oilCardTextF2.placeholder = @"还未开通中石化油卡";
        
    }else{
        
        if ([UserModel defaultUser].hua_card.length != 0) {
            
            self.infoContentV.oilCardTextF2.text = [UserModel defaultUser].hua_card;
        }
        
    }
    _qtNum = self.infoContentV.qtIDTextF.text;
    _youCardNum = self.infoContentV.oilCardTextF.text;
    _huaCardNum = self.infoContentV.oilCardTextF2.text;
    self.infoContentV.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.infoContentV.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
        
    }];
    
}

- (void)modifyQtIdNum:(NSString *)qtIdNum{
  
    if (qtIdNum.length == 0) {
        
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;

    if (qtIdNum.length != 0) {
        
        dict[@"qtIdNum"] = qtIdNum;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kMODIFY_INFO_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
   
        if ([responseObject[@"code"] integerValue]==1) {
            
            [self updateData];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
- (void)addQtIDandOilCardID{
    
//    if ( self.infoContentV.qtIDTextF.text == nil || self.infoContentV.oilCardTextF.text == nil) {
//        [self maskViewTap];
//        
//    }
    if ([_qtNum isEqualToString:self.infoContentV.qtIDTextF.text] && [_huaCardNum isEqualToString:self.infoContentV.oilCardTextF2.text] && [_youCardNum isEqualToString: self.infoContentV.oilCardTextF.text]) {
        [MBProgressHUD showError:@"未做任何修改"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"jyzSelfCardNum"] = self.infoContentV.oilCardTextF.text;
    dict[@"qtIdNum"] = self.infoContentV.qtIDTextF.text;
    dict[@"hua_card"] = self.infoContentV.oilCardTextF2.text;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kMODIFY_INFO_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            [self updateData];
            [self maskViewTap];
        }
        
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
- (void)updateData {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {
        
//        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue]==1) {

            if ([responseObject[@"data"] count] != 0) {
                
                [UserModel defaultUser].jyzSelfCardNum = responseObject[@"data"][@"jyzSelfCardNum"];
                [UserModel defaultUser].qtIdNum = responseObject[@"data"][@"qtIdNum"];
                [UserModel defaultUser].hua_card = responseObject[@"data"][@"hua_card"];
                [UserModel defaultUser].pic = responseObject[@"data"][@"pic"];
                
                
                if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].qtIdNum] rangeOfString:@"null"].location != NSNotFound || responseObject[@"data"][@"qtIdNum"] == nil) {
                    
                    [UserModel defaultUser].qtIdNum = @"";
                }
                if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].jyzSelfCardNum] rangeOfString:@"null"].location != NSNotFound|| responseObject[@"data"][@"jyzSelfCardNum"] == nil) {
                    
                    [UserModel defaultUser].jyzSelfCardNum = @"";
                }
                if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].hua_card] rangeOfString:@"null"].location != NSNotFound|| responseObject[@"data"][@"hua_card"] == nil) {
                    
                    [UserModel defaultUser].hua_card = @"";
                }
                if ([[NSString stringWithFormat:@"%@",[UserModel defaultUser].pic] rangeOfString:@"null"].location != NSNotFound|| responseObject[@"data"][@"pic"] == nil) {
                    
                    [UserModel defaultUser].pic = @"";
                }

                [usermodelachivar achive];
                [self updateInfo];
                [MBProgressHUD showSuccess:@"修改资料成功"];
            }
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }
        [self.tableView reloadData];
    } enError:^(NSError *error) {
//        [_loadV removeloadview];
        
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
#pragma UITextfieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.infoContentV.oilCardTextF || textField == self.infoContentV.oilCardTextF2) {//只能输入数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest){
            [MBProgressHUD showError:@"输入不合法"];
            return NO;
        }
        
    }else if (textField == self.infoContentV.qtIDTextF){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest){
            [MBProgressHUD showError:@"输入不合法"];
            return NO;
        }
    }
    
    return YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return _keyArr.count - 2;
        
    }else{
        
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_PersonInfoCell"];
    cell.selectionStyle = 0;
    cell.index = indexPath.row;
    
    if (indexPath.section == 0) {
        
        cell.titleLabel.text = _keyArr[indexPath.row];
        cell.detailTF.text = _vlaueArr[indexPath.row];
        
        if (indexPath.row == 0 || indexPath.row == 3) {
            
            if (indexPath.row == 0) {
                cell.picImageV.layer.cornerRadius = cell.picImageV.width/2;
                cell.picImageV.clipsToBounds = YES;
                [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
                
                if (!cell.picImageV.image) {
                    cell.picImageV.image = self.picImage;
                    if (self.picImage == nil) {
                        cell.picImageV.image = [UIImage imageNamed:PlaceHolderImage];
                    }
                }
                
            }else{
                cell.picImageV.layer.cornerRadius = 0;
                cell.picImageV.image = [self logoQrCode];
            }
            
            cell.picImageV.hidden = NO;
            cell.detailTF.hidden = YES;
        }else{

            cell.picImageV.hidden = YES;
            cell.detailTF.hidden = NO;
        }

    }else{
        cell.picImageV.hidden = YES;
        cell.detailTF.hidden = NO;
        if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3) {
            cell.titleLabel.text = _keyArr[indexPath.row + 8];
            cell.detailTF.text = _vlaueArr[indexPath.row + 8];
            
        }else if([[UserModel defaultUser].group_id integerValue] == 6){
            
            cell.titleLabel.text = _keyArr[indexPath.row + 10];
            cell.detailTF.text = _vlaueArr[indexPath.row + 10];
        }else{
            
            cell.titleLabel.text = _keyArr[indexPath.row + 11];
            cell.detailTF.text = _vlaueArr[indexPath.row + 11];
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"用相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self getcamera];//获取照相机
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getpicture];//获取相册
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:cameraAction];
        [alertVC addAction:albumAction];
        [alertVC addAction:cancelAction];
        
        //当在ipad里弹出时.需要用到该代码
        UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
        GLMine_PersonInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        popover.sourceView = cell;
        
        popover.sourceRect = cell.bounds;
        
        popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
        [self presentViewController:alertVC animated:YES completion:nil];
    }else if(indexPath.row == 3 && indexPath.section == 0){
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskV];
        [self.maskV addSubview:self.contentV];
        self.contentV.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.2 animations:^{
            self.contentV.transform=CGAffineTransformMakeScale(1, 1);
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0 || indexPath.row == 3) {
            
            return 60;
        }else{
            return 40;
        }
    }else{
        return 40;
    }
}
#pragma mark 调相机 相册
-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        self.picImage = [UIImage imageWithData:data];
        
        //拿到图片准备上传
         NSDictionary *dic;
         dic=@{@"token":[UserModel defaultUser].token ,
               @"uid":[UserModel defaultUser].uid};
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
        manager.requestSerializer.timeoutInterval = 10;
        // 加上这行代码，https ssl 验证。
        [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
        [manager POST:[NSString stringWithFormat:@"%@%@",URL_Base,kUPLOADPIC_URL] parameters:dic  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //将图片以表单形式上传
            
            if (self.picImage) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.png",str];
                NSData *data = UIImagePNGRepresentation(self.picImage);
                [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
            }
            
        }progress:^(NSProgress *uploadProgress){
            
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted status:[NSString stringWithFormat:@"上传中%.0f%%",(uploadProgress.fractionCompleted * 100)]];

            if (uploadProgress.fractionCompleted == 1.0) {
                [SVProgressHUD dismiss];
            }

        }success:^(NSURLSessionDataTask *task, id responseObject) {
            [_loadV removeloadview];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"code"]integerValue]==1) {
                
                [MBProgressHUD showError:dic[@"message"]];
//                [self refresh];
                [self updateData];
            }else{
                [MBProgressHUD showError:dic[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    }
    
    [self.tableView reloadData];

        
    [picker dismissViewControllerAnimated:YES completion:nil];
        
    
}

- (NSMutableArray *)vlaueArr{
    if (!_vlaueArr) {
        _vlaueArr = [[NSMutableArray alloc] init];
        
    }
    return _vlaueArr;
}

- (void)maskViewTap {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentV.transform = CGAffineTransformMakeScale(0.1, 0.00001);
        self.infoContentV.transform = CGAffineTransformMakeScale(0.1, 0.00001);
    } completion:^(BOOL finished) {
        [self.contentV removeFromSuperview];
        [self.infoContentV removeFromSuperview];
        [self.maskV removeFromSuperview];
    }];
    
}

- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskV.backgroundColor = YYSRGBColor(0, 0, 0, 0.2);
        
        UITapGestureRecognizer *maskViewTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
        maskViewTap.delegate = self;
        [_maskV addGestureRecognizer:maskViewTap];
    }
    return _maskV;
}

// 只有点击在mask上才调maskViewTap
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.maskV){
        
        return YES;
        
    }
    
    return NO;
    
}
- (GLMine_PersonInfoCodeView *)contentV{
    if (!_contentV) {
        _contentV = [[NSBundle mainBundle] loadNibNamed:@"GLMine_PersonInfoCodeView" owner:nil options:nil].lastObject;
        
        _contentV.layer.cornerRadius = 5.f;
        
        _contentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 40, 200);
        _contentV.codeImageV.image = [self logoQrCode];
        
    }
    return _contentV;
}
- (GLMine_CompleteInfoView *)infoContentV{
    if (!_infoContentV) {
        _infoContentV = [[NSBundle mainBundle] loadNibNamed:@"GLMine_CompleteInfoView" owner:nil options:nil].lastObject;
        
        _infoContentV.layer.cornerRadius = 5.f;
        
        if ([[UserModel defaultUser].group_id integerValue] == 1 || [[UserModel defaultUser].group_id integerValue] == 2 || [[UserModel defaultUser].group_id integerValue] == 3) {
            
            self.infoContentV.petroChinaViewHeight.constant = 0;
            self.infoContentV.SinopecViewHeight.constant = 0;
            self.infoContentV.youView.alpha = 0;
            self.infoContentV.huaView.alpha = 0;
            self.infoContentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 40, 120);
        }else{
            
            self.infoContentV.frame = CGRectMake(20, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 40, 220);
        }

        [_infoContentV.cancelBtn addTarget:self action:@selector(maskViewTap) forControlEvents:UIControlEventTouchUpInside];
        
        [_infoContentV.okBtn addTarget:self action:@selector(addQtIDandOilCardID) forControlEvents:UIControlEventTouchUpInside];
        
        _infoContentV.oilCardTextF.delegate = self;
        _infoContentV.qtIDTextF.delegate = self;
        _infoContentV.oilCardTextF2.delegate = self;
        
    }
    return _infoContentV;
}
@end
