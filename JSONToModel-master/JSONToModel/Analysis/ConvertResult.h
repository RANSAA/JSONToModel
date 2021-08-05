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
@property(nonatomic, strong, readonly) NSMutableSet *curImportClassAry;//存储当前所有自定义model name

+ (instancetype)shared;

/** 重置存储环境 */
- (void)resetEnv;

/** 设置当前最外层是第几次循环解析 */
- (void)setConvertIndex:(NSInteger)index;

/**
 添加.h部分进行暂存
 hStr:
 modelName:对应模型名称
 */
- (void)addHString:(NSString *)hStr name:(NSString *)modelName;

/**
 向最后一个model的.h部分追加特定字符串
 */
- (void)addSpecificStringToLastString;

/**
 添加.m部分进行暂存,该部分是可选的
 mStr:
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





#pragma mark 处理查询书否有相同的json字段并且具有相同属性结构
/**
 添加对应的模型名称与原始dic
 */
- (void)addModelName:(NSString *)modelName rootDic:(NSDictionary *)rootDict;
/**
 根据json节点数据查询对应的modelName
 */
- (nullable NSString *)quearyModelNameWithNode:(NSDictionary *)nodeDic;

/** 检查该json节点是否有，父亲json结构解析集合存在*/
- (BOOL)isSubsetOfJsonNode:(NSDictionary *)nodeDic;

/** 检查该json节点是否有，相同json结构解析集合存在*/
- (BOOL)isMemberToJsonNode:(NSDictionary *)nodeDic;


@end






NS_ASSUME_NONNULL_END
