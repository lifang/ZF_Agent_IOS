//
//  ChaanelModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ChannelModel.h"

@implementation OpenMaterialModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"name"]) {
            _name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"introduction"]) {
            _introduction = [NSString stringWithFormat:@"%@",[dict objectForKey:@"introduction"]];
        }
    }
    return self;
}

@end

@implementation GoodRateModel

- (id)initWithParseDictionary:(NSDictionary *)dict
                     rateType:(GoodRateType)type {
    if (self = [super init]) {
        switch (type) {
            case GoodRateDate: {
                if ([dict objectForKey:@"id"]) {
                    _rateID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                }
                if ([dict objectForKey:@"service_rate"]) {
                    _ratePercent = [[dict objectForKey:@"service_rate"] floatValue];
                }
                if ([dict objectForKey:@"name"]) {
                    _rateName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                }
                if ([dict objectForKey:@"description"]) {
                    _rateDescription = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
                }
            }
                break;
            case GoodRateStand: {
                if ([dict objectForKey:@"standard_rate"]) {
                    _ratePercent = [[dict objectForKey:@"standard_rate"] floatValue];
                }
                if ([dict objectForKey:@"name"]) {
                    _rateName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                }
                if ([dict objectForKey:@"description"]) {
                    _rateDescription = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
                }
            }
                break;
            case GoodRateOther: {
                if ([dict objectForKey:@"terminal_rate"]) {
                    _ratePercent = [[dict objectForKey:@"terminal_rate"] floatValue];
                }
                if ([dict objectForKey:@"trade_value"]) {
                    _rateName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"trade_value"]];
                }
                if ([dict objectForKey:@"description"]) {
                    _rateDescription = [NSString stringWithFormat:@"%@",[dict objectForKey:@"description"]];
                }
            }
                break;
            default:
                break;
        }
    }
    return self;
}

@end

@implementation ChannelModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _channelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"opening_requirement"]) {
            _openRequirement = [NSString stringWithFormat:@"%@",[dict objectForKey:@"opening_requirement"]];
        }
        if ([dict objectForKey:@"support_cancel_flag"]) {
            _canCanceled = [[dict objectForKey:@"support_cancel_flag"] boolValue];
        }
        if ([dict objectForKey:@"opening_cost"]) {
            _openCost = [[dict objectForKey:@"opening_cost"] floatValue] / 100;
        }
        if ([dict objectForKey:@"support_type"]) {
            _supportType = [[dict objectForKey:@"support_type"] boolValue];
        }
        id channelFactoryObject = [dict objectForKey:@"pcfactory"];
        if ([channelFactoryObject isKindOfClass:[NSDictionary class]]) {
            if ([channelFactoryObject objectForKey:@"description"]) {
                _channelFactoryDescription = [NSString stringWithFormat:@"%@",[channelFactoryObject objectForKey:@"description"]];
            }
            if ([channelFactoryObject objectForKey:@"website_url"]) {
                _channelFactoryURL = [NSString stringWithFormat:@"%@",[channelFactoryObject objectForKey:@"website_url"]];
            }
            if ([channelFactoryObject objectForKey:@"logo_file_path"]) {
                _channelFactoryLogo = [NSString stringWithFormat:@"%@",[channelFactoryObject objectForKey:@"logo_file_path"]];
            }
        }
        id areaObject = [dict objectForKey:@"supportArea"];
        if ([areaObject isKindOfClass:[NSArray class]]) {
            _supportAreaItem = [[NSMutableArray alloc] init];
            [_supportAreaItem addObjectsFromArray:areaObject];
        }
        id dateObject = [dict objectForKey:@"tDates"];
        if ([dateObject isKindOfClass:[NSArray class]]) {
            _dateRateItem = [[NSMutableArray alloc] init];
            for (int i = 0; i < [dateObject count]; i++) {
                id dateDict = [dateObject objectAtIndex:i];
                if ([dateDict isKindOfClass:[NSDictionary class]]) {
                    GoodRateModel *model = [[GoodRateModel alloc] initWithParseDictionary:dateDict
                                                                                 rateType:GoodRateDate];
                    [_dateRateItem addObject:model];
                }
            }
        }
        id standObject = [dict objectForKey:@"standard_rates"];
        if ([standObject isKindOfClass:[NSArray class]]) {
            _standRateItem = [[NSMutableArray alloc] init];
            for (int i = 0; i < [standObject count]; i++) {
                id standDict = [standObject objectAtIndex:i];
                if ([standDict isKindOfClass:[NSDictionary class]]) {
                    GoodRateModel *model = [[GoodRateModel alloc] initWithParseDictionary:standDict
                                                                                 rateType:GoodRateStand];
                    [_standRateItem addObject:model];
                }
            }
        }
        id otherObject = [dict objectForKey:@"other_rate"];
        if ([otherObject isKindOfClass:[NSArray class]]) {
            _otherRateItem = [[NSMutableArray alloc] init];
            for (int i = 0; i < [otherObject count]; i++) {
                id otherDict = [otherObject objectAtIndex:i];
                if ([otherDict isKindOfClass:[NSDictionary class]]) {
                    GoodRateModel *model = [[GoodRateModel alloc] initWithParseDictionary:otherDict
                                                                                 rateType:GoodRateOther];
                    [_otherRateItem addObject:model];
                }
            }
        }
        //对私
        id privateObject = [dict objectForKey:@"requireMaterial_pra"];
        if ([privateObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *privateList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [privateObject count]; i++) {
                id privateDict = [privateObject objectAtIndex:i];
                if ([privateDict isKindOfClass:[NSDictionary class]]) {
                    OpenMaterialModel *model = [[OpenMaterialModel alloc] initWithParseDictionary:privateDict];
                    [privateList addObject:model];
                }
            }
            _privateInfo = [self handleOpenMaterialInfoWithArray:privateList];
        }
        //对公
        id publicObject = [dict objectForKey:@"requireMaterial_pub"];
        if ([publicObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *publicList = [[NSMutableArray alloc] init];
            for (int i = 0; i < [publicObject count]; i++) {
                id publicDict = [publicObject objectAtIndex:i];
                if ([publicDict isKindOfClass:[NSDictionary class]]) {
                    OpenMaterialModel *model = [[OpenMaterialModel alloc] initWithParseDictionary:publicDict];
                    [publicList addObject:model];
                }
            }
            _publicInfo = [self handleOpenMaterialInfoWithArray:publicList];
        }
    }
    return self;
}

- (NSString *)handleOpenMaterialInfoWithArray:(NSArray *)materialList {
    NSString *openString = @"";
    for (int i = 0; i < [materialList count]; i++) {
        OpenMaterialModel *model = [materialList objectAtIndex:i];
        NSString *rowString = [NSString stringWithFormat:@"%d.%@",i + 1,model.name];
        if (model.introduction) {
            rowString = [rowString stringByAppendingString:[NSString stringWithFormat:@"（%@）",model.introduction]];
        }
        if (i != [materialList count] - 1) {
            rowString = [rowString stringByAppendingString:@"\n"];
        }
        openString = [openString stringByAppendingString:rowString];
    }
    return openString;
}


@end
