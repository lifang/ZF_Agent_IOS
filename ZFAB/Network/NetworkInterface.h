//
//  NetworkInterface.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NetworkRequest.h"

typedef enum {
    RequestTokenOverdue = -3,   //token失效
//    RequestShortInventory = -2, //库存不足
    RequestFail = -1,           //请求错误
    RequestSuccess = 1,         //请求成功
}RequestCode;

typedef enum {
    AgentTypeNone = 0,
    AgentTypeCompany,     //公司
    AgentTypePerson,      //个人
}AgentType; //代理商类型

typedef enum {
    SupplyGoodsNone = 0,
    SupplyGoodsWholesale,    //批购
    SupplyGoodsProcurement,  //代购
}SupplyGoodsType;

typedef enum {
    OrderStatusAll = -1,
    OrderStatusUnPaid = 1,//未付款
    OrderStatusPaid,      //已付款
    OrderStatusSend,      //已发货
    OrderStatusReview,    //已评价
    OrderStatusCancel,    //已取消
    OrderStatusClosed,    //交易关闭
}OrderStatus;

typedef enum {
    OrderTypeAll = -1,
    OrderTypeUserBuy,          //用户订购
    OrderTypeUserRent,         //用户租赁
    OrderTypeAgentProcurement, //代理商代购
    OrderTypeAgentRent,        //代理商代租赁
    OrderTypeWholesale,        //代理商批购
}OrderType;

typedef enum {
    OrderFilterNone = -1,
    OrderFilterDefault,       //商品默认排序
    OrderFilterSales,         //销量排序
    OrderFilterPriceDown,     //价格降序
    OrderFilterPriceUp,       //价格升序
    OrderFilterScore,         //评分排序
}OrderFilter;

typedef enum {
    TradeTypeNone = -1,
    TradeTypeTransfer = 1,    //转账
    TradeTypeRepayment,       //还款
    TradeTypeConsume,         //消费
    TradeTypeLife,            //生活充值
    TradeTypeTelephoneFare,   //话费充值
}TradeType;

typedef enum {
    CSTypeNone = 0,
    CSTypeAfterSale,   //售后单记录
    CSTypeUpdate,      //更新资料记录
    CSTypeCancel,      //注销记录
}CSType;

//1.登录
static NSString *s_login_method = @"agent/agentLogin";

//2.注册
static NSString *s_register_method = @"agent/userRegistration";

//4.发送手机验证码——找回密码
static NSString *s_sendValidate_method = @"agent/sendPhoneVerificationCode";

//5.邮箱验证——找回密码
static NSString *s_emailValidate_method = @"agent/sendEmailVerificationCode";

//6.找回密码
static NSString *s_findPassword_method = @"agent/updatePassword";

//7.注册图片上传
static NSString *s_uploadRegisterImage_method = @"agent/uploadFile";

//31.用户管理——获取用户列表
static NSString *s_userList_method = @"user/getUser";

//32.用户管理——删除用户
static NSString *s_userDelete_method = @"user/delectAgentUser";

//33.用户管理——获取终端
static NSString *s_userTerminal_method = @"user/getTerminals";

//34.商品搜索条件
static NSString *s_goodSearch_method = @"good/search";

//35.商品列表
static NSString *s_goodList_method = @"good/list";

//36.商品详细
static NSString *s_goodDetail_method = @"good/goodinfo";

//40.库存管理列表
static NSString *s_stockList_method = @"stock/list";

//41.库存管理重命名
static NSString *s_stockRename_method = @"stock/rename";

//42.库存管理详情——下级代理商列表
static NSString *s_stockDetail_method = @"stock/info";

//43.库存管理详情——下级代理商终端列表
static NSString *s_stockTerminal_method = @"stock/terminallist";

//55.交易流水——获取终端
static NSString *s_tradeTerminalList_method = @"trade/record/getTerminals";

//60.我的消息——列表
static NSString *s_messageList_method = @"message/receiver/getAll";

//61.我的消息——详情
static NSString *s_messageDetail_method = @"message/receiver/getById";

//62.我的消息——单个删除
static NSString *s_messageSingleDelete_method = @"message/receiver/deleteById";

//63.我的消息——批量删除
static NSString *s_messageMultiDelete_method = @"message/receiver/batchDelete";

//64.我的消息——批量已读
static NSString *s_messageMultiRead_method = @"message/receiver/batchRead";

//80.我的信息——获取详情
static NSString *s_personDetail_method = @"agents/getOne";

//81.我的信息——获取修改手机验证码
static NSString *s_modifyPhoneValidate_method = @"agents/getUpdatePhoneDentcode";

//82.我的信息——修改手机
static NSString *s_modifyPhone_method = @"agents/updatePhone";

//83.我的信息——获取修改邮箱验证码
static NSString *s_modifyEmailValidate_method = @"agents/getUpdateEmailDentcode";

