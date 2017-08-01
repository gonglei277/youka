//
//  GLMall_GoodsDetailController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_GoodsDetailController.h"
#import "GLMall_GoodsHeaderView.h"
#import "GLMallHomeCell.h"
#import "LBMineCenterPayPagesViewController.h"
#import "JZAlbumViewController.h"
#import "GLPay_OfflineController.h"

@interface GLMall_GoodsDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate,GLMall_GoodsHeaderViewDelegate>
{
    NSInteger _sum;//商品购买数量
    GLMall_GoodsHeaderView *_header;
}

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property(assign , nonatomic)CGFloat headerImageHeight;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NSDictionary *dataDic;
@property (nonatomic, assign)NSInteger page;//页数
@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)NSString *isCollection;//是否收藏
@property (nonatomic, strong)NSString *collect_id;//收藏id
@end

@implementation GLMall_GoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buyBtn.layer.cornerRadius = 5.f;
    self.navigationItem.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerImageHeight = 180 *autoSizeScaleY;
    self.isCollection =@"0";
    self.collect_id = @"";
    //设置layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 -5, 224);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    
    _sum = 1;

    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMall_GoodsHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLMall_GoodsHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GLMallHomeCell" bundle:nil] forCellWithReuseIdentifier:@"GLMallHomeCell"];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;
    
    [self updateData:YES];
    
}

