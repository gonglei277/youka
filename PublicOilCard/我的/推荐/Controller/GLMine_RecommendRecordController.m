//
//  GLMine_RecommendRecordController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_RecommendRecordController.h"
#import "GLMine_RecommendRecordCell.h"
#import "QQPopMenuView.h"
//#import "GLMine_SpendingController.h"

@interface GLMine_RecommendRecordController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;//页数
@property (nonatomic, assign)NSInteger type;//

@end

@implementation GLMine_RecommendRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推荐记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.type = 0;
    //右键自定义
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 44);
    [rightBtn setImage:[UIImage imageNamed:@"筛选更多"] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)
    [rightBtn addTarget:self action:@selector(filte) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_RecommendRecordCell" bundle:nil] forCellReuseIdentifier:@"GLMine_RecommendRecordCell"];
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
    
    [NetworkManager requestPOSTWithURLStr:kRECOMMENDLIST_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            for (NSDictionary * dic in responseObject[@"data"]) {
                GLMine_RecommendRecordModel *model = [GLMine_RecommendRecordModel mj_objectWithKeyValues:dic];
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

//筛选
-(void)filte{
    __weak typeof(self) weakself = self;
    
    QQPopMenuView *popview = [[QQPopMenuView alloc]initWithItems:@[@{@"title":@"非会员",@"imageName":@""}, @{@"title":@"会员",@"imageName":@""},@{@"title":@"首期招商总管",@"imageName":@""},@{@"title":@"二期招商总管",@"imageName":@""}] width:110 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-30, 64+5) action:^(NSInteger index) {
        
        self.type = index;
        [weakself updateData:YES];
    }];
    popview.isHideImage = YES;
    
    [popview show];
    
}

#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.models.count == 0) {
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_RecommendRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_RecommendRecordCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    self.hidesBottomBarWhenPushed = YES;
//    GLMine_SpendingController *spendVC = [[GLMine_SpendingController alloc] init];
//    [self.navigationController pushViewController:spendVC animated:YES];
//
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

#pragma 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}
@end
