//
//  GLMine_RecommendController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RecommendController.h"
#import "GLMine_RecommendRecordController.h"
#import <UShareUI/UShareUI.h>

@interface GLMine_RecommendController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageV;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticezLabel2;

@property (weak, nonatomic) IBOutlet UILabel *noticeContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@end

@implementation GLMine_RecommendController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"推荐";
    //自定义右键
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"记录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self  action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 80, 40);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

    self.noticeLabel.text = @"分享推广注册须知";
    self.noticeContentLabel.text = @"  本二维码为个人分享推广码，新会员安装系统APP后方可扫码注册，扫码注册时须使用APP内的扫描功能键（注：微信及支付宝等扫描不能注册)";
    self.noticezLabel2.text = @"  点击长按即可分享APP安装地址给微信、朋友圈、新浪好友，新会员点击下载安装APP系统，即能安装成功。";
    self.codeImageV.image = [self logoQrCode];
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT);
    NSDictionary *attributesDict = @{NSFontAttributeName:FONT(12)};
    CGRect subviewRect = [self.noticeContentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil];
    CGRect subviewRect2 = [self.noticezLabel2.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil];
    self.contentViewWidth.constant = SCREEN_WIDTH;
    self.contentViewHeight.constant = 500 + subviewRect.size.height + subviewRect2.size.height;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)shareTo:(UILongPressGestureRecognizer *)longesture {
    if (longesture.state == UIGestureRecognizerStateBegan) {

        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
        
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType];
            
        }];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用全民油卡App" descr:@"零售成品油、成品油储油卡系统开发与推广、成品油储油卡发行与推广，欢迎下载" thumImage:[UIImage imageNamed:@"logo-80"]];
    //设置网页地址
    shareObject.webpageUrl = DOWNLOAD_URL;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
    
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {

            }
        }
       
    }];
}

//MARK: 二维码中间内置图片,可以是公司logo
-(UIImage *)logoQrCode{
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [[NSString stringWithFormat:@"%@%@",kRECOMMEND_URL,[UserModel defaultUser].username] dataUsingEncoding:NSUTF8StringEncoding];
    
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
    UIImage *sImage = [UIImage imageNamed:@"车马店图"];
    
    CGFloat sImageW = 70;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)record {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_RecommendRecordController *recordVC = [[GLMine_RecommendRecordController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
@end
