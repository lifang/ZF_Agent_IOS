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
    RequestShortInventory = -2, //库存不足
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
    OrderTypeProcurement = -1,      //不传默认查询3，4
    OrderTypeProcurementBuy = 3,    //代理商代购
    OrderTypeProcurementRent,       //代理商代租赁
    OrderTypeWholesale,            //代理商批购
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

typedef enum {
    OpenApplyNone = 0,
    OpenApplyPublic,    //对公
    OpenApplyPrivate,   //对私
}OpenApplyType;  //开通类型

typedef enum {
    AddressNone = 0,
    AddressDefault,    //默认地址
    AddressOther,      //非默认地址
}AddressType;

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
static NSString *s_uploadRegisterImage_method = @"agent/upload/register";

//8 9.申请开通——申请开通列表
static NSString *s_applyList_method = @"apply/searchApplyList";

//10.申请开通——进入开通申请
static NSString *s_applyDetail_method = @"apply/getApplyDetails";

//11.申请开通——获取商户
static NSString *s_applyMerchantDetail_method = @"apply/getMerchant";

//12.申请开通——获取支付通道
static NSString *s_channelList_method = @"apply/getChannels";

//13.申请开通——选择银行
static NSString *s_bank_method = @"apply/chooseBank";

//15.申请开通——添加申请信息
static NSString *s_openApply_method = @"apply/addOpeningApply";

//16.申请开通——图片上传
static NSString *s_uploadApplyImage_method = @"apply/upload/tempOpenImg";

//17.申请开通——查看终端详情
static NSString *s_terminalDetail_method = @"terminal/getApplyDetails";

//18.申请开通——获取商户列表
static NSString *s_merchantList_method = @"terminal/getMerchants";

//20.终端管理——获取终端列表
static NSString *s_terminalList_method = @"terminal/getTerminalList";

//26.终端管理——添加用户
static NSString *s_addUser_method = @"terminal/addCustomer";

//27.终端管理——绑定终端
static NSString *s_bindingTerminal_method = @"terminal/bindingTerminals";

//28.终端管理——申请售后根据终端号筛选
static NSString *s_TMSearchUseTerminal_method = @"terminal/batchTerminalNum";

//29.终端管理——POS机筛选根据支付通道
static NSString *s_TMSearchUseChannel_method = @"terminal/screeningTerminalNum";

//30.终端管理——POS机
static NSString *s_TMSearchPOS_method = @"terminal/screeningPosName";

//31.终端管理——支付通道
static NSString *s_TMsearchChannel_method = @"terminal/getChannels";

//33.终端管理——提交申请售后
static NSString *s_TMSubmitApply_mehtod = @"terminal/submitAgent";

//34.用户管理——获取用户列表
static NSString *s_userList_method = @"user/getUser";

//35.用户管理——删除用户
static NSString *s_userDelete_method = @"user/delectAgentUser";

//36.用户管理——获取终端
static NSString *s_userTerminal_method = @"user/getTerminals";

//37.商品搜索条件
static NSString *s_goodSearch_method = @"good/search";

//38.商品列表
static NSString *s_goodList_method = @"good/list";

//39.商品详细
static NSString *s_goodDetail_method = @"good/goodinfo";

//40.支付通道详细
static NSString *s_channelDetail_method = @"paychannel/info";

//41.评论列表
static NSString *s_commentList_method = @"comment/list";

//42.创建订单
static NSString *s_createOrder_method = @"order/agent";

//43.库存管理列表
static NSString *s_stockList_method = @"stock/list";

//44.库存管理重命名
static NSString *s_stockRename_method = @"stock/rename";

//45.库存管理详情——下级代理商列表
static NSString *s_stockDetail_method = @"stock/info";

//46.库存管理详情——下级代理商终端列表
static NSString *s_stockTerminal_method = @"stock/terminallist";

//47.选择代理商
static NSString *s_subAgent_method = @"preparegood/getsonagent";

//48.配货列表
static NSString *s_prepareGoodList_method = @"preparegood/list";

//49.配货详情
static NSString *s_prepareGoodDetail_method = @"preparegood/info";

//50.配货POS列表
static NSString *s_prepareGoodPOS_method = @"preparegood/getgoodlist";

//51.配货支付通道列表
static NSString *s_prepareGoodChannel_method = @"preparegood/getpaychannellist";

//52.配货筛选终端
static NSString *s_prepareGoodFilter_method = @"preparegood/getterminalslist";

