//
//  ConvertCore.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertCore.h"
#import "Config.h"
#import "ConvertResult.h"
#import "SettingManager.h"




@implementation ConvertCore

+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

/**
 所有支持的解析类型:
 OC-YYModel
 OC-JSONModel
 OC-MJExtension
 */
- (NSArray<NSString *> *)allSupportMode
{
    return SettingManager.shared.allSupportModeName;
}

/**
 Json转Model时的3种生成模式
 标准：如果已经解析过相同结构的Model时，不会再生成新的Model
 最少：如果将要生成的Model是已经解析过的Model的子集时，不会再生成新的Model
 全部：解析全部，即使已经解析过相同的Modl,也会生成新的Model
 */
- (NSArray<NSString *> *)allDuplicateMode
{
    return @[@"标准",@"最少",@"全部"];
}


/**
 帕斯卡命名:
 1.首字母大写，
 2."_"字符去掉,并使其后面的字母大写
 */
+ (NSString *)pascalName:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *tmpName = [[NSMutableString alloc] initWithString:name];
    if (Config.shared.isPascal) {
        // "_"处首字母大写
        NSRange range = [tmpName rangeOfString:@"_"];
        while (range.length>0) {
            [tmpName replaceCharactersInRange:range withString:@""];
            NSString *upperStr = [tmpName substringWithRange:range];
            upperStr = upperStr.uppercaseString;
            [tmpName replaceCharactersInRange:range withString:upperStr];
            range = [tmpName rangeOfString:@"_"];
        }
        //首字母大写
        range = NSMakeRange(0, 1);
        NSString *upperStr = [tmpName substringWithRange:range];
        upperStr = upperStr.uppercaseString;
        [tmpName replaceCharactersInRange:range withString:upperStr];
    }else{
        NSRange range = NSMakeRange(0, 1);
        NSString *upperStr = [tmpName substringWithRange:range];
        upperStr = upperStr.uppercaseString;
        [tmpName replaceCharactersInRange:range withString:upperStr];
    }
    return tmpName;
}

/**
 驼峰命名：
 1.首字母小写，
 2."_"字符去掉,并使其后面的字母小写
 */
+ (NSString *)humpName:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *tmpName = [[NSMutableString alloc] initWithString:name];
    if (Config.shared.isHump) {
        // "_"处首字母大写
        NSRange range = [tmpName rangeOfString:@"_"];
        while (range.length>0) {
            [tmpName replaceCharactersInRange:range withString:@""];
            NSString *upperStr = [tmpName substringWithRange:range];
            upperStr = upperStr.uppercaseString;
            [tmpName replaceCharactersInRange:range withString:upperStr];
            range = [tmpName rangeOfString:@"_"];
        }
        //首字母小写写
        range = NSMakeRange(0, 1);
        NSString *upperStr = [tmpName substringWithRange:range];
        upperStr = upperStr.lowercaseString;
        [tmpName replaceCharactersInRange:range withString:upperStr];
    }
    return tmpName;
}



//根据value的值获取key的类型名称
+ (NSString *)attrTypeWithValue:(id)value
{
    NSString *type = kString;
    if ([value isKindOfClass:NSString.class]) {
        type = kString;
    }else if ([value isKindOfClass:NSNumber.class]){
        if ((strcmp([value objCType], @encode(float)) == 0) || (strcmp([value objCType], @encode(double)) == 0)){
            type = kFloat;
        }else if (strcmp([value objCType], @encode(BOOL)) == 0){
            type = kBool;
        }else{
            type = kInt;
        }
    }else if ([value isKindOfClass:NSArray.class]){
        type = kAry;
    }else if ([value isKindOfClass:NSDictionary.class]){
        type = kDic;
    }
    return type;
}


/**
 获取h文件部分的后缀名称
 */
- (NSString *)hPartSuffix
{
    NSString *suffix = @"Unknown";
    if (Config.shared.codeType == CodeTypeObjective) {
        suffix = @"h";
    }else if (Config.shared.codeType == CodeTypeSwift){
        suffix = @"swift";
    }
    return suffix;
}

/**
 获取m文件部分的后缀名称
 */
- (NSString *)mPartSuffix
{
    NSString *suffix = @"Unknown";
    if (Config.shared.codeType == CodeTypeObjective) {
        suffix = @"m";
    }
    return suffix;
}


@end





