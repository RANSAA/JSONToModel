//
//  ReadFile.h
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 读取文件数据：
    Describe.json
    Coding.json
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadFile : NSObject

+ (instancetype)shared;

/** 获取用户描述文字 */
- (NSString *)getUserInfo;

/** 获取YYModel序列化支持配置*/
- (NSString *)getYYModelSerialize;

/** 获取JSONModel序列化支持配置*/
- (NSString *)getJSONModelSerialize;

/** 获取MJExtension序列化支持配置*/
- (NSString *)getMJExtensionSerialize;

@end

NS_ASSUME_NONNULL_END