//53.配货
static NSString *s_prepareGood_method = @"preparegood/add";

//54.调货列表
static NSString *s_transferGoodList_method = @"exchangegood/list";

//55.调货详情
static NSString *s_transferGoodDetail_method = @"exchangegood/info";

//57.调货
static NSString *s_transferGood_method = @"exchangegood/add";

//58.交易流水——获取终端
static NSString *s_tradeTerminalList_method = @"trade/record/getTerminals";

//59.交易流水——获取代理商列表
static NSString *s_tradeAgentList_method = @"trade/record/getAgents";

//60.交易流水——查询交易流水
static NSString *s_tradeRecord_method = @"trade/record/getTradeRecords";

//61.交易流水——交易流水详情
static NSString *s_tradeDetail_method = @"trade/getTradeRecord";

//62.交易流水——统计交易流水
static NSString *s_tradeStatist_method = @"trade/getTradeStatistics";

//63.我的消息——列表
static NSString *s_messageList_method = @"message/receiver/getAll";

//64.我的消息——详情
static NSString *s_messageDetail_method = @"message/receiver/getById";

//65.我的消息——单个删除
static NSString *s_messageSingleDelete_method = @"message/receiver/deleteById";

//66.我的消息——批量删除
static NSString *s_messageMultiDelete_method = @"message/receiver/batchDelete";

//67.我的消息——批量已读
static NSString *s_messageMultiRead_method = @"message/receiver/batchRead";

//68.订单管理——列表
static NSString *s_orderList_method = @"order/orderSearch";

//69.订单管理——批购详情
static NSString *s_orderDetailWholesale_method = @"order/getWholesaleById";

//70.订单管理——批购取消订单
static NSString *s_orderCancelWholesale_method = @"order/cancelWholesale";

//72.订单管理——代购详情
static NSString *s_orderDetailProcurement_method = @"order/getProxyById";

//73.订单管理——代购取消订单
static NSString *s_orderCancelProcurement_method = @"order/cancelProxy";

//74.售后记录——售后单列表
static NSString *s_afterSaleList_method = @"cs/agents/search";

//75.售后记录——售后单取消申请
static NSString *s_afterSaleCancel_method = @"cs/agents/cancelApply";

//76.售后记录——售后单详情
static NSString *s_afterSaleDetail_method = @"cs/agents/getById";

//77.售后记录——注销记录列表
static NSString *s_cancelList_method = @"cs/cancels/search";

//78.售后记录——注销记录取消申请
static NSString *s_cancelCancel_method = @"cs/cancels/cancelApply";

//79.售后记录——注销记录重新提交
static NSString *s_cancelApply_mehtod = @"cs/cancels/resubmitCancel";

//80.售后记录——注销记录详情
static NSString *s_cancelDetail_method = @"cs/cancels/getCanCelById";

//81.售后记录——更新资料列表
static NSString *s_updateList_method = @"update/info/search";

//82.售后记录——更新资料详情
static NSString *s_updateDetail_method = @"update/info/getInfoById";

//83.售后记录——更新资料取消申请
static NSString *s_updateCancel_method = @"update/info/cancelApply";

//84.我的信息——获取详情
static NSString *s_personDetail_method = @"agents/getOne";

//85.我的信息——获取修改手机验证码
static NSString *s_modifyPhoneValidate_method = @"agents/getUpdatePhoneDentcode";

//86.我的信息——修改手机
static NSString *s_modifyPhone_method = @"agents/updatePhone";

//87.我的信息——获取修改邮箱验证码
static NSString *s_modifyEmailValidate_method = @"agents/getUpdateEmailDentcode";

//88.我的信息——修改邮箱
static NSString *s_modifyEmail_method = @"agents/updateEmail";

//89.我的信息——修改密码
static NSString *s_modifyPassword_method = @"agents/updatePassword";

//90.我的信息——地址列表
static NSString *s_addressList_method = @"agents/getAddressList";

//91.我的信息——新增地址
static NSString *s_addressAdd_method = @"agents/insertAddress";

//92.我的信息——删除地址
static NSString *s_addressDelete_method = @"agents/batchDeleteAddress";

//92.a.我的信息——更新收货地址
static NSString *s_addressUpdate_method = @"agents/updateAddress";

//92.下级代理商管理——列表
static NSString *s_subAgentList_method = @"lowerAgent/list";

//93.下级代理商管理——详情
static NSString *s_subAgentDetail_method = @"lowerAgent/info";

