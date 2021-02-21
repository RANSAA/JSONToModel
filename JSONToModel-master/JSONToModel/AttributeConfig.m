//
//  AttributeConfig.m
//  JSONToModel
//
//  Created by PC on 2021/2/21.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "AttributeConfig.h"

@implementation AttributeConfig

+ (instancetype)shared
{
    static AttributeConfig *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [AttributeConfig new];
        [obj defaultConfig];
    });
    return obj;
}

- (void)defaultConfig
{
    self.isCompareKey = YES;
}

@end
