//
//  ConvertResult.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertResult.h"

@implementation ConvertResult
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
        _aryManualHandKey = @[].mutableCopy;
        _aryCustomModelNames = @[].mutableCopy;
        
    }
    return self;
}

/** 重置存储环境 */
- (void)resetEnv
{
    [_aryManualHandKey removeAllObjects];
    [_aryCustomModelNames removeAllObjects];
}

@end