- (void)updateData:(BOOL)status {
    
    if (status) {
        
        self.page = 1;
        [self.models removeAllObjects];
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([UserModel defaultUser].loginstatus == YES) {
        dict[@"uid"] = [UserModel defaultUser].uid;
    }
    dict[@"goods_id"] = self.goods_id;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kSHOP_DETAIL_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            if([responseObject[@"data"] count] != 0){
                self.dataDic = responseObject[@"data"][@"goods_details"];
                self.isCollection = responseObject[@"data"][@"collect"];
                self.collect_id = responseObject[@"data"][@"collect_id"];
                
                for (NSDictionary * dic in responseObject[@"data"][@"guess_goods"]) {
                    
                    GLMallHomeGoodsModel *model = [GLMallHomeGoodsModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
            }
            if ([responseObject[@"data"] count] == 0 && self.models.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.collectionView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
}

-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//立即购买
- (IBAction)buyNow:(id)sender {
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    if ([[UserModel defaultUser].isHaveOilCard integerValue] == 0 && [[UserModel defaultUser].hua_status integerValue] == 0 ) {
        [MBProgressHUD showError:@"请先开卡"];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    
    GLPay_OfflineController *payOffVC = [[GLPay_OfflineController alloc] init];
    
    payOffVC.goods_name = self.dataDic[@"goods_name"];
    payOffVC.realy_price = [NSString stringWithFormat:@"%.2f",[self.dataDic[@"discount"] floatValue] * _sum];
    payOffVC.goods_num = [NSString stringWithFormat:@"%zd",_sum];
    payOffVC.goods_id = self.dataDic[@"goods_id"];
    payOffVC.pushIndex = self.pushIndex;

    [self.navigationController pushViewController:payOffVC animated:YES];
    
//    LBMineCenterPayPagesViewController *payVC = [[LBMineCenterPayPagesViewController alloc] init];
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    
//    dict[@"uid"] = [UserModel defaultUser].uid;
//    dict[@"token"] = [UserModel defaultUser].token;
//    dict[@"user_name"] = [UserModel defaultUser].username;
//    dict[@"group_id"] = [UserModel defaultUser].group_id;
//    dict[@"goods_id"] = self.dataDic[@"goods_id"];
//    dict[@"goods_num"] = [NSString stringWithFormat:@"%zd",_sum];
//    
//    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:kSHOP_BUYNOW_URL paramDic:dict finish:^(id responseObject) {
//        
//        [_loadV removeloadview];
//        
//        if ([responseObject[@"code"] integerValue]==1) {
//            
//            payVC.addtime =[NSString stringWithFormat:@"%@", responseObject[@"data"][@"addtime"]];
//            payVC.order_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"order_id"]];
//            payVC.order_num = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"order_num"]];
//            payVC.realy_price = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"realy_price"]];
//            payVC.goods_name = self.dataDic[@"goods_name"];
//            payVC.pushIndex = 1;
//            payVC.goods_id = self.dataDic[@"goods_id"];
//            payVC.goods_num = [NSString stringWithFormat:@"%zd",_sum];
//            [self.navigationController pushViewController:payVC animated:YES];
//        }else{
//            
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//    } enError:^(NSError *error) {
//        [_loadV removeloadview];
//        [MBProgressHUD showError:error.localizedDescription];
//    }];
//
}

//收藏
- (void)collect:(UIButton *)collectionbt {
    if ([UserModel defaultUser].loginstatus == NO) {
        [MBProgressHUD showError:@"请先登录"];
        return;
    }
    if ([self.isCollection integerValue] == 1) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"collect_id"] = self.collect_id;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kSHOP_DEL_COLLECT_URL paramDic:dict finish:^(id responseObject) {
            [self endRefresh];
            [_loadV removeloadview];
            
            if ([responseObject[@"code"]integerValue] == 1) {
                [collectionbt setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
                self.isCollection = @"0";
                if (self.pushIndex == 2) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteTheCollectionCellNotification" object:nil];
                }
                [MBProgressHUD showError:@"取消收藏成功"];
            }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
        
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"goods_id"] = self.goods_id;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kSHOP_ADD_COLLECT_URL paramDic:dict finish:^(id responseObject) {
            [self endRefresh];
            [_loadV removeloadview];
            [MBProgressHUD showError:responseObject[@"message"]];
            
            if ([responseObject[@"code"]integerValue] == 1) {
                [collectionbt setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
                self.isCollection = @"1";
                self.collect_id = responseObject[@"data"];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    }


}

//取到购买数量
-(void)changeNum:(NSString *)text{
    
    _sum = [text  integerValue];
    
}
#pragma UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.models.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMallHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GLMallHomeCell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMallHomeGoodsModel *model = self.models[indexPath.row];
    self.goods_id = model.goods_id;
    [self updateData:YES];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    _header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GLMall_GoodsHeaderView" forIndexPath:indexPath];
    NSMutableAttributedString *str;
    if (self.dataDic) {
        
        NSString *attrStr = self.dataDic[@"goods_info"];
        attrStr = [attrStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符
        
        NSString *strone = [NSString stringWithFormat:@"[%@]",attrStr];
        long len1 = [strone length];
        NSString *strtwo = [NSString stringWithFormat:@"[%@] %@",attrStr,self.dataDic[@"goods_name"]];
        str = [[NSMutableAttributedString alloc]initWithString:strtwo];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,len1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,len1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(len1 ,strtwo.length - len1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(len1 ,strtwo.length - len1)];
    }
    
    _header.detailTextView.textContainerInset = UIEdgeInsetsZero;
    _header.detailTextView.textContainer.lineFragmentPadding = 0;

    if (self.dataDic != nil) {
        
        if(self.dataDic[@"goods_info"] == nil){
            
            _header.detailTextView.text = self.dataDic[@"goods_name"];
            
        }else{
            
            _header.detailTextView.attributedText = str;
        }
    }

    if([self.dataDic[@"discount"] isEqual:[NSNull null]] || self.dataDic[@"discount"] == nil){
        _header.priceLabel.text = @"¥0";
    }else{
        
        _header.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.dataDic[@"discount"]];
    }
    
    if([self.dataDic[@"salenum"] isEqual:[NSNull null]]|| self.dataDic[@"salenum"] == nil){
        _header.countLabel.text = @"总销量:0";
    }else{
    
        _header.countLabel.text = [NSString stringWithFormat:@"总销量:%@",self.dataDic[@"salenum"]];
    }
    
    if([self.dataDic[@"goods_num"] isEqual:[NSNull null]]|| self.dataDic[@"goods_num"] == nil){
        _header.stockLabel.text = @"库存:0";
    }else{
        _header.stockLabel.text = [NSString stringWithFormat:@"库存:%@",self.dataDic[@"goods_num"]];
    }
    
    _header.stockNum = self.dataDic[@"goods_num"];
    _header.delegate = self;
    
    if ([self.isCollection integerValue] == 1) {
        [_header.collectionBt setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateNormal];
    }else{
        [_header.collectionBt setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    }
    _header.middleViewTop.constant = _headerImageHeight;
    if (self.dataDic != nil) {
        if (![self.dataDic[@"banner"] isEqual:[NSNull null]]) {
            
            NSMutableArray *bannerM = [NSMutableArray array];
            for (NSString *banner in self.dataDic[@"banner"]) {
                [bannerM addObject:banner];
            }
            self.cycleScrollView.imageURLStringsGroup = bannerM;
        }else{
            self.cycleScrollView.imageURLStringsGroup = @[];
        }
    }
    [_header addSubview:self.cycleScrollView];
    
    return _header;
}
#pragma mark -- SDCycleScrollViewDelegate 点击看大图
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    JZAlbumViewController *jzAlbumVC = [[JZAlbumViewController alloc]init];
    jzAlbumVC.currentIndex =index;//这个参数表示当前图片的index，默认是0
    jzAlbumVC.imgArr = [self.cycleScrollView.imageURLStringsGroup copy];//图片数组，可以是url，也可以是UIImage
    [self presentViewController:jzAlbumVC animated:NO completion:nil];
    
}
-(SDCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headerImageHeight)
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:LUNBO_PlaceHolder]];
        
        _cycleScrollView.localizationImageNamesGroup = @[LUNBO_PlaceHolder];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
        _cycleScrollView.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页 右下角
        _cycleScrollView.titleLabelBackgroundColor = YYSRGBColor(241, 242, 243, 1);// 图片对应的标题的 背景色。（因为没有设标题）
        _cycleScrollView.placeholderImage = [UIImage imageNamed:LUNBO_PlaceHolder];
        _cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
    }
    
    return _cycleScrollView;
    
}
// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {

    NSMutableAttributedString *str;
    if (self.dataDic) {
        
        NSString *attrStr = self.dataDic[@"goods_info"];
        attrStr = [attrStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        
        NSString *strone = [NSString stringWithFormat:@"[%@]",attrStr];
        long len1 = [strone length];
        NSString *strtwo = [NSString stringWithFormat:@"[%@] %@",attrStr,self.dataDic[@"goods_name"]];
        str = [[NSMutableAttributedString alloc]initWithString:strtwo];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,len1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,len1)];
    }

    CGSize titleSize = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil].size;

    CGRect textViewFrame = _header.detailTextView.frame;
    textViewFrame.size.height = titleSize.height;
    _header.detailTextView.frame = textViewFrame;
    
    return CGSizeMake(SCREEN_WIDTH, textViewFrame.size.height + _headerImageHeight + 140);
}

#pragma 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}

@end
