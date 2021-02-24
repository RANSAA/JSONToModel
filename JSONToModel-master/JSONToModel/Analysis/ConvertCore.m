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

@end





