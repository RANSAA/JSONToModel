//
//  ConvertJson.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertJson.h"
#import "ConvertCore.h"
#import "ConvertToYYModel.h"
#import "ConvertToJsonModel.h"
#import "ConvertToMJExtension.h"
#import "ConvertResult.h"




@interface ConvertJson ()
@end

@implementation ConvertJson

+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

/** 转换 */
- (void)convert
{
    if (ConvertCore.shared.isVildJson) {
        [self start];
    }
}

/**
 注意：解析时ConvertCore.shared.jsonDict一定是至少有一对key-value的
 */
- (void)start
{
    switch (Config.shared.supportType) {
        case SupportModeTypeYYModel:{            
            [self convertYYModel];
        }
            break;
        case SupportModeTypeJSONModel:{
            
        }
            break;
        case SupportModeTypeMJExtension: {
            
            break;
        }
    }
}

- (void)convertYYModel
{
    //重置存储环境
    [ConvertResult.shared resetEnv];
    
    //解析json
    NSString *rootName = Config.shared.rootName;
    if (Config.shared.isPreSuffixRootModel) {
        rootName = [NSString stringWithFormat:@"%@%@%@",Config.shared.prefixName,rootName,Config.shared.suffixName];
    }
    ConvertModel *node = [ConvertModel new];
    node.isRoot = YES;
    node.rootDict = ConvertCore.shared.jsonDict;
    node.modelName = rootName;
    node.baseModelName = Config.shared.baseRootName;
    [node analysisRootDict];
}

@end
