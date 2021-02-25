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
@property(nonatomic, strong) NSMutableArray *aryCustomModelNames;//记录所有生成model(RootModel除外)的名称

+ (instancetype)shared;

/** 重置存储环境 */
- (void)resetEnv;

/**
 添加.h部分进行暂存
 hStr:
 modelName:对应模型名称
 */
- (void)addHString:(NSString *)hStr name:(NSString *)modelName;

/**
 添加.m部分进行暂存
 mStr:
 modelName:对应模型名称
 */
- (void)addMString:(NSString *)mStr;

/**  获取显示文字 */
- (NSString *)getShowString;

/**
 获取需要保存文件的信息
 */
- (NSDictionary *)getModelFileInfo;

/** 保存文件*/
- (void)saveAs;

@end

NS_ASSUME_NONNULL_END
