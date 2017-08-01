//
//  GLMine_ExchangeRecord_FailController.m
//  PublicOilCard
//
//  Created by 四川三君科技有限公司 on 2017/6/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ExchangeRecord_FailController.h"
#import "GLMine_ExchangeRecordCell.h"
#import "recordeManger.h"

@interface GLMine_ExchangeRecord_FailController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataarr;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation GLMine_ExchangeRecord_FailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_ExchangeRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_ExchangeRecordCell"];
    
    self.page = 1;
    self.refreshType = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView addSubview:self.nodataV];
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    [self initdatasource];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(filterExtensionCategories) name:@"filterExtensionCategories" object:nil];

}
//筛选
-(void)filterExtensionCategories{
    
    [self initdatasource];
    
}
-(void)initdatasource{
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kEXCHANGELIST_URL paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page] ,@"status":@"0",@"back_type":[recordeManger defaultUser].recordeType} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                [self.dataarr addObjectsFromArray:responseObject[@"data"]];
            }
            if([responseObject[@"data"] count] == 0){
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            [self.tableView reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if([responseObject[@"data"] count] == 0){
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.tableView reloadData];
            
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasource];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataarr.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    return self.dataarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_ExchangeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_ExchangeRecordCell"];
    cell.selectionStyle = 0;
    cell.timelb.text = [formattime formateTime:[NSString stringWithFormat:@"%@",self.dataarr[indexPath.row][@"addtime"]]];
    if ([self.dataarr[indexPath.row][@"back_type"] integerValue] == 0) {
        cell.typelb.text = @"RMB";
    }else{
        cell.typelb.text = @"积分";
    }
    
    cell.moemylb.text = [NSString stringWithFormat:@"¥%@",self.dataarr[indexPath.row][@"back_money"]];
    cell.reasonLabel.text = [NSString stringWithFormat:@"失败理由:%@",self.dataarr[indexPath.row][@"fail_reason"]];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    return self.tableView.rowHeight;}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
    
}


@end
