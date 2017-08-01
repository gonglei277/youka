//
//  GLMine_UploadRecordController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_UploadRecordController.h"
#import "GLMine_UploadRecordCell.h"
#import "GLMine_UploadController.h"
#import "formattime.h"

@interface GLMine_UploadRecordController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger page;//页数
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@end

@implementation GLMine_UploadRecordController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.title = @"凭证记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_UploadRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_UploadRecordCell"];
    
//    //设置渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)YYSRGBColor(255, 80, 0, 1).CGColor,(__bridge id)YYSRGBColor(246, 109, 2, 1).CGColor];
    //    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.locations = @[@0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.type = kCAGradientLayerAxial;
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = self.navView.bounds;
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.navView.bounds];
    [backgroundView.layer addSublayer:gradientLayer];
    
    [self.navView insertSubview:backgroundView atIndex:0];

    
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf updateData:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:NO];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self updateData:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"UploadSuccessfulNotification" object:nil];
    
}
- (void)refreshUI{
    [self updateData:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        [self.dataArr removeAllObjects];
        
    }else{
        _page ++;
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = [NSString stringWithFormat:@"%zd",self.page];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kSHOPINFO_ORDERLIST_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == 1) {
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    [self.dataArr addObject:dic];
                }
                
                if ([responseObject[@"data"] count] == 0 && self.dataArr.count != 0) {
                    
                    [MBProgressHUD showError:responseObject[@"message"]];
                }
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
    }];
    
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    }
    return _nodataV;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (IBAction)upload:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_UploadController *uploadVC = [[GLMine_UploadController alloc] init];
    [self.navigationController pushViewController:uploadVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataArr.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_UploadRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_UploadRecordCell"];
    cell.selectionStyle = 0;
    
    cell.moneyLabel.text = [NSString stringWithFormat:@"金额:%@",self.dataArr[indexPath.row][@"order_money"]];

    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[formattime formateTime:self.dataArr[indexPath.row][@"addtime"]]];
    
    if ([self.dataArr[indexPath.row][@"type"] integerValue] == 1) {
        
        cell.typeLabel.text = @"中石油";
    }else{
        cell.typeLabel.text = @"中石化";
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark 懒加载
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
