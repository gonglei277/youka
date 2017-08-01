//
//  GLMine_OrderController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_OrderController.h"
#import "GLMine_CollectCell.h"
#import "GLMine_OrderSectionHeader.h"
#import "LBWaitOrdersListModel.h"
#import "LBMineCenterPayPagesViewController.h"

@interface GLMine_OrderController ()<UITableViewDelegate,UITableViewDataSource,GLMine_OrderSectionHeaderDelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sectionModels;
@property (nonatomic, strong)NSMutableArray *models;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation GLMine_OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _page=1;
     [self.tableView addSubview:self.nodataV];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_CollectCell" bundle:nil] forCellReuseIdentifier:@"GLMine_CollectCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_OrderSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"GLMine_OrderSectionHeader"];
    
    [self initdatasource];//网络请求
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       [weakSelf footerrefresh];
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
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


-(void)initdatasource{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kORDERLIST_URL paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"page" :[NSNumber numberWithInteger:self.page]} finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"code"] integerValue]==1) {
            
            if (_refreshType == NO) {
                [self.sectionModels removeAllObjects];
            }
            
            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                for (int i = 0; i < [responseObject[@"data"] count]; i++) {
                    
                    GLMine_OrderSectionModel *orderMode = [[GLMine_OrderSectionModel alloc]init];
                    
                    orderMode.order_num = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"order_num"]];
                    orderMode.user_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"user_name"]];
                    orderMode.realy_price = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"realy_price"]];
                    orderMode.addtime = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"addtime"]];
                    orderMode.total = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"total"]];
                    orderMode.order_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"order_status"]];
                    orderMode.sh_status = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"sh_status"]];
                    orderMode.order_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"order_id"]];
                    orderMode.isExpanded = NO;
                    for (int j =0; j < [responseObject[@"data"][i][@"goods"]count]; j++) {
                        LBWaitOrdersListModel   *listmodel = [LBWaitOrdersListModel mj_objectWithKeyValues:responseObject[@"data"][i][@"goods"][j]];
                        [orderMode.dataArr addObject:listmodel];
                    }
                    
                    [self.sectionModels addObject:orderMode];
                }
            }
                    
        }
        else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        [self.tableView reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.sectionModels.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.sectionModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GLMine_OrderSectionModel *model=self.sectionModels[section];
    return model.isExpanded?model.dataArr.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_CollectCell"];
    cell.selectionStyle = 0;
    
    GLMine_OrderSectionModel *model = self.sectionModels[indexPath.section];
    cell.WaitOrdersListModel = model.dataArr[indexPath.row];
    cell.countLabel.hidden = NO;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GLMine_OrderSectionHeader *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GLMine_OrderSectionHeader"];

    headerview.delegete = self;
    headerview.section = section;
    headerview.expandCallback = ^(BOOL isExpanded) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    headerview.sectionModel = self.sectionModels[section];
    return headerview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

#pragma mark == GLMine_OrderSectionHeaderDelegete

-(void)orderpay:(NSInteger)section{
    GLMine_OrderSectionModel *sectionModel = self.sectionModels[section];
    LBWaitOrdersListModel   *listmodel = sectionModel.dataArr[0];
    if ([sectionModel.order_status isEqualToString:@"0"]) {//去支付
        self.hidesBottomBarWhenPushed = YES;
        LBMineCenterPayPagesViewController *vc = [[LBMineCenterPayPagesViewController alloc]init];
        vc.order_id = sectionModel.order_id;
        vc.order_num = sectionModel.order_num;
        vc.addtime = sectionModel.addtime;
        vc.realy_price = sectionModel.realy_price;
        vc.pushIndex = 1;
        vc.goods_id = listmodel.goods_id;
        vc.goods_num = listmodel.goods_num;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//删除订单
        [self deleteOrder:section];
    }

}
/**
 *删除订单
 */
-(void)deleteOrder:(NSInteger)section{

    GLMine_OrderSectionModel *sectionModel = self.sectionModels[section];
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kDEL_ORDER_URL paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"order_id":sectionModel.order_id } finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            [self.sectionModels removeObjectAtIndex:section];
            [self.tableView reloadData];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

-(void)orderCancel:(NSInteger)section{

    GLMine_OrderSectionModel *sectionModel = self.sectionModels[section];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCANCEL_ORDER_URL paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"order_id":sectionModel.order_id } finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            
            [MBProgressHUD showError:responseObject[@"message"]];
            sectionModel.order_status = @"3";
            [self.tableView reloadData];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];

}

#pragma  懒加载
- (NSMutableArray *)sectionModels{
    if (!_sectionModels) {
        _sectionModels = [[NSMutableArray alloc] init];
        
    }
    return _sectionModels;
}
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
        
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    }
    return _nodataV;
    
}
@end