//94.下级代理商管理——创建
static NSString *s_subAgentCreate_method = @"lowerAgent/createNew";

//95.下级代理商管理——设置默认分润
static NSString *s_subAgentDefaultBenefit_method = @"lowerAgent/changeProfit";

//96.下级代理商管理——获取分润列表
static NSString *s_subAgentBenefitList_method = @"lowerAgent/getProfitlist";

//97.下级代理商管理——设置分润
static NSString *s_subAgentBenefitSet_method = @"lowerAgent/saveOrEdit";

//98.下级代理商管理——删除分润
static NSString *s_subAgentBenefitDelete_method = @"lowerAgent/delChannel";

//99.下级代理商管理——获取支付通道列表
static NSString *s_subAgentChannelList_method = @"lowerAgent/getChannellist";

//100.下级代理商管理——上传图片
static NSString *s_subAgentUpload_method = @"lowerAgent/uploadImg";

//101.员工管理——列表
static NSString *s_customerList_method = @"customerManage/getList";

//102.员工管理——详情
static NSString *s_customerDetail_method = @"customerManage/getInfo";

//103.员工管理——创建
static NSString *s_customerCreate_method = @"customerManage/insert";

//104.员工管理——删除
static NSString *s_customerSingleDelete_method = @"customerManage/deleteOne";

//105.员工管理——多删
static NSString *s_customerMultiDelete_method = @"customerManage/deleteAll";

//106.员工管理——修改
static NSString *s_customerModify_method = @"customerManage/edit";

//下级代理商管理——根据支付通道获取消费类型
static NSString *s_subAgentTradeList_method = @"lowerAgent/getTradelist";

//下级代理商管理——获取默认分润
static NSString *s_subAgentGetDefault_method = @"lowerAgent/getDefaultProfit";

//首页轮播
static NSString *s_homeImageList_method = @"index/sysshufflingfigure";

//订单信息
static NSString *s_orderConfirm_method = @"order/payOrder";

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
 @abstract 8 9.申请开通——申请开通列表
 @param token    登录返回
 @param agentID   代理商id
 @param keyword   关键字
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getApplyListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                        keyword:(NSString *)keyword
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract 10.申请开通——进入开通申请
 @param agentID  代理商id
 @param token    登录返回
 @param terminalNumber    终端id
 @param applyType   对公 对私
 @result finish  请求回调结果
 */
+ (void)beginToApplyWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                     terminalID:(NSString *)terminalID
                  openApplyType:(OpenApplyType)applyType
                       finished:(requestDidFinished)finish;

/*!
 @abstract 11.申请开通——商户详情
 @param token    登录返回
 @param merchantID   商户id
 @result finish  请求回调结果
 */
+ (void)getMerchantDetaikWithToken:(NSString *)token
                        merchantID:(NSString *)merchantID
                          finished:(requestDidFinished)finish;

/*!
 @abstract 12.申请开通——获取支付通道
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getChannelListWithToken:(NSString *)token
                       finished:(requestDidFinished)finish;

/*!
 @abstract 13.申请开通——选择银行
 @param token    登录返回
 @param keyword  关键字
 @result finish  请求回调结果
 */
+ (void)getBankListWithToken:(NSString *)token
                     keyword:(NSString *)keyword
                    finished:(requestDidFinished)finish;

/*!
 @abstract 15.提交申请
 @param token       登录返回
 @param paramList   参数数组
 @result finish  请求回调结果
 */
+ (void)submitApplyWithToken:(NSString *)token
                      params:(NSArray *)paramList
                    finished:(requestDidFinished)finish;

/*!
 @abstract 16.申请开通——上传图片
 @param image       图片
 @param terminalID  终端ID
 @result finish  请求回调结果
 */
+ (void)uploadApplyImageWithImage:(UIImage *)image
                       terminalID:(NSString *)terminalID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 17.申请开通——查看终端详情
 @param token    登录返回
 @param terminalID 终端id
 @result finish  请求回调结果
 */
+ (void)getTerminalDetailWithToken:(NSString *)token
                        terminalID:(NSString *)terminalID
                          finished:(requestDidFinished)finish;