//84.我的信息——修改邮箱
static NSString *s_modifyEmail_method = @"agents/updateEmail";

@interface NetworkInterface : NSObject

/*!
 @abstract 1.登录
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @result finish  请求回调结果
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish;

/*!
 @abstract 2.注册
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @param agentType     1.公司  2.个人
 @param companyName   公司名称
 @param licenseID     公司营业执照号
 @param taxID         公司税务证号
 @param legalPersonName  负责人姓名
 @param legalPersonID    负责人身份证号
 @param mobileNumber     手机
 @param email            邮箱
 @param cityID        城市id
 @param address       详细地址
 @param cardImagePath    身份证照片
 @param licenseImagePath 营业执照照片
 @param taxImagePath     税务证照片
 @result finish  请求回调结果
 */
+ (void)registerWithUsername:(NSString *)username
                    password:(NSString *)password
            isAlreadyEncrypt:(BOOL)encrypt
                   agentType:(AgentType)agentType
                 companyName:(NSString *)companyName
                   licenseID:(NSString *)licenseID
                       taxID:(NSString *)taxID
             legalPersonName:(NSString *)legalPersonName
               legalPersonID:(NSString *)legalPersonID
                mobileNumber:(NSString *)mobileNumber
                       email:(NSString *)email
                      cityID:(NSString *)cityID
               detailAddress:(NSString *)address
               cardImagePath:(NSString *)cardImagePath
            licenseImagePath:(NSString *)licenseImagePath
                taxImagePath:(NSString *)taxImagePath
                    finished:(requestDidFinished)finish;

/*!
 @abstract 4.手机验证码
 @param mobileNumber  手机号
 @result finish  请求回调结果
 */
+ (void)sendValidateWithMobileNumber:(NSString *)mobileNumber
                            finished:(requestDidFinished)finish;

/*!
 @abstract 5.邮箱验证
 @param email  邮箱
 @result finish  请求回调结果
 */
+ (void)sendEmailValidateWithEmail:(NSString *)email
                          finished:(requestDidFinished)finish;

/*!
 @abstract 6.找回密码
 @param username      用户名
 @param password      密码
 @param validateCode  验证码
 @result finish  请求回调结果
 */
+ (void)findPasswordWithUsername:(NSString *)username
                        password:(NSString *)password
                    validateCode:(NSString *)validateCode
                        finished:(requestDidFinished)finish;

/*!
 @abstract 7.上传图片
 @param image       图片
 @result finish  请求回调结果
 */
+ (void)uploadRegisterImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish;

/*!
 @abstract 31.用户管理——获取用户列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getUserListWithAgentID:(NSString *)agentID
                         token:(NSString *)token
                      finished:(requestDidFinished)finish;

/*!
 @abstract 32.用户管理——删除用户
 @param agentID  代理商id
 @param token    登录返回
 @param userID   删除用户的id
 @result finish  请求回调结果
 */
+ (void)deleteUserWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                       userID:(NSString *)userID
                     finished:(requestDidFinished)finish;

/*!
 @abstract 33.用户管理——获取用户终端
 @param token    登录返回
 @param userID   用户id
 @result finish  请求回调结果
 */
+ (void)getUserTerminalListWithUserID:(NSString *)userID
                                token:(NSString *)token
                             finished:(requestDidFinished)finish;
/*!
 @abstract 34.商品搜索条件
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)getGoodSearchInfoWithCityID:(NSString *)cityID
                           finished:(requestDidFinished)finish;

/*!
 @abstract 35.商品列表
 @param cityID      城市ID
 @param agentID     代理商ID
 @param supplyType  1.批购 2.代购
 @param filterType  排序类型
 @param brandID     POS机品牌ID
 @param category    POS机类型
 @param channelID   支付通道
 @param cardID      支付卡类型
 @param tradeID     支持交易类型
 @param slipID      签单方式
 @param date        对账日期
 @param maxPrice    最高价
 @param minPrice    最低价
 @param keyword     搜索关键字
 @param rent        是否只支持租赁
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getGoodListWithCityID:(NSString *)cityID
                      agentID:(NSString *)agentID
                   supplyType:(SupplyGoodsType)supplyType
                     sortType:(OrderFilter)filterType
                      brandID:(NSArray *)brandID
                     category:(NSArray *)category
                    channelID:(NSArray *)channelID
                    payCardID:(NSArray *)cardID
                      tradeID:(NSArray *)tradeID
                       slipID:(NSArray *)slipID
                         date:(NSArray *)date
                     maxPrice:(CGFloat)maxPrice
                     minPrice:(CGFloat)minPrice
                      keyword:(NSString *)keyword
                     onlyRent:(BOOL)rent
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 36.商品详细
 @param cityID      城市ID
 @param agentID     代理商ID
 @param goodID      商品ID
 @param supplyType  1.批购 2.代购
 @result finish  请求回调结果
 */
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                        agentID:(NSString *)agentID
                         goodID:(NSString *)goodID
                     supplyType:(SupplyGoodsType)supplyType
                       finished:(requestDidFinished)finish;

