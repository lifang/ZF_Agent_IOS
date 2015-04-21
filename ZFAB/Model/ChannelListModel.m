//
//  ChannelListModel.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/9.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "ChannelListModel.h"

@implementation BillingModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _billID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _billName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
    }
    return self;
}

@end

@implementation ChannelListModel

- (id)initWithParseDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _channelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
        if ([dict objectForKey:@"billings"]) {
            id billList = [dict objectForKey:@"billings"];
            if ([billList isKindOfClass:[NSArray class]]) {
                _children = [[NSMutableArray alloc] init];
                for (int i = 0; i < [billList count]; i++) {
                    id billDict = [billList objectAtIndex:i];
                    if ([billDict isKindOfClass:[NSDictionary class]]) {
                        BillingModel *model = [[BillingModel alloc] initWithParseDictionary:billDict];
                        [_children addObject:model];
                    }
                }
            }
        }
    }
    return self;
}

- (id)initWithParsePGChannelDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _channelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"paychannel"]) {
            _channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"paychannel"]];
        }
    }
    return self;
}

- (id)initWithParseBenefitChannelDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict objectForKey:@"id"]) {
            _channelID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        }
        if ([dict objectForKey:@"name"]) {
            _channelName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        }
    }
    return self;
}

@end