/*!
 @abstract 18.申请开通——获取商户列表
 @param agentID     代理商ID
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMerchantListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;

/*!
 @abstract 20.终端管理——获取终端列表
 @param agentID     代理商ID
 @param token    登录返回
 @param keyword  终端号关键字
 @param status   状态
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTerminalListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                           keyword:(NSString *)keyword
                            status:(int)status
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;

/*!
 @abstract 26.终端管理——添加用户
 @param agentID     代理商ID
 @param token    登录返回
 @param name     用户名
 @param password 密码
 @param codeNumber   验证码
 @param cityID   城市id
 @result finish  请求回调结果
 */
+ (void)addUserWithAgentID:(NSString *)agentID
                     token:(NSString *)token
                  username:(NSString *)name
                  password:(NSString *)password
                codeNumber:(NSString *)codeNumber
                    cityID:(NSString *)cityID
                  finished:(requestDidFinished)finish;

/*!
 @abstract 27.终端管理——绑定终端
 @param token    登录返回
 @param userID   选择用户的id
 @param terminalNumber  终端号
 @result finish  请求回调结果
 */
+ (void)bindingTerminalWithToken:(NSString *)token
                          userID:(NSString *)userID
                  terminalNumber:(NSString *)terminalNumber
                        finished:(requestDidFinished)finish;

/*!
 @abstract 28.终端管理——申请售后根据终端号筛选
 @param token    登录返回
 @param terminalList  终端号数组
 @result finish  请求回调结果
 */
+ (void)getTerminalManagerTerminalWithToken:(NSString *)token
                               terminalList:(NSArray *)terminalList
                                   finished:(requestDidFinished)finish;

/*!
 @abstract 29.终端管理——根据支付通道查询
 @param token    登录返回
 @param terminalList  终端号数组
 @result finish  请求回调结果
 */
+ (void)getTerminalManagerUseChannelWithToken:(NSString *)token
                                     posTitle:(NSString *)posTitle
                                    channelID:(NSString *)channelID
                                     maxPrice:(CGFloat)maxPrice
                                     minPrice:(CGFloat)minPrice
                                     finished:(requestDidFinished)finish;

/*!
 @abstract 30.终端管理——POS机列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getTerminalManagerPOSListWithAgent:(NSString *)agentID
                                     token:(NSString *)token
                                  finished:(requestDidFinished)finish;

/*!
 @abstract 31.终端管理——支付通道
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getTerminalManagerChannelListWithToken:(NSString *)token
                                      finished:(requestDidFinished)finish;

/*!
 @abstract 33.终端管理——提交申请售后
 @param userID   登录用户id
 @param token    登录返回
 @param count    终端数量
 @param address  地址
 @param receiver 收件人
 @param phoneNumber 手机号
 @param reason   售后原因
 @param terminalList   终端列表字符串
 @result finish  请求回调结果
 */
+ (void)submitAfterSaleApplyWithUserID:(NSString *)userID
                                 token:(NSString *)token
                         terminalCount:(NSInteger)count
                               address:(NSString *)address
                              receiver:(NSString *)receiver
                           phoneNumber:(NSString *)phoneNumber
                                reason:(NSString *)reason
                          terminalList:(NSString *)terminalList
                              finished:(requestDidFinished)finish;

/*!
 @abstract 34.用户管理——获取用户列表
 @param agentID  代理商id
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getUserListWithAgentID:(NSString *)agentID
                         token:(NSString *)token
                          page:(int)page
                          rows:(int)rows
                      finished:(requestDidFinished)finish;

/*!
 @abstract 35.用户管理——删除用户
 @param agentID  代理商id
 @param token    登录返回
 @param userIDs   删除用户的id数组
 @result finish  请求回调结果
 */
+ (void)deleteUserWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                      userIDs:(NSArray *)userIDs
                     finished:(requestDidFinished)finish;

/*!
 @abstract 36.用户管理——获取用户终端
 @param token    登录返回
 @param userID   用户id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getUserTerminalListWithUserID:(NSString *)userID
                                token:(NSString *)token
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish;
/*!
 @abstract 37.商品搜索条件
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)getGoodSearchInfoWithCityID:(NSString *)cityID
                           finished:(requestDidFinished)finish;

/*!
 @abstract 38.商品列表
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
 @abstract 39.商品详细
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
 @abstract 40.支付通道详细
 @param token     登录返回
 @param channelID   支付通道id
 @result finish  请求回调结果
 */