/*!
 @abstract 40.库存管理列表
 @param agentID     代理商ID
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getStockListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract 41.库存管理重命名
 @param agentID     代理商ID
 @param token    登录返回
 @param goodID   商品id
 @param goodName 商品名
 @result finish  请求回调结果
 */
+ (void)renameStockGoodWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                            goodID:(NSString *)goodID
                          goodName:(NSString *)goodName
                          finished:(requestDidFinished)finish;

/*!
 @abstract 42.库存管理详情——下级代理商列表
 @param agentID     代理商ID
 @param token    登录返回
 @param channelID   支付通道ID
 @param goodID   商品ID
 @param agentName   代理商名称
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getStockDetailWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        channelID:(NSString *)channelID
                           goodID:(NSString *)goodID
                        agentName:(NSString *)agentName
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish;

/*!
 @abstract 43.库存管理详情——下级代理商终端列表
 @param agentID     代理商ID
 @param token    登录返回
 @param channelID   支付通道ID
 @param goodID   商品ID
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getStockTerminalWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                          channelID:(NSString *)channelID
                             goodID:(NSString *)goodID
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish;

/*!
 @abstract 55.交易流水获取终端列表
 @param token    登录返回
 @param agentID  代理商id
 @result finish  请求回调结果
 */
+ (void)getTradeTerminalListWithAgentID:(NSString *)agentID
                                  token:(NSString *)token
                               finished:(requestDidFinished)finish;

/*!
 @abstract 60.我的消息列表
 @param agentID  代理商id
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMyMessageListWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish;

/*!
 @abstract 61.我的消息详情
 @param agentID  代理商id
 @param token    登录返回
 @param messageID  消息id
 @result finish  请求回调结果
 */
+ (void)getMyMessageDetailWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                            messageID:(NSString *)messageID
                             finished:(requestDidFinished)finish;

/*!
 @abstract 62.我的消息单删
 @param agentID  代理商id
 @param token    登录返回
 @param messageID  消息id
 @result finish  请求回调结果
 */
+ (void)deleteSingleMessageWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                             messageID:(NSString *)messageID
                              finished:(requestDidFinished)finish;

/*!
 @abstract 63.我的消息多删
 @param agentID  代理商id
 @param token    登录返回
 @param messageIDs  消息id数组
 @result finish  请求回调结果
 */
+ (void)deleteMultiMessageWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           messageIDs:(NSArray *)messageIDs
                             finished:(requestDidFinished)finish;

/*!
 @abstract 64.我的消息批量已读
 @param agentID  代理商id
 @param token    登录返回
 @param messageIDs  消息id数组
 @result finish  请求回调结果
 */
+ (void)readMultiMessageWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                         messageIDs:(NSArray *)messageIDs
                           finished:(requestDidFinished)finish;

/*!
 @abstract 80.我的信息——获取详情
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPersonDetailWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish;

/*!
 @abstract 81.我的信息——获取修改手机验证码
 @param agentID  代理商id
 @param token    登录返回
 @param phoneNumber  手机号
 @result finish  请求回调结果
 */
+ (void)getPersonModifyMobileValidateWithAgentID:(NSString *)agentID
                                           token:(NSString *)token
                                     phoneNumber:(NSString *)phoneNumber
                                        finished:(requestDidFinished)finish;

/*!
 @abstract 82.我的信息——修改手机
 @param agentID  代理商id
 @param token    登录返回
 @param phoneNumber  新手机号码
 @param validate  验证码
 @result finish  请求回调结果
 */
+ (void)modifyPersonMobileWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                       newPhoneNumber:(NSString *)phoneNumber
                             validate:(NSString *)validate
                             finished:(requestDidFinished)finish;

/*!
 @abstract 83.我的信息——获取修改邮箱验证码
 @param agentID  代理商id
 @param token    登录返回
 @param email    邮箱
 @result finish  请求回调结果
 */
+ (void)getPersonModifyEmailValidateWithAgentID:(NSString *)agentID
                                          token:(NSString *)token
                                          email:(NSString *)email
                                       finished:(requestDidFinished)finish;

/*!
 @abstract 84.我的信息——修改邮箱
 @param agentID  代理商id
 @param token    登录返回
 @param email    新邮箱
 @param validate 验证码
 @result finish  请求回调结果
 */
+ (void)modifyPersonEmailWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            newEmail:(NSString *)email
                            validate:(NSString *)validate
                            finished:(requestDidFinished)finish;

@end
