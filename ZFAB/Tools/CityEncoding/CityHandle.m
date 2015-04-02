//
//  CityHandle.m
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "CityHandle.h"

static NSArray *s_cityList = nil;
static NSArray *s_provinceList = nil;

static NSArray *s_sectionCityList = nil;
static NSArray *s_indexList = nil;

@implementation CityHandle

+ (NSArray *)shareProvinceList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_provinceList) {
            s_provinceList = [[self class] getProvinceList];
        }
    });
    return s_provinceList;
}

+ (NSArray *)shareCityList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_cityList) {
            s_cityList = [[self class] getCityList];
        }
    });
    return s_cityList;
}

+ (NSArray *)shareSectionCityList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_sectionCityList) {
            s_sectionCityList = [[self class] dataForSection];
        }
    });
    return s_sectionCityList;
}

+ (NSArray *)shareIndexList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!s_indexList) {
            s_indexList = [[self class] tableViewIndex];
        }
    });
    return s_indexList;
}

//省
+ (NSArray *)getProvinceList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"js"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSArray *provinceList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return provinceList;
}

//城市
+ (NSArray *)getCityList {
    NSArray *provinceList = [[self class] shareProvinceList];
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [provinceList count]; i++) {
        NSDictionary *provinceDict = [provinceList objectAtIndex:i];
        NSArray *cityForProvince = [provinceDict objectForKey:@"cities"];
        for (int j = 0; j < [cityForProvince count]; j++) {
            NSDictionary *cityDict = [cityForProvince objectAtIndex:j];
            CityModel *city = [[CityModel alloc] init];
            city.cityID = [NSString stringWithFormat:@"%@",[cityDict objectForKey:@"id"]];
            city.cityName = [cityDict objectForKey:@"name"];
            city.parentID = [NSString stringWithFormat:@"%@",[cityDict objectForKey:@"parentId"]];
            city.cityPinYin = [cityDict objectForKey:@"pinyin"];
            [cityList addObject:city];
        }
    }
    return cityList;
}

+ (NSString *)getCityNameWithCityID:(NSString *)cityID {
    NSString *cityName = nil;
    NSArray *cityList = [[self class] shareCityList];
    for (CityModel *city in cityList) {
        if ([city.cityID isEqualToString:cityID]) {
            cityName = city.cityName;
            break;
        }
    }
    return cityName;
}

+ (NSInteger)getProvinceIndexWithCityID:(NSString *)cityID {
    CityModel *cityModel = nil;
    NSArray *cityList = [[self class] shareCityList];
    for (CityModel *city in cityList) {
        if ([city.cityID isEqualToString:cityID]) {
            cityModel = city;
            break;
        }
    }
    NSInteger index = 0;
    for (int i = 0; i < [[[self class] shareProvinceList] count]; i++) {
        NSDictionary *provinceDict = [[[self class] shareProvinceList] objectAtIndex:i];
        NSString *parentID = [NSString stringWithFormat:@"%@",[provinceDict objectForKey:@"id"]];
        if ([parentID isEqualToString:cityModel.parentID]) {
            index = i;
            break;
        }
    }
    return index;
}

+ (NSInteger)getCityIndexWithCityID:(NSString *)cityID {
    NSInteger provinceIndex = [[self class] getProvinceIndexWithCityID:cityID];
    NSDictionary *provinceDict = [[[self class] shareProvinceList] objectAtIndex:provinceIndex];
    NSArray *cityForProvince = [provinceDict objectForKey:@"cities"];
    NSInteger index = 0;
    for (int i = 0; i < [cityForProvince count]; i++) {
        NSDictionary *cityDict = [cityForProvince objectAtIndex:i];
        NSString *city_ID = [NSString stringWithFormat:@"%@",[cityDict objectForKey:@"id"]];
        if ([city_ID isEqualToString:cityID]) {
            index = i;
            break;
        }
    }
    return index;
}

//城市排序
+ (NSArray *)sortCityList {
    NSArray *cityList = [[self class] shareCityList];
    NSArray *sortDescriptors = [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:@"cityPinYin"
                                                              ascending:YES]];
    return [cityList sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSArray *)tableViewIndex {
    NSArray *sortArry = [[self class] sortCityList];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *indexString = @"";
    //#栏
    BOOL otherIndex = NO;
    for (CityModel *city in sortArry) {
        if ([city.cityPinYin length] < 1) {
            otherIndex = YES;
        }
        else {
            NSString *firstCharacter = [[city.cityPinYin substringToIndex:1] uppercaseString];
            //若第一个字符为非A-Z
            char firstChar = [[firstCharacter uppercaseString] characterAtIndex:0];
            if (!(firstChar >= 'A' && firstChar <= 'Z')) {
                otherIndex = YES;
            }
            else {
                if (![indexString isEqualToString:firstCharacter]) {
                    [resultArray addObject:firstCharacter];
                    indexString = firstCharacter;
                }
            }
            
        }
    }
    if (otherIndex) {
        [resultArray addObject:@"#"];
    }
    return resultArray;
}

+ (NSArray *)dataForSection {
    NSArray *sortArray = [[self class] sortCityList];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *sectionArray = nil;
    NSString *indexString = @"";
    //#栏
    NSMutableArray *otherArray = [NSMutableArray array];
    for (CityModel *city in sortArray) {
        if ([city.cityPinYin length] < 1) {
            [otherArray addObject:city];
        }
        else {
            NSString *firstCharacter = [[city.cityPinYin substringToIndex:1] uppercaseString];
            //若第一个字符为非A-Z
            char firstChar = [[firstCharacter uppercaseString] characterAtIndex:0];
            if (!(firstChar >= 'A' && firstChar <= 'Z')) {
                [otherArray addObject:city];
            }
            else {
                //A-Z
                if (![indexString isEqualToString:firstCharacter]) {
                    sectionArray = [NSMutableArray array];
                    [sectionArray addObject:city];
                    [resultArray addObject:sectionArray];
                    indexString = firstCharacter;
                }
                else {
                    [sectionArray addObject:city];
                }
            }
            
        }
    }
    [resultArray addObject:otherArray];
    return resultArray;
}

@end
