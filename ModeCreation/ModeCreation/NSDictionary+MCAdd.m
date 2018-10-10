//
//  NSDictionary+MCAdd.m
//  ModeCreation
//
//  Created by Aka on 2018/10/10.
//  Copyright © 2018年 Laterite. All rights reserved.
//

#import "NSDictionary+MCAdd.h"

@implementation NSDictionary (MCAdd)

+ (NSDictionary *)dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        NSError *error = nil;
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            dic = nil;
            NSLog(@"string to dict error :%@",error);
        }
    }
    return dic;
}

@end