+ (void)getChannelDetailWithToken:(NSString *)token
                        channelID:(NSString *)channelID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 41.商品评论列表
 @param token     登录返回
 @param goodID   商品id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCommentListWithToken:(NSString *)token
                         goodID:(NSString *)goodID
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract 42.创建订单
 @param agentID     代理商id
 @param token       登录返回
 @param userID      选择的用户id，默认为登录返回的agentUserID
 @param createUserID  登录返回的id
 @param belongID    agentUserID
 @param confirmType  OrderConfirmType类型
 @param goodID     商品id
 @param channelID  支付通道id
 @param count      数量
 @param addressID   地址id
 @param comment     留言
 @param needInvoice 是否需要发票 0.不要 1.要
 @param invoiceType 发票类型 0.公司 1.个人
 @param invoiceTitle  发票抬头
 @result finish  请求回调结果
 */
+ (void)createOrderFromGoodBuyWithAgentID:(NSString *)agentID
                                    token:(NSString *)token
                                   userID:(NSString *)userID
                             createUserID:(NSString *)createUserID
                                 belongID:(NSString *)belongID
                              confirmType:(int)confirmType
                                   goodID:(NSString *)goodID
                                channelID:(NSString *)channelID
                                    count:(int)count
                                addressID:(NSString *)addressID
                                  comment:(NSString *)comment
                              needInvoice:(int)needInvoice
                              invoiceType:(int)invoiceType
                              invoiceInfo:(NSString *)invoiceTitle
                                 finished:(requestDidFinished)finish;

/*!
 @abstract 43.库存管理列表
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
 @abstract 44.库存管理重命名
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
 @abstract 45.库存管理详情——下级代理商列表
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
 @abstract 46.库存管理详情——下级代理商终端列表
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
 @abstract 47.选择代理商
 @param agentID     代理商ID
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getGoodSubAgentWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish;

/*!
 @abstract 48.配货列表
 @param agentID     代理商ID
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodListWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           subAgentID:(NSString *)subAgentID
                            startTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish;

/*!
 @abstract 49.配货详情
 @param token    登录返回
 @param prepareID  配货id
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodDetailWithToken:(NSString *)token
                            prapareID:(NSString *)prepareID
                             finished:(requestDidFinished)finish;

/*!
 @abstract 50.配货——POS列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodPOSWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish;

/*!
 @abstract 51.配货——支付通道列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodChannelWithAgentID:(NSString *)agentID
                                   token:(NSString *)token
                                finished:(requestDidFinished)finish;

/*!
 @abstract 52.配货——筛选终端
 @param agentID  代理商id
 @param token    登录返回
 @param channelID  支付通道id
 @param goodID    pos机id
 @param terminalNumbers  终端号数组
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getPrepareGoodTerminalListWithAgentID:(NSString *)agentID
                                        token:(NSString *)token
                                    channelID:(NSString *)channelID
                                       goodID:(NSString *)goodID
                              terminalNumbers:(NSArray *)terminalNumbers
                                         page:(int)page
                                         rows:(int)rows
                                     finished:(requestDidFinished)finish;
/*!
 @abstract 53.配货
 @param userID  登录id
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param channelID  支付通道id
 @param goodID    pos机id
 @param terminalList  终端号数组
 @result finish  请求回调结果
 */
+ (void)prepareGoodWithUserID:(NSString *)userID
                        token:(NSString *)token
                   subAgentID:(NSString *)subAgentID
                    channelID:(NSString *)channelID
                       goodID:(NSString *)goodID
                 terminalList:(NSArray *)terminalList
                     finished:(requestDidFinished)finish;

/*!
 @abstract 54.调货列表
 @param agentID     代理商ID
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTransferGoodListWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                            subAgentID:(NSString *)subAgentID
                             startTime:(NSString *)startTime
                               endTime:(NSString *)endTime
                                  page:(int)page
                                  rows:(int)rows
                              finished:(requestDidFinished)finish;

/*!
 @abstract 55.调货详情
 @param token    登录返回
 @param transferID  配货id
 @result finish  请求回调结果
 */
+ (void)getTransferGoodDetailWithToken:(NSString *)token
                            transferID:(NSString *)transferID
                              finished:(requestDidFinished)finish;

/*!
 @abstract 57.调货
 @param userID   登录id
 @param token    登录返回
 @param fromAgentID  被调货代理商id
 @param toAgentID    调货代理商id
 @param terminalList 终端号数组
 @result finish  请求回调结果
 */
+ (void)transferGoodWithUserID:(NSString *)userID
                         token:(NSString *)token
                   fromAgentID:(NSString *)fromAgentID
                     toAgentID:(NSString *)toAgentID
                  terminalList:(NSArray *)terminalList
                      finished:(requestDidFinished)finish;

