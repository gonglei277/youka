//
//  GLMine_updateManagerController.m
//  PublicOilCard
//
//  Created by 龚磊 on 2017/6/15.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_updateManagerController.h"
#import "GLMine_updateManagerModel.h"
#import "GLMine_updateNewCell.h"
#import "LBMineCenterPayPagesViewController.h"
#import "GLPay_OfflineController.h"

@interface GLMine_updateManagerController ()<UITableViewDelegate,UITableViewDataSource,GLMine_updateNewCellDelegate>
{
    
    NSMutableArray *_tempArr;
    BOOL _isCheckAll;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@property (nonatomic, strong)NSMutableArray *tempArr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic,strong)NodataView *nodataV;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, assign)NSInteger page;//页数

@property (nonatomic, copy)NSString *status;//审核状态  0未审核 1审核成功  2审核失败
@property (nonatomic, copy)NSString *upgrade;//升级类型 1首期招商总管   2二期招商总管
@property (nonatomic, copy)NSString *is_pay;//是否支付
@end

@implementation GLMine_updateManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"升级管理";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_updateNewCell" bundle:nil] forCellReuseIdentifier:@"GLMine_updateNewCell"];
    self.noticeLabel.text = @"        会员升级为招商总管，首先会员需是本系统会员资格方可申请，当会员在本系统商城购买商品并成功付款后，会员将自动升级为本系统的招商总管资格，系统将开通招商总管所享有的相关权益政策。";
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"updateManagerNotification" object:nil];
    
}
- (void)refresh {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    [NetworkManager requestPOSTWithURLStr:kDELEGATEINFO_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        if ([responseObject[@"code"] integerValue]==1) {
            //判空以及赋值
            if ([responseObject[@"data"][@"msg"] isEqual:[NSNull null]]) {
                self.dataArr = @[];
            }else{
                
                self.dataArr = responseObject[@"data"][@"msg"];
            }
            if ([responseObject[@"data"][@"status"] isEqual:[NSNull null]]) {
                self.status = @"";
            }else{
                
                self.status = responseObject[@"data"][@"status"];
            }
            if ([responseObject[@"data"][@"upgrade"] isEqual:[NSNull null]]) {
                self.upgrade = @"";
            }else{
                
                self.upgrade = responseObject[@"data"][@"upgrade"];
            }
            self.is_pay = responseObject[@"data"][@"is_pay"];
            
            if ([responseObject[@"data"] count] == 0 && self.dataArr.count != 0) {
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [self endRefresh];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}
- (void)updateData:(BOOL)status {
    if (status) {
        
        self.page = 1;
        [self.models removeAllObjects];
        
    }else{
        _page ++;
        
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"page"] = [NSString stringWithFormat:@"%zd",self.page];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    [NetworkManager requestPOSTWithURLStr:kDELEGATEINFO_URL paramDic:dict finish:^(id responseObject) {
        [self endRefresh];
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue]==1) {
            //判空以及赋值
            if ([responseObject[@"data"][@"msg"] isEqual:[NSNull null]]) {
                self.dataArr = @[];
            }else{
                
                self.dataArr = responseObject[@"data"][@"msg"];
            }
            if ([responseObject[@"data"][@"status"] isEqual:[NSNull null]]) {
                self.status = @"";
            }else{
                
                self.status = responseObject[@"data"][@"status"];
            }
            if ([responseObject[@"data"][@"upgrade"] isEqual:[NSNull null]]) {
                self.upgrade = @"";
            }else{
                
                self.upgrade = responseObject[@"data"][@"upgrade"];
            }
            self.is_pay = responseObject[@"data"][@"is_pay"];
            
            if ([responseObject[@"data"] count] == 0 && self.dataArr.count != 0) {
                
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

#pragma GLMine_updateNewDelegate
//开通招商总管
- (void)open:(NSInteger)index{
    
    self.hidesBottomBarWhenPushed = YES;
//    LBMineCenterPayPagesViewController *pay = [[LBMineCenterPayPagesViewController alloc] init];
    GLPay_OfflineController *pay = [[GLPay_OfflineController alloc] init];
    
    if (index == 0) {
        if ([self.upgrade integerValue] == 1) {
            
            if([self.status integerValue] == 0 ){
                [MBProgressHUD showError:@"首期招商总管资格正在审核中"];
                return;
            }else if([self.status integerValue] == 1){
                [MBProgressHUD showError:@"已开通首期招商总管"];
                return;
            }else if([self.status integerValue] == 2){
                pay.upgrade = 1;
            }else{
                pay.upgrade = 1;
            }
        }else if([self.upgrade integerValue] == 2){
            [MBProgressHUD showError:@"正在办理二期招商总管,暂不能办理首期招商总管"];
            return;
        }else{
             pay.upgrade = 1;
        }
       
    }else{
        if([self.upgrade integerValue] == 2){
            
            if([self.status integerValue] == 0){
                [MBProgressHUD showError:@"二期招商总管资格正在审核中"];
                return;
            }else if([self.status integerValue] == 1){
                [MBProgressHUD showError:@"已开通二期招商总管"];
                return;
            }else if([self.status integerValue] == 2){
                pay.upgrade = 2;
            }else{
                pay.upgrade = 2;

            }
        }else if([self.upgrade integerValue] == 1){
            [MBProgressHUD showError:@"正在办理首期招商总管,暂不能办理二期招商总管"];
            return;
        }else{
             pay.upgrade = 2;
        }
     
    }
    pay.pushIndex = 3;//表示从升级管理跳转的
    
    [self.navigationController pushViewController:pay animated:YES];

}

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.dataArr.count == 0){
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden =YES;
    }
    
    return self.dataArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_updateNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_updateNewCell"];
    cell.titleLabel.text = self.dataArr[indexPath.row][@"title"];
    cell.contentLabel.text = self.dataArr[indexPath.row][@"right"];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.selectionStyle = 0;

    if (indexPath.row == 1) {
        cell.hidden = YES;
    }
    
    switch ([self.status integerValue]) {
        case 0://未审核
        {
            if(([self.upgrade integerValue] - 1) == indexPath.row){
                
                [cell.openBtn setTitle:@"审核中" forState:UIControlStateNormal];
                [cell.openBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                
            }else{
                [cell.openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
                [cell.openBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.openBtn.hidden = YES;
            }
            
        }
            break;
        case 1://审核成功
        {
            if(([self.upgrade integerValue] - 1) == indexPath.row){
                
                [cell.openBtn setTitle:@"已办理" forState:UIControlStateNormal];
                [cell.openBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else{
                [cell.openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
                [cell.openBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.openBtn.hidden = YES;

            }
        }
            break;
        case 2://审核失败
        {
            if(([self.upgrade integerValue] - 1) == indexPath.row){
                
                [cell.openBtn setTitle:@"重新开通" forState:UIControlStateNormal];
                [cell.openBtn setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
            }else{
                
                [cell.openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
                [cell.openBtn setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
                cell.openBtn.hidden = YES;
            }
            
        }
            break;
        default:
        {
            [cell.openBtn setTitle:@"立即开通" forState:UIControlStateNormal];
            [cell.openBtn setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
            cell.openBtn.hidden = NO;
        }
            break;
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return self.tableView.rowHeight;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [[NSMutableArray alloc] init];
    }
    return _models;
}

@end
