//
//  OpenApplyModel.h
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MaterialNone = 0,
    MaterialText,    //文本
    MaterialImage,   //图片
    MaterialList,    //下拉列表
}MaterialType;

//商家
@interface MerchantModel : NSObject

@property (nonatomic, strong) NSString *merchantID;

@property (nonatomic, strong) NSString *merchantName;

@property (nonatomic, strong) NSString *merchantLegal;

@property (nonatomic, assign) BOOL isSelected;  //开通申请中记录是否选中

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

//返回对公对私需要提交的材料
@interface MaterialModel : NSObject

@property (nonatomic, strong) NSString *materialID;    //材料id
@property (nonatomic, strong) NSString *materialName;  //材料名
@property (nonatomic, assign) MaterialType materialType;  //数据类型
@property (nonatomic, strong) NSString *levelID;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

//返回已提交的材料信息
@interface ApplyInfoModel : NSObject

@property (nonatomic, strong) NSString *targetID;  //等于MaterialModel中的materialID
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) MaterialType type;
@property (nonatomic, strong) NSString *levelID;

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end

@interface OpenApplyModel : NSObject

@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *modelNumber;
@property (nonatomic, strong) NSString *terminalNumber;
@property (nonatomic, strong) NSString *channelName;

//已上传的基本信息
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *merchantID;
@property (nonatomic, strong) NSString *merchantName;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *cardID;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankNumber;
@property (nonatomic, strong) NSString *bankAccount;
@property (nonatomic, strong) NSString *taxID;
@property (nonatomic, strong) NSString *organID;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *channelOpenName; //选择中的支付通道名 区别去上面的channelName
@property (nonatomic, strong) NSString *billingID;   //结算周期id
@property (nonatomic, strong) NSString *billingName; //结算周期名


@property (nonatomic, strong) NSMutableArray *merchantList;
@property (nonatomic, strong) NSMutableArray *materialList; //需要提交的材料数组
@property (nonatomic, strong) NSMutableArray *applyList;    //已提交的材料数组

- (id)initWithParseDictionary:(NSDictionary *)dict;

@end
