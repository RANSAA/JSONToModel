//
//  ConvertJson.h
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"


NS_ASSUME_NONNULL_BEGIN

@interface ConvertJson : NSObject

+ (instancetype)shared;

/** 转换 */
- (void)convert;


@end

NS_ASSUME_NONNULL_END
