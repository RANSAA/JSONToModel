//
//  ConvertModel+YYModel.h
//  JSONToModel
//
//  Created by PC on 2021/2/25.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 json to model 以YYModel为模板
 */

/**
 这儿不应该使用扩展，应该直接继承ConvertModel
 */
#import "ConvertModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConvertModel (YYModel)

- (void)generatedInterfaceYYModel;

- (void)generatedImplementationYYModel;

@end

NS_ASSUME_NONNULL_END
