//
//  ConvertToYYModel.m
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertToYYModel.h"
#import "ConvertCore.h"
#import "Config.h"
#import "ConvertResult.h"



@interface ConvertToYYModel ()
@property(nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation ConvertToYYModel

- (void)start
{
    self.dataAry = @[].mutableCopy;
    
    //重置存储环境
    [ConvertResult.shared resetEnv];
    
    //解析json
    ConvertModel *node = [ConvertModel new];
    node.isRoot = YES;
    node.rootDict = ConvertCore.shared.jsonDict;
    node.modelName = Config.shared.rootName;
    node.baseModelName = Config.shared.baseRootName;
    [node analysisRootDict];
    
}


@end
