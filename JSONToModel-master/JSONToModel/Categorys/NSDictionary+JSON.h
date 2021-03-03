//
//  NSDictionary+JSON.h
//  JSON_Model
//
//  Created by luo.h on 2017/12/7.
//  Copyright © 2017年 meet.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (JSON)


/**
 *  转换成JSON串字符串（没有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toJSONString;

/**
 *  转换成JSON串字符串（有可读性）
 *
 *  @return JSON字符串
 */
- (NSString *)toReadableJSONString;

/**
 *  转换成JSON数据
 *
 *  @return JSON数据
 */
- (NSData *)toJSONData;


/** 返回字符串，该字符串的格式为字典，如：
    return @{@"key":@"value"};
 */
- (NSString *)toPorpertyString;

//返回有序的allKeys
- (NSArray *)allSortedKeys;

//返回有序的allValues,value排序是以allSortedKeys为标准
- (NSArray *)allSortedValues;


@end


@interface NSString (JSON)

+ (NSString *)removeSpaceAndNewline:(NSString *)str;
+(NSString *)removeAllSpace:(NSString *)str;
- (NSString *)uppercaseFirstCharacter;

-(id)objectFromJSONString;//JSONString to NSDictionary

@end

