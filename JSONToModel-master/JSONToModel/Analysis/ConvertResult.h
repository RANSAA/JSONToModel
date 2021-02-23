//
//  ConvertResult.h
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 用于存储转化成功之后的属性model，及其相关提示
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConvertResult : NSObject

@property(nonatomic, strong) NSMutableArray *aryManualHandKey;//记录需要进行手动转换的字段

+ (instancetype)shared;

/** 重置存储环境 */
- (void)resetEnv;

@end

NS_ASSUME_NONNULL_END
