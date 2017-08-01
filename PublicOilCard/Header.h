//
//  Header.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define timea 0.3f

#define YYSRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define TABBARTITLE_COLOR YYSRGBColor(255, 80, 0 , 1.0) //导航栏颜色
#define autoSizeScaleX (SCREEN_WIDTH/320.f)
#define autoSizeScaleY (SCREEN_HEIGHT/568.f)

#define ADAPT(x) SCREEN_WIDTH / 375 *(x)

///接口
//192.168.0.191  本地
//www.jcgy.cn.com  公司服务器
//http://api.51qmtg.org/index.php/App/  阿里云
#define URL_Base @"https://api.51qmtg.org/index.php/App/"
//#define URL_Base @"http://api.51qmtg.org/index.php/App/"

#define kLOGIN_URL @"User/login" //登录

#define kREGISTER_URL @"User/register" //注册

#define kGET_CODE_URL @"User/get_yzm" //获取验证码
#define kENSURE_CODE_URL @"User/check_yzm" //验证验证码

#define kGET_CITYLIST_URL @"User/getCityList" //城市列表

#define kREFRESH_URL @"User/refresh" //刷新

#define kINFO_BQ @"User/userInfoBq" //信息补全

#define kSHOP_Main_URL  @"ShopInfo/shop_index"//商城首页

#define kSHOP_DETAIL_URL @"ShopInfo/goods_info"//商品详情

#define kSHOP_BUYNOW_URL @"ShopInfo/buy_order"//立即购买

#define kSHOP_DEL_COLLECT_URL @"UserInfo/del_collect"//删除收藏

#define kSHOP_ADD_COLLECT_URL @"UserInfo/collec_add"//添加收藏

#define kSHOPINFO_UPLOAD_URL @"ShopInfo/app_order_line"//上传凭证

#define kSHOPINFO_ORDERLIST_URL @"ShopInfo/line_list"//凭证列表

#define kMODIFY_INFO_URL @"UserInfo/user_info_in"//修改个人信息

#define kUPLOADPIC_URL @"UserInfo/save_picture"//上传图片

#define kUPDATEPWD_URL @"UserInfo/upd_pwd"//修改密码

#define kDELEGATEINFO_URL @"UserInfo/upgrade_user"//升级个人招商总管界面信息

#define kEXCHANGE_URL @"UserInfo/back_operate"//兑换接口

#define kEXCHANGELIST_URL @"UserInfo/mark_list"//兑换记录列表

#define kEXCHANGEINFO_URL @"UserInfo/sel_user"//兑换界面信息

#define kINFOLIST_URL @"User/msg_list"//消息列表

#define kCOLLECTEIONLIST_URL @"UserInfo/collec_list"//收藏列表

#define kORDERLIST_URL @"UserInfo/order_list"//线上订单列表

#define kOrderList_OffLine_URL @"ShopInfo/l_list"//线下订单列表

#define kDEL_ORDER_URL @"UserInfo/del_order"//删除线上订单

#define kDEL_OFFLINE_ORDER_URL @"ShopInfo/del_l"//删除线下订单

#define kCANCEL_ORDER_URL @"UserInfo/cancel_order"//取消定单

#define kRECOMMENDLIST_URL @"UserInfo/groom_list"//推荐列表

#define kOPEN_UNDER_URL @"UserInfo/open_under"//开同下级

#define kRELATIONSHIPLIST_URL @"UserInfo/bz_groom_list"//关系 列表

#define kORDER_PAY_URL @"ShopInfo/order_pay"//订单支付

#define kOPENCARD_URL @"UserInfo/operate_card"//开卡

#define kUPGRADE_URL @"UserInfo/upgrade"//升级成个代

#define kConsumeList_URL @"ShopInfo/list_line"//消费记录

#define kREWORDLIST_URL @"UserInfo/user_msg_log"//奖励记录

#define kCOUNT_URL @"User/main_buy"//代理商网体内消费统计

#define kDETAIL_URL @"User/line_deta"//代理商网体会员消费详情

#define kPay_OffLine_URL @"ShopInfo/o_line"//线下支付(商品)

#define kPayDelegate_OffLine_URL @"User/agent_apply"//线下支付(代理商申请)

#define kCheckID @"UserInfo/code_name"//验证会员是否存在

//分享推荐注册
#define kRECOMMEND_URL @"https://api.51qmtg.org/CMcard/index.php/Wap/Index/index.html?username="
//下载地址
#define DOWNLOAD_URL @"https://itunes.apple.com/cn/app/id1256847817?mt=8"
//获取appStore上的最新版本号地址
#define GET_VERSION  @"https://itunes.apple.com/lookup?id=1256847817"
//关于公司网址
#define ABOUTUS_URL @"https://api.51qmtg.org/youka/about.html"
//注册协议
#define REGISTER_URL @"https://api.51qmtg.org/youka/agreement.html"
//开卡协议
#define kOPENCARD_DELEGATE_URL @"https://api.51qmtg.org/youka/protocol.html"
//公告
//#define NOTICE_URL @"https://www.51dztg.com/index.php/Home/Newsdemo/newestnotice.html"
//个人招商总管首期招商总管
#define Retailer @"4"
//会员
#define OrdinaryUser @"6"
//二期招商总管
#define TWODELEGATE @"5"
////首期招商总管
//#define ONEDELEGATE @"4"
//经理
#define MANAGER @"3"
//总监
#define DIRECTOR @"2"
//部长
#define MINISTER @"1"

#define PlaceHolderImage @"picnodata"
#define LUNBO_PlaceHolder @"轮播占位图"
#define kGOODS_PlaceHolder @"产品占位图"

//http://dzgx.joshuaweb.cn/index.php/Home/Regist/index.html

#define UMSHARE_APPKEY @"58cf31dcf29d982906001f63"
//微信分享
#define WEIXI_APPKEY @"wxf482af02a200da8e"
#define WEIXI_SECRET @"487532cd8355a7ae06f44d5abe2486ba"
//微博分享
#define WEIBO_APPKEY @"3040295141"
#define WEIBO_SECRET @"3e3728b874c9f207cefb043cf418e6a4"
//友盟分享 AppKey
#define USHARE_DEMO_APPKEY @"594b286765b6d607f3000f9a"

//公钥RSA
#define public_RSA @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC14XtGpmuHCYlu7dgLbr8hoYNh6d8XRNY+pHulx/F+hMmOsPRX0HWZOTeFCpG11t9lVRQEcQdm587EyiUDiHEL7yrFPEnJ2Dlce55GrSSCP4IpEyH06gudK3O56t8AC02LSD9nrJ4e6WrGrPaahQVfvJBz4v+NSfvAao/xFthVlwIDAQAB"

#define NMUBERS @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"


#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

//3%返利的宏
#define KThreePersent @"4"

//支付宝appid
#define AlipayAPPID @"2017061907523362"

#endif /* Header_h */
