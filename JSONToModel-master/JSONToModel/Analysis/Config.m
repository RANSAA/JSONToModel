//
//  Config.m
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 解析配置
 */
#import "Config.h"

@implementation Config

+ (instancetype)shared
{
    static Config *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [Config recovery];
        if (!obj) {
            obj = [Config new];
            [obj defaultConfig];
        }
    });
    return obj;
}

- (void)defaultConfig
{
    self.isCompareKey   = YES;
    self.rootName       = @"RootModel";
    self.baseRootName   = @"NSObject";
    self.baseChildName  = @"NSObject";
    
    self.supportMode    = ConvertCore.shared.allSupportMode[0];
    self.supportType    = SupportModeTypeYYModel;
    
    self.isSerialize = YES;
    self.isPascal = YES;
    self.isPreSuffixRootModel = NO;
    self.isMultipleFile = NO;
}

- (void)setRootName:(NSString *)rootName
{
    if (rootName.length<1) {
        rootName = @"RootModel";
    }
    _rootName = rootName;
}

- (void)setBaseRootName:(NSString *)baseRootName
{
    if (baseRootName.length<1) {
        baseRootName = @"NSObject";
    }
    _baseRootName = baseRootName;
}

- (void)setBaseChildName:(NSString *)baseChildName
{
    if (baseChildName.length < 1) {
        baseChildName = @"NSObject";
    }
    _baseChildName = baseChildName;
}

- (void)save
{
    NSData *data = Config.shared.yy_modelToJSONData;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:data forKey:@"DefaultConfig"];
    [user synchronize];
}

+ (nullable Config *)recovery
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user valueForKey:@"DefaultConfig"];
    Config *obj = [Config yy_modelWithJSON:data];
    return obj;
}


// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end
