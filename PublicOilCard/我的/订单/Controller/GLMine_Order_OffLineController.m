//
//  GLMine_Order_OffLineController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Order_OffLineController.h"
#import "GLMine_Order_OffLineCell.h"
#import "GLMine_Order_OffLineModel.h"

@interface GLMine_Order_OffLineController ()<GLMine_Order_OffLineCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *models;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为1
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NodataView *nodataV;

@end

@implementation GLMine_Order_OffLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_Order_OffLineCell" bundle:nil] forCellReuseIdentifier:@"GLMine_Order_OffLineCell"];
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
 
}

- (void)updateData:(BOOL)status {
    if (status) {
        self.page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"page"] = [NSString stringWithFormat:@"%zd",self.page];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kOrderList_OffLine_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            for (NSDictionary * dic in responseObject[@"data"]) {
                GLMine_Order_OffLineModel *model = [GLMine_Order_OffLineModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
            }
            
            if ([responseObject[@"data"] count] == 0 && self.models.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)deleteOrder:(NSInteger)index{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除订单" message:@"确定删除该订单吗?" preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GLMine_Order_OffLineModel *model = self.models[index];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"lid"] = model.lid;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        
        [NetworkManager requestPOSTWithURLStr:kDEL_OFFLINE_ORDER_URL paramDic:dict finish:^(id responseObject) {
            [self endRefresh];
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue]==1) {
                [self updateData:YES];
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [self endRefresh];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.models.count != 0) {
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
    }
    
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Order_OffLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_Order_OffLineCell"];
    cell.model = self.models[indexPath.row];
    cell.index = indexPath.row;
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_Order_OffLineModel *model = self.models[indexPath.row];
    if ([model.status integerValue] == 1) {
        
        return 224;
    }else{
        return 174;
    }

}

#pragma  懒加载

- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
        
    }
    return _models;
}
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return _nodataV;
    
}

@end
