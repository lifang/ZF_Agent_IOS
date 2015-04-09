//
//  NetworkInterface.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/3/25.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "NetworkInterface.h"
#import "EncryptHelper.h"

static NSString *HTTP_POST = @"POST";
static NSString *HTTP_GET  = @"GET";

@implementation NetworkInterface

#pragma mark - 公用方法

+ (void)requestWithURL:(NSString *)urlString
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)method
              finished:(requestDidFinished)finish {
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:method
                                                                finished:finish];
    NSLog(@"url = %@,params = %@",urlString,params);
    if ([method isEqualToString:HTTP_POST] && params) {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setPostBody:postData];
    }
    [request start];
}

#pragma mark - 接口方法

//1.
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:username forKey:@"username"];
    NSString *encryptPassword = password;
    if (!encrypt) {
        encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    }
    [paramDict setObject:encryptPassword forKey:@"password"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_login_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//2.
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
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:username forKey:@"username"];
    NSString *encryptPassword = password;
    if (!encrypt) {
        encryptPassword = [EncryptHelper MD5_encryptWithString:password];
    }
    [paramDict setObject:encryptPassword forKey:@"password"];
    [paramDict setObject:[NSNumber numberWithInt:agentType] forKey:@"types"];
    if (agentType == AgentTypeCompany) {
        if (companyName) {
            [paramDict setObject:companyName forKey:@"companyName"];
        }
        if (licenseID) {
            [paramDict setObject:licenseID forKey:@"businessLicense"];
        }
        if (taxID) {
            [paramDict setObject:taxID forKey:@"taxRegisteredNo"];
        }
        if (licenseImagePath) {
            [paramDict setObject:licenseImagePath forKey:@"licenseNoPicPath"];
        }
        if (taxImagePath) {
            [paramDict setObject:taxImagePath forKey:@"taxNoPicPath"];
        }
    }
    if (legalPersonName) {
        [paramDict setObject:legalPersonName forKey:@"name"];
    }
    if (legalPersonID) {
        [paramDict setObject:legalPersonID forKey:@"cardId"];
    }
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"phone"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    if (cardImagePath) {
        [paramDict setObject:cardImagePath forKey:@"cardIdPhotoPath"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_register_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//4.
+ (void)sendValidateWithMobileNumber:(NSString *)mobileNumber
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (mobileNumber) {
        [paramDict setObject:mobileNumber forKey:@"codeNumber"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_sendValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//5.
+ (void)sendEmailValidateWithEmail:(NSString *)email
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (email) {
        [paramDict setObject:email forKey:@"codeNumber"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_emailValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//6.
+ (void)findPasswordWithUsername:(NSString *)username
                        password:(NSString *)password
                    validateCode:(NSString *)validateCode
                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (username) {
        [paramDict setObject:username forKey:@"username"];
    }
    if (password) {
        [paramDict setObject:password forKey:@"password"];
    }
    if (validateCode) {
        [paramDict setObject:validateCode forKey:@"code"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_findPassword_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//7.
+ (void)uploadRegisterImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_uploadRegisterImage_method];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"img"];
    [request start];
}

//8. 9.
+ (void)getApplyListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                        keyword:(NSString *)keyword
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    if (keyword) {
        [paramDict setObject:keyword forKey:@"serialNum"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

//10.
+ (void)beginToApplyWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                     terminalID:(NSString *)terminalID
                  openApplyType:(OpenApplyType)applyType
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:[terminalID intValue]] forKey:@"terminalsId"];
    [paramDict setObject:[NSNumber numberWithInt:applyType] forKey:@"status"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//11.
+ (void)getMerchantDetaikWithToken:(NSString *)token
                        merchantID:(NSString *)merchantID
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[merchantID intValue]] forKey:@"merchantId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_applyMerchantDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//12.
+ (void)getChannelListWithToken:(NSString *)token
                       finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_channelList_method];
    [[self class] requestWithURL:urlString
                          params:nil
                      httpMethod:HTTP_POST
                        finished:finish];
}

//13.
+ (void)getBankListWithToken:(NSString *)token
                     keyword:(NSString *)keyword
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (keyword) {
        [paramDict setObject:keyword forKey:@"bankName"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_bank_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//16.
+ (void)uploadApplyImageWithImage:(UIImage *)image
                         finished:(requestDidFinished)finish {
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_uploadApplyImage_method];
    NetworkRequest *request = [[NetworkRequest alloc] initWithRequestURL:urlString
                                                              httpMethod:HTTP_POST
                                                                finished:finish];
    [request uploadImageData:UIImagePNGRepresentation(image)
                   imageName:nil
                         key:@"img"];
    [request start];
}

//17.
+ (void)getTerminalDetailWithToken:(NSString *)token
                        terminalID:(NSString *)terminalID
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[terminalID intValue]] forKey:@"terminalsId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//18.
+ (void)getMerchantListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_merchantList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//20.
+ (void)getTerminalListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                           keyword:(NSString *)keyword
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    if (keyword) {
        [paramDict setObject:keyword forKey:@"serialNum"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_terminalList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//31.
+ (void)getUserListWithAgentID:(NSString *)agentID
                         token:(NSString *)token
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//32.
+ (void)deleteUserWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                      userIDs:(NSArray *)userIDs
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (userIDs) {
        [paramDict setObject:userIDs forKey:@"customerArrayId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//33.
+ (void)getUserTerminalListWithUserID:(NSString *)userID
                                token:(NSString *)token
                                 page:(int)page
                                 rows:(int)rows
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (userID) {
        [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_userTerminal_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//34.
+ (void)getGoodSearchInfoWithCityID:(NSString *)cityID
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodSearch_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//35.
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
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:supplyType] forKey:@"type"];
    if (filterType != OrderFilterNone) {
        [paramDict setObject:[NSNumber numberWithInt:filterType] forKey:@"orderType"];
    }
    if (brandID) {
        [paramDict setObject:brandID forKey:@"brandsId"];
    }
    if (category) {
        [paramDict setObject:category forKey:@"category"];
    }
    if (channelID) {
        [paramDict setObject:channelID forKey:@"payChannelId"];
    }
    if (cardID) {
        [paramDict setObject:cardID forKey:@"payCardId"];
    }
    if (tradeID) {
        [paramDict setObject:tradeID forKey:@"tradeTypeId"];
    }
    if (slipID) {
        [paramDict setObject:slipID forKey:@"saleSlipId"];
    }
    if (date) {
        [paramDict setObject:date forKey:@"tDate"];
    }
    if (maxPrice >= 0) {
        [paramDict setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
    }
    if (minPrice >= 0) {
        [paramDict setObject:[NSNumber numberWithFloat:minPrice] forKey:@"minPrice"];
    }
    if (keyword) {
        [paramDict setObject:keyword forKey:@"keys"];
    }
    [paramDict setObject:[NSNumber numberWithInt:rent] forKey:@"hasLease"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//36.
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                        agentID:(NSString *)agentID
                         goodID:(NSString *)goodID
                     supplyType:(SupplyGoodsType)supplyType
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[cityID intValue]] forKey:@"cityId"];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:supplyType] forKey:@"type"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_goodDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//40.
+ (void)getStockListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//41.
+ (void)renameStockGoodWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                            goodID:(NSString *)goodID
                          goodName:(NSString *)goodName
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    if (goodName) {
        [paramDict setObject:goodName forKey:@"goodname"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockRename_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//42.
+ (void)getStockDetailWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        channelID:(NSString *)channelID
                           goodID:(NSString *)goodID
                        agentName:(NSString *)agentName
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    if (agentName) {
        [paramDict setObject:agentName forKey:@"agentname"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//43.
+ (void)getStockTerminalWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                          channelID:(NSString *)channelID
                             goodID:(NSString *)goodID
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[channelID intValue]] forKey:@"paychannelId"];
    [paramDict setObject:[NSNumber numberWithInt:[goodID intValue]] forKey:@"goodId"];
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_stockTerminal_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//57.
+ (void)getTradeTerminalListWithAgentID:(NSString *)agentID
                                  token:(NSString *)token
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeTerminalList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//58.
+ (void)getTradeAgentListWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeAgentList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//59.
+ (void)getTradeRecordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                        tradeType:(TradeType)tradeType
                   terminalNumber:(NSString *)terminalNumber
                       subAgentID:(NSString *)subAgentID
                        startTime:(NSString *)startTime
                          endTime:(NSString *)endTime
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    [paramDict setObject:[NSNumber numberWithInt:tradeType] forKey:@"tradeTypeId"];
    if (terminalNumber) {
        [paramDict setObject:terminalNumber forKey:@"terminalNumber"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[subAgentID intValue]] forKey:@"sonagentId"];
    if (startTime) {
        [paramDict setObject:startTime forKey:@"startTime"];
    }
    if (endTime) {
        [paramDict setObject:endTime forKey:@"endTime"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_tradeRecord_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//62.
+ (void)getMyMessageListWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                               page:(int)page
                               rows:(int)rows
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//63.
+ (void)getMyMessageDetailWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                            messageID:(NSString *)messageID
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[messageID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//64.
+ (void)deleteSingleMessageWithAgentID:(NSString *)agentID
                                 token:(NSString *)token
                             messageID:(NSString *)messageID
                              finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:[messageID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageSingleDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//65.
+ (void)deleteMultiMessageWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                           messageIDs:(NSArray *)messageIDs
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:messageIDs forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageMultiDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//66.
+ (void)readMultiMessageWithAgentID:(NSString *)agentID
                              token:(NSString *)token
                         messageIDs:(NSArray *)messageIDs
                           finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    [paramDict setObject:messageIDs forKey:@"ids"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_messageMultiRead_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//67.
+ (void)getOrderListWithAgentID:(NSString *)agentID
                          token:(NSString *)token
                      orderType:(OrderType)orderType
                        keyword:(NSString *)keyword
                         status:(int)status
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    if (orderType > 0) {
        [paramDict setObject:[NSNumber numberWithInt:orderType] forKey:@"p"];
    }
    if (keyword) {
        [paramDict setObject:keyword forKey:@"search"];
    }
    if (status > 0) {
        [paramDict setObject:[NSString stringWithFormat:@"%d",status] forKey:@"q"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//68、71.
+ (void)getOrderDetailWithToken:(NSString *)token
                      orderType:(SupplyGoodsType)supplyType
                        orderID:(NSString *)orderID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *method = s_orderDetailWholesale_method;
    if (supplyType == SupplyGoodsProcurement) {
        method = s_orderDetailProcurement_method;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//69.
+ (void)cancelWholesaleOrderWithToken:(NSString *)token
                              orderID:(NSString *)orderID
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderCancelWholesale_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//72.
+ (void)cancelProcurementOrderWithToken:(NSString *)token
                                orderID:(NSString *)orderID
                               finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[orderID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_orderCancelProcurement_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//73. 76. 80.
+ (void)getCSListWithAgentID:(NSString *)agentID
                       token:(NSString *)token
                      csType:(CSType)type
                     keyword:(NSString *)keyword
                      status:(int)status
                        page:(int)page
                        rows:(int)rows
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    if (keyword) {
        [paramDict setObject:keyword forKey:@"search"];
    }
    if (status > 0) {
        [paramDict setObject:[NSNumber numberWithInt:status] forKey:@"q"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *method = nil;
    switch (type) {
        case CSTypeAfterSale:
            method = s_afterSaleList_method;
            break;
        case CSTypeUpdate:
            method = s_updateList_method;
            break;
        case CSTypeCancel:
            method = s_cancelList_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];

}

//74. 77. 82.
+ (void)csCancelApplyWithToken:(NSString *)token
                        csType:(CSType)type
                          csID:(NSString *)csID
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *method = nil;
    switch (type) {
        case CSTypeAfterSale:
            method = s_afterSaleCancel_method;
            break;
        case CSTypeUpdate:
            method = s_updateCancel_method;
            break;
        case CSTypeCancel:
            method = s_cancelCancel_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//75. 79. 81.
+ (void)getCSDetailWithToken:(NSString *)token
                      csType:(CSType)type
                        csID:(NSString *)csID
                    finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *method = nil;
    switch (type) {
        case CSTypeAfterSale:
            method = s_afterSaleDetail_method;
            break;
        case CSTypeUpdate:
            method = s_updateDetail_method;
            break;
        case CSTypeCancel:
            method = s_cancelDetail_method;
            break;
        default:
            break;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//78.
+ (void)csRepeatAppleyWithToken:(NSString *)token
                           csID:(NSString *)csID
                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[csID intValue]] forKey:@"id"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_cancelApply_mehtod];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//83.
+ (void)getPersonDetailWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_personDetail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//84.
+ (void)getPersonModifyMobileValidateWithAgentID:(NSString *)agentID
                                           token:(NSString *)token
                                     phoneNumber:(NSString *)phoneNumber
                                        finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"phone"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPhoneValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//85.
+ (void)modifyPersonMobileWithAgentID:(NSString *)agentID
                                token:(NSString *)token
                       newPhoneNumber:(NSString *)phoneNumber
                             validate:(NSString *)validate
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"phone"];
    }
    if (validate) {
        [paramDict setObject:validate forKey:@"dentcode"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPhone_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//86.
+ (void)getPersonModifyEmailValidateWithAgentID:(NSString *)agentID
                                          token:(NSString *)token
                                          email:(NSString *)email
                                       finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyEmailValidate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//87.
+ (void)modifyPersonEmailWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                            newEmail:(NSString *)email
                            validate:(NSString *)validate
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (email) {
        [paramDict setObject:email forKey:@"email"];
    }
    if (validate) {
        [paramDict setObject:validate forKey:@"dentcode"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyEmail_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//88.
+ (void)modifyPasswordWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                  primaryPassword:(NSString *)primaryPassword
                      newPassword:(NSString *)newPassword
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (primaryPassword) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:primaryPassword] forKey:@"passwordOld"];
    }
    if (newPassword) {
        [paramDict setObject:[EncryptHelper MD5_encryptWithString:newPassword] forKey:@"password"];
    }
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_modifyPassword_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//89.
+ (void)getAddressListWithAgentID:(NSString *)agentID
                            token:(NSString *)token
                         finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }

    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//90.
+ (void)addAddressWithAgentID:(NSString *)agentID
                        token:(NSString *)token
                       cityID:(NSString *)cityID
                 receiverName:(NSString *)receiverName
                  phoneNumber:(NSString *)phoneNumber
                      zipCode:(NSString *)zipCode
                      address:(NSString *)address
                    isDefault:(AddressType)addressType
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"customerId"];
    }
    if (cityID) {
        [paramDict setObject:cityID forKey:@"cityId"];
    }
    if (receiverName) {
        [paramDict setObject:receiverName forKey:@"receiver"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"moblephone"];
    }
    if (zipCode) {
        [paramDict setObject:zipCode forKey:@"zipCode"];
    }
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    [paramDict setObject:[NSNumber numberWithInt:addressType] forKey:@"isDefault"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressAdd_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//91.
+ (void)deleteAddressWithToken:(NSString *)token
                    addressIDs:(NSArray *)addressIDs
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:addressIDs forKey:@"ids"];
    
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressDelete_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//91.a.
+ (void)updateAddressWithToken:(NSString *)token
                     addressID:(NSString *)addressID
                        cityID:(NSString *)cityID
                  receiverName:(NSString *)receiverName
                   phoneNumber:(NSString *)phoneNumber
                       zipCode:(NSString *)zipCode
                       address:(NSString *)address
                     isDefault:(AddressType)addressType
                      finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[addressID intValue]] forKey:@"id"];
    if (cityID) {
        [paramDict setObject:cityID forKey:@"cityId"];
    }
    if (receiverName) {
        [paramDict setObject:receiverName forKey:@"receiver"];
    }
    if (phoneNumber) {
        [paramDict setObject:phoneNumber forKey:@"moblephone"];
    }
    if (zipCode) {
        [paramDict setObject:zipCode forKey:@"zipCode"];
    }
    if (address) {
        [paramDict setObject:address forKey:@"address"];
    }
    [paramDict setObject:[NSNumber numberWithInt:addressType] forKey:@"isDefault"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_addressUpdate_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//92.
+ (void)getSubAgentListWithAgentID:(NSString *)agentID
                             token:(NSString *)token
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    }
    [paramDict setObject:[NSNumber numberWithInt:page] forKey:@"page"];
    [paramDict setObject:[NSNumber numberWithInt:rows] forKey:@"rows"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentList_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

//95.
+ (void)setDefaultBenefitWithAgentID:(NSString *)agentID
                               token:(NSString *)token
                             precent:(CGFloat)precent
                            finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentsId"];
    [paramDict setObject:[NSNumber numberWithFloat:precent] forKey:@"defaultProfit"];
    //url
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",kServiceURL,s_subAgentDefaultBenefit_method];
    [[self class] requestWithURL:urlString
                          params:paramDict
                      httpMethod:HTTP_POST
                        finished:finish];
}

@end
