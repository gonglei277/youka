//
//  GLHome_jifenRecordController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/7/19.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHome_jifenRecordController.h"
#import "GLHome_JifenRecordCell.h"
#import "GLHome_jifenSectionModel.h"
#import "GLHome_jifenHeaderView.h"

@interface GLHome_jifenRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;//页数
@property (nonatomic, strong)NSArray *dataArr;

@end

@implementation GLHome_jifenRecordController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.type == 1) {
        self.navigationItem.title = @"即时积分记录";
    }else if(self.type == 2){
        self.navigationItem.title = @"余额记录";
    }else if(self.type == 3){
        self.navigationItem.title = @"普通积分记录";
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_JifenRecordCell" bundle:nil] forCellReuseIdentifier:@"GLHome_JifenRecordCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLHome_jifenHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"GLHome_jifenHeaderView"];

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
    dict[@"type"] = [NSString stringWithFormat:@"%zd",self.type];
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kREWORDLIST_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            if([responseObject[@"data"] count] != 0){
                
                for (NSDictionary *dict in responseObject[@"data"]) {
                    
                    GLHome_jifenSectionModel *model = [[GLHome_jifenSectionModel alloc] init];
                    
                    model.money = dict[@"money"];
                    model.time = dict[@"time"];
                    model.type = dict[@"type"];
                    model.isExpanded = NO;
                    
                    for (NSDictionary *dic in dict[@"log_list"]) {
                        
                        [model.log_listArr addObject:dic[@"content"]];
                        
                    }
                    [self.models addObject:model];
                }
                
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else if([responseObject[@"code"] integerValue] == 3){
             if(self.dataArr.count != 0) {
                
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
-(NodataView*)nodataV{
    
    if (!_nodataV) {
        _nodataV=[[NSBundle mainBundle]loadNibNamed:@"NodataView" owner:self options:nil].firstObject;
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return _nodataV;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.models.count > 0 ) {
        
        self.nodataV.hidden = YES;
    }else{
        self.nodataV.hidden = NO;
        
    }
    
    return self.models.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GLHome_jifenSectionModel *model=self.models[section];
    return model.isExpanded?model.log_listArr.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLHome_JifenRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLHome_JifenRecordCell"];
    
    GLHome_jifenSectionModel *model = self.models[indexPath.section];
    cell.reasonLabel.text = model.log_listArr[indexPath.row];
    
//    if([[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"time"]] rangeOfString:@"null"].location != NSNotFound){
//        cell.dateLabel.text = @"";
//    }else{
//        
//        cell.dateLabel.text = self.dataArr[indexPath.row][@"time"];
//    }
//    
//    if (self.type == 1) {
//        
//        cell.sumLabel.text = [NSString stringWithFormat:@"积分: +%@",self.dataArr[indexPath.row][@"money"]];
//    }else{
//        cell.sumLabel.text = [NSString stringWithFormat:@"余额: +%@",self.dataArr[indexPath.row][@"money"]];
//    }
//    
//    if([self.dataArr[indexPath.row][@"money"] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"money"]] rangeOfString:@"null"].location != NSNotFound ){
//        
//        cell.hidden = YES;
//    }else{
//        cell.hidden = NO;
//    }
    cell.selectionStyle = 0;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GLHome_jifenHeaderView *headerView =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GLHome_jifenHeaderView"];
//    headerView.delegete = self;
    headerView.section = section;
    headerView.expandCallback = ^(BOOL isExpanded) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    headerView.sectionModel = self.models[section];
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    if ([self.dataArr[indexPath.row][@"money"] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"money"]] rangeOfString:@"null"].location != NSNotFound ) {
//        return 0;
//    }
    
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 44;
    
    return tableView.rowHeight;
}


#pragma mark 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
