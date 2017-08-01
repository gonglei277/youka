//
//  GLMine_InfoController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_InfoController.h"
#import "GLMine_InfoCell.h"

@interface GLMine_InfoController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, assign)NSInteger page;//页数

@end

@implementation GLMine_InfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"消息";
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_InfoCell" bundle:nil] forCellReuseIdentifier:@"GLMine_InfoCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
    /**
     *清空消息
     */
    //    //自定义右键
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(delAllMessage) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(13, 60, 13, 0)];
    btn.frame = CGRectMake(0, 0, 80, 44);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

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
- (void)delAllMessage {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"消息" message:@"你确定要删除所有消息吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:@"UserInfo/del_log" paramDic:dict finish:^(id responseObject) {
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue]==1) {
                [self.models removeAllObjects];
                [MBProgressHUD showSuccess:responseObject[@"message"]];
            }else{
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
            [self.tableView reloadData];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [self endRefresh];
            [MBProgressHUD showError:error.localizedDescription];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    

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
    
    [NetworkManager requestPOSTWithURLStr:kINFOLIST_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            if(![responseObject[@"data"] isEqual:[NSNull null]]){
                
                for (NSDictionary * dic in responseObject[@"data"]) {
                    GLMine_InfoModel *model = [GLMine_InfoModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                }
                
                if ([responseObject[@"data"] count] == 0 && self.models.count != 0) {
                    
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
        _nodataV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114-49);
    }
    return _nodataV;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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
    GLMine_InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_InfoCell"];
    cell.selectionStyle = 0;
    cell.model = self.models[indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
}
#pragma 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}
@end
