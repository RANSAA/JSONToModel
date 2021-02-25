//
//  ConvertJson.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertJSONToModel.h"
#import "ConvertCore.h"
#import "ConvertResult.h"
#import "ConvertModel.h"


@interface ConvertJSONToModel ()
@end

@implementation ConvertJSONToModel

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
        [self convertToModel];
    }
}


- (void)convertToModel
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
    
    
    //处理转换结果
    [self convertResult];
}

- (void)convertResult
{
    if (self.completed) {
        self.completed([ConvertResult.shared getShowString]);
    }
}

@end
