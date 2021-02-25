//
//  ConvertJson.h
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "ConvertCore.h"


NS_ASSUME_NONNULL_BEGIN

@interface ConvertJSONToModel : NSObject

@property (nonatomic, copy) BlockValue completed;//回调-更新输出


+ (instancetype)shared;

/** 转换 */
- (void)convert;


@end

NS_ASSUME_NONNULL_END
