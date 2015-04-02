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
                         key:@"filename"];
    [request start];
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
                       userID:(NSString *)userID
                     finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (agentID) {
        [paramDict setObject:[NSNumber numberWithInt:[agentID intValue]] forKey:@"agentId"];
    }
    if (userID) {
        [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
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
                             finished:(requestDidFinished)finish {
    //参数
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (userID) {
        [paramDict setObject:[NSNumber numberWithInt:[userID intValue]] forKey:@"customerId"];
    }
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

//55.
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

//60.
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

//61.
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

//62.
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

//63.
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

//64.
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

//80.
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

//81.
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

//82.
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

//83.
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

//84.
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

@end
