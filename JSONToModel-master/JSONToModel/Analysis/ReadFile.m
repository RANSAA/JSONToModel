//
//  ReadFile.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ReadFile.h"

@interface ReadFile ()
@property (nonatomic, strong) NSDictionary *coding;
@property (nonatomic, strong) NSArray *describe;
@end

@implementation ReadFile

+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self readCodingJson];
        [self readDescribeJson];
    }
    return self;
}

- (void)readCodingJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Coding" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _coding = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)readDescribeJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Describe" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _describe = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:[NSDate new]];
}

/** 获取用户描述文字 */
- (NSString *)getUserInfo
{
    static dispatch_once_t onceToken;
    static NSMutableString *str = nil;
    dispatch_once(&onceToken, ^{
        str = [[NSMutableString alloc] init];
        for (NSString *item in _describe) {
            [str appendFormat:@"%@\n",item];
        }
        NSRange range = [str rangeOfString:@"时间"];
        if (range.length != 0) {
            [str replaceCharactersInRange:range withString:[self dateString]];
        }
    });
    return str;
}

/** 获取YYModel序列化支持配置*/
- (NSString *)getYYModelSerialize
{
    static dispatch_once_t onceToken;
    static NSMutableString *str = nil;
    dispatch_once(&onceToken, ^{
        str = [[NSMutableString alloc] init];
        NSArray *ary = _coding[@"OC-YYModel"];
        for (NSString *item in ary) {
            [str appendFormat:@"%@\n",item];
        }
    });
    return str;
}

/** 获取JSONModel序列化支持配置*/
- (NSString *)getJSONModelSerialize
{
    static dispatch_once_t onceToken;
    static NSMutableString *str = nil;
    dispatch_once(&onceToken, ^{
        str = [[NSMutableString alloc] init];
        NSArray *ary = _coding[@"OC-JSONModel"];
        for (NSString *item in ary) {
            [str appendFormat:@"%@\n",item];
        }
    });
    return str;
}

/** 获取MJExtension序列化支持配置*/
- (NSString *)getMJExtensionSerialize
{
    static dispatch_once_t onceToken;
    static NSMutableString *str = nil;
    dispatch_once(&onceToken, ^{
        str = [[NSMutableString alloc] init];
        NSArray *ary = _coding[@"OC-MJExtension"];
        for (NSString *item in ary) {
            [str appendFormat:@"%@\n",item];
        }
    });
    return str;
}


@end