/*!
 @abstract 58.交易流水——获取终端列表
 @param token    登录返回
 @param agentID  代理商id
 @result finish  请求回调结果
 */
+ (void)getTradeTerminalListWithAgentID:(NSString *)agentID
                                  token:(NSString *)token
                               finished:(requestDidFinished)finish;

/*!
 @abstract 59.交易流水——获取代理商列表
 @param token    登录返回
 @param agentID  代理商id
 @result finish  请求回调结果
 */
+ (void)getTradeAgentListWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish;

/*!
 @abstract 60.交易流水——查询交易流水
 @param agentID  代理商id
 @param token    登录返回
 @param tradeType  交易类型
 @param terminalNumber  终端号
 @param subAgentID  下级代理商
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTradeRecordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        tradeType:(TradeType)tradeType
                   terminalNumber:(NSString *)terminalNumber
                       subAgentID:(NSString *)subAgentID
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish;

/*!
 @abstract 61.交易流水——详情
 @param agentID  代理商id
 @param token    登录返回
 @param tradeID  交易id
 @param profit   1.无分润  2.有分润
 @result finish  请求回调结果
 */
+ (void)getTradeDetailWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                          tradeID:(NSString *)tradeID
                        hasProfit:(int)profit
                         finished:(requestDidFinished)finish;

/*!
 @abstract 62.交易流水——统计
 @param agentID  代理商id
 @param token    登录返回
 @param tradeType  交易类型
 @param terminalNumber  终端号
 @param subAgentID  下级代理商
 @param startTime   开始时间
 @param endTime     结束时间
 @param profit   1.无分润  2.有分润
 @result finish  请求回调结果
 */
+ (void)getTradeStatistWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                         tradeType:(TradeType)tradeType
                        subAgentID:(NSString *)subAgentID
                    terminalNumber:(NSString *)terminalNumber
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime
                         hasProfit:(int)profit
                          finished:(requestDidFinished)finish;

/*!
 @abstract 63.我的消息列表
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
 @abstract 64.我的消息详情
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
 @abstract 65.我的消息单删
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
 @abstract 66.我的消息多删
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
 @abstract 67.我的消息批量已读
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
 @abstract 68.订单管理——列表
 @param agentID  代理商id
 @param token    登录返回
 @param orderType  订单类型
 @param keyword    关键字
 @param status     订单状态
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getOrderListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                      orderType:(OrderType)orderType
                        keyword:(NSString *)keyword
                         status:(int)status
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract 69.订单管理——批购  72.代购
 @param token    登录返回
 @param supplyType  批购还是代购
 @param orderID    订单id
 @result finish  请求回调结果
 */
+ (void)getOrderDetailWithToken:(NSString *)token
                      orderType:(SupplyGoodsType)supplyType
                        orderID:(NSString *)orderID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 70.订单管理——取消批购订单
 @param token    登录返回
 @param orderID    订单id
 @result finish  请求回调结果
 */
+ (void)cancelWholesaleOrderWithToken:(NSString *)token
                              orderID:(NSString *)orderID
                             finished:(requestDidFinished)finish;

/*!
 @abstract 73.订单管理——取消代购订单
 @param token    登录返回
 @param orderID    订单id
 @result finish  请求回调结果
 */
+ (void)cancelProcurementOrderWithToken:(NSString *)token
                                orderID:(NSString *)orderID
                               finished:(requestDidFinished)finish;

/*!
 @abstract 74.售后单列表  77.注销记录列表 81.更新记录列表
 @param agentID  代理商id
 @param token    登录返回
 @param type     售后类型
 @param keyword  搜索关键字
 @param status   订单状态
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCSListWithAgentID:(NSString *)agentID
                       token:(NSString *)token
                      csType:(CSType)type
                     keyword:(NSString *)keyword
                      status:(int)status
                        page:(int)page
                        rows:(int)rows
                    finished:(requestDidFinished)finish;

/*!
 @abstract 75.售后单取消申请  78.注销记录取消申请 83.更新记录取消申请
 @param token    登录返回
 @param type     售后类型
 @param csID     售后单id
 @result finish  请求回调结果
 */
+ (void)csCancelApplyWithToken:(NSString *)token
                        csType:(CSType)type
                          csID:(NSString *)csID
                      finished:(requestDidFinished)finish;

