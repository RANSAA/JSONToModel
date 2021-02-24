//
//  SettingManager.h
//  JSONToModel
//
//  Created by PC on 2021/2/24.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingManager : NSObject
@property (nonatomic, strong) NSArray *allSupportModeName;//获取所有支持模式的名称-NSString
@property (nonatomic, strong) NSArray *allSupportModeType;//获取所有支持模式的的类型-NSNumber
@property (nonatomic, strong) NSMutableString *describeString;//获取用户描述文字
@property (nonatomic, strong) NSArray *mappingkeys;//被影射的关键字数组,数据有序
@property (nonatomic, strong) NSArray *mappingRenames;//被影射的关键字数组，数据有序


+ (instancetype)shared;

/** 根据模式类型获取对应模式名称 */
- (NSString *)getSupportModeNameWith:(NSInteger)type;

/**
 根据解析模式类型获取序列化配置字符串
 */
- (NSString *)getSerializeCofingWith:(NSInteger)type;

/**
 根据原始关键字获取映射后的关键字名称
 */
- (NSString *)getMappingRenameWithMappingKey:(NSString *)mappingKey;

/** 根据被影射后的名称获取原始关键字 */
- (NSString *)getMappingKeyWithMappingRename:(NSString *)mappingRename;

/**根据模型类型加载自定义属性模板 */
- (NSString *)getModelCustomPropertyMapperWithType:(NSInteger)type;

/** 根据模型类型加载自定义属性类型指定模板 */
- (NSString *)getModelCustomPropertyGenericClassWithType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
