//
//  GLMine_RelationshipController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RelationshipController.h"
//#import "GLMine_RecommendRecordCell.h"
#import "GLMine_RelationshipHeader.h"
#import "GLMine_RelationshipCell.h"

@interface GLMine_RelationshipController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;//页数

@end

@implementation GLMine_RelationshipController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"关系";
//   [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_RecommendRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_RecommendRecordCell"];
    [self.tableView registerClass:[GLMine_RelationshipHeader class] forHeaderFooterViewReuseIdentifier:@"GLMine_RelationshipHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_RelationshipCell" bundle:nil] forCellReuseIdentifier:@"GLMine_RelationshipCell"];
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
    dict[@"group_id"] = [UserModel defaultUser].group_id;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kRELATIONSHIPLIST_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            for (NSDictionary * dic in responseObject[@"data"]) {
                GLMine_RelationshipModel *model = [GLMine_RelationshipModel mj_objectWithKeyValues:dic];
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
#pragma UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.models.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GLMine_RelationshipModel *model = self.models[section];
    return model.isExpanded?1:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMine_RelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_RelationshipCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.section];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GLMine_RelationshipHeader * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"GLMine_RelationshipHeader"];
    
    headerView.sectionModel = self.models[section];
    
    headerView.expandCallback = ^(BOOL isExpanded) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma  懒加载

- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
//        for (int i = 0; i < 3; i ++) {
//            GLMine_RelationshipModel *model = [[GLMine_RelationshipModel alloc] init];
//            model.IDNum = [NSString stringWithFormat:@"AB11221212 %d",i];
//            model.name = [NSString stringWithFormat:@"梁朝伟 %d",i];
//            model.date = [NSString stringWithFormat:@"2017-06-%d",i];
//            model.subordinateNum = [NSString stringWithFormat:@"1%d",i];
//            model.memberNum = [NSString stringWithFormat:@"2%d",i];
//            model.firstDelegateNum = [NSString stringWithFormat:@"3%d",i];
//            model.secondDelegateNum = [NSString stringWithFormat:@"4%d",i];
//            
//            [_models addObject:model];
//        }
    }
    return _models;
}
@end