/*!
 @abstract 76.售后单详情 80.注销记录详情 82.更新记录详情
 @param token    登录返回
 @param type     售后类型
 @param csID     售后单id
 @result finish  请求回调结果
 */
+ (void)getCSDetailWithToken:(NSString *)token
                      csType:(CSType)type
                        csID:(NSString *)csID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 79.售后记录——重新提交注销
 @param token    登录返回
 @param csID     售后单id
 @result finish  请求回调结果
 */
+ (void)csRepeatAppleyWithToken:(NSString *)token
                           csID:(NSString *)csID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 84.我的信息——获取详情
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getPersonDetailWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish;

/*!
 @abstract 85.我的信息——获取修改手机验证码
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
 @abstract 86.我的信息——修改手机
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
 @abstract 87.我的信息——获取修改邮箱验证码
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
 @abstract 88.我的信息——修改邮箱
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

/*!
 @abstract 89.我的信息——修改密码
 @param agentID  代理商id
 @param token    登录返回
 @param primaryPassword   原密码
 @param newPassword   新密码
 @result finish  请求回调结果
 */
+ (void)modifyPasswordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                  primaryPassword:(NSString *)primaryPassword
                      newPassword:(NSString *)newPassword
                         finished:(requestDidFinished)finish;

/*!
 @abstract 90.我的信息——地址列表
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getAddressListWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         finished:(requestDidFinished)finish;

/*!
 @abstract 91.我的信息——新增地址
 @param agentID  代理商id
 @param token    登录返回
 @param cityID   城市id
 @param receiverName   收件人姓名
 @param phoneNumber    收件人手机
 @param zipCode  邮政编码
 @param address  详细地址
 @param addressType    是否默认地址
 @result finish  请求回调结果
 */
+ (void)addAddressWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                       cityID:(NSString *)cityID
                 receiverName:(NSString *)receiverName
                  phoneNumber:(NSString *)phoneNumber
                      zipCode:(NSString *)zipCode
                      address:(NSString *)address
                    isDefault:(AddressType)addressType
                     finished:(requestDidFinished)finish;

/*!
 @abstract 92.我的信息——批量删除地址
 @param token    登录返回
 @param addressIDs   地址id数组
 @result finish  请求回调结果
 */
+ (void)deleteAddressWithToken:(NSString *)token
                    addressIDs:(NSArray *)addressIDs
                      finished:(requestDidFinished)finish;

/*!
 @abstract 92.a.修改地址
 @param token       登录返回
 @param userID       登录返回id
 @param addressID   地址ID
 @param cityID    城市id
 @param receiverName   收件人姓名
 @param phoneNumber   收件人电话
 @param zipCode   邮编
 @param address   详细地址
 @param addressType  是否默认地址
 @result finish  请求回调结果
 */
+ (void)updateAddressWithToken:(NSString *)token
                        userID:(NSString *)userID
                     addressID:(NSString *)addressID
                        cityID:(NSString *)cityID
                  receiverName:(NSString *)receiverName
                   phoneNumber:(NSString *)phoneNumber
                       zipCode:(NSString *)zipCode
                       address:(NSString *)address
                     isDefault:(AddressType)addressType
                      finished:(requestDidFinished)finish;

/*!
 @abstract 92.下级代理商管理——列表
 @param agentID  代理商id
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getSubAgentListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;

/*!
 @abstract 93.下级代理商管理——详情
 @param token    登录返回
 @param subAgentID 下级代理商id
 @result finish  请求回调结果
 */
+ (void)getSubAgentDetailWithToken:(NSString *)token
                        subAgentID:(NSString *)subAgentID
                          finished:(requestDidFinished)finish;

/*!
 @abstract 94.下级代理商管理——创建
 @param agentID      登录代理商id
 @param token        登录返回
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
+ (void)createSubAgentWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         username:(NSString *)username
                          password:(NSString *)password
                           confirm:(NSString *)confirm
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
                        hasPorfit:(int)hasProfit
                          finished:(requestDidFinished)finish;

/*!
 @abstract 95.下级代理商管理——设置默认分润
 @param agentID  代理商id
 @param token    登录返回
 @param precent  分润比例
 @result finish  请求回调结果
 */
+ (void)setDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                             precent:(CGFloat)precent
                            finished:(requestDidFinished)finish;

/*!
 @abstract 96.下级代理商管理——获取分润列表
 @param token    登录返回
 @param subAgentID  下级代理商id
 @result finish  请求回调结果
 */
+ (void)getBenefitListWithToken:(NSString *)token
                     subAgentID:(NSString *)subAgentID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 97.下级代理商管理——设置分润
 @param agentID  代理商id
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param channelID   支付通道id
 @param profit     分润比例
 @param type     0.修改分润  1.新增分润
 @result finish  请求回调结果
 */
+ (void)submitBenefitWithAgentID:(NSString *)agentID
                           token:(NSString *)token
                      subAgentID:(NSString *)subAgentID
                       channelID:(NSString *)channelID
                          profit:(NSString *)profit
                            type:(int)benefitType
                        finished:(requestDidFinished)finish;

/*!
 @abstract 98.下级代理商管理——删除分润
 @param agentID  代理商id
 @param token    登录返回
 @param subAgentID  下级代理商id
 @param channelID  支付通道id
 @result finish  请求回调结果
 */
+ (void)deleteBenefitWithAgentID:(NSString *)agentID
                           token:(NSString *)token
                      subAgentID:(NSString *)subAgentID
                       channelID:(NSString *)channelID
                        finished:(requestDidFinished)finish;


/*!
 @abstract 99.下级代理商管理——支付通道
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getAgentChannelListWithToken:(NSString *)token
                            finished:(requestDidFinished)finish;

/*!
 @abstract 100.下级代理商管理——上传图片
 @param image       图片
 @result finish  请求回调结果
 */
+ (void)uploadSubAgentImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish;

/*!
 @abstract 101.员工管理——列表
 @param agentID  代理商id
 @param token    登录返回
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCustomerListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;

/*!
 @abstract 102.员工管理——详情
 @param agentID  代理商id
 @param token    登录返回
 @param employeeID  员工id
 @result finish  请求回调结果
 */
+ (void)getCustomerDetailWitgAgentID:(NSString *)agentID
                               token:(NSString *)token
                          employeeID:(NSString *)employeeID
                            finished:(requestDidFinished)finish;

/*!
 @abstract 103.员工管理——创建
 @param agentID  代理商id
 @param token    登录返回
 @param realName  真实姓名
 @param loginName 登录名
 @param password  密码
 @param confirmPwd 密码
 @param authority  权限
 @result finish  请求回调结果
 */
+ (void)createCustomerWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         realName:(NSString *)realName
                        loginName:(NSString *)loginName
                        passoword:(NSString *)password
                       confirmPwd:(NSString *)confirmPwd
                        authority:(NSString *)authority
                         finished:(requestDidFinished)finish;

/*!
 @abstract 104.员工管理——单删
 @param agentID  代理商id
 @param token    登录返回
 @param employeeID 删除员工id
 @result finish  请求回调结果
 */
+ (void)deleteSingleCustomerWithAgentID:(NSString *)agentID
                                  token:(NSString *)token
                             employeeID:(NSString *)employeeID
                               finished:(requestDidFinished)finish;

/*!
 @abstract 105.员工管理——多删
 @param agentID  代理商id
 @param token    登录返回
 @param employees 删除员工id 逗号分隔
 @result finish  请求回调结果
 */
+ (void)deleteMultiCustomerWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                             employees:(NSString *)employees
                              finished:(requestDidFinished)finish;

/*!
 @abstract 106.员工管理——修改
 @param token    登录返回
 @param employeeID 员工id
 @param authority 权限
 @param password  密码
 @result finish  请求回调结果
 */
+ (void)modifyCustomerWithToken:(NSString *)token
                     employeeID:(NSString *)employeeID
                      authority:(NSString *)authority
                       password:(NSString *)password
                       finished:(requestDidFinished)finish;

/*!
 @abstract 下级代理商管理——获取消费类型
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getTradeTypeWithToken:(NSString *)token
                    channelID:(NSString *)channelID
                     finished:(requestDidFinished)finish;

/*!
 @abstract 下级代理商管理——获取默认分润
 @param agentID  代理商id
 @param token    登录返回
 @result finish  请求回调结果
 */
+ (void)getDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish;

/*!
 @abstract 首页轮播图
 @result finish  请求回调结果
 */
+ (void)getHomeImageListFinished:(requestDidFinished)finish;

/*!
 @abstract 订单信息
 @result finish  请求回调结果
 */
+ (void)orderConfirmWithOrderID:(NSString *)orderID
                       finished:(requestDidFinished)finish;

@end
