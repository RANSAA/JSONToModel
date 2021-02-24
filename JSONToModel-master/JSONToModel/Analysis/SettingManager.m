//
//  SettingManager.m
//  JSONToModel
//
//  Created by PC on 2021/2/24.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 配置文件管理工具
 */
#import "SettingManager.h"

@interface SettingManager ()
@property (nonatomic, strong) NSDictionary *rootData;//根数据
@property (nonatomic, strong) NSDictionary *analyticModel;//支持的解析模式
@property (nonatomic, strong) NSDictionary *serializeConfig;//添加序列化配置数据
@property (nonatomic, strong) NSArray *describe;//用户描述
@property (nonatomic, strong) NSDictionary *fieldMapping;//关键字字段映射
@property (nonatomic, strong) NSDictionary *customPropertyMapper;//需要自定义的属性
@property (nonatomic, strong) NSDictionary *customPropertyGenericClass;//需要指定属性的类型
@end

@implementation SettingManager

+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    //加载资源
    NSString *path = [[NSBundle mainBundle] pathForResource:@"OptionalSetting" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _rootData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    _serializeConfig = _rootData[@"SerializeConfig"];
    _analyticModel = _rootData[@"AnalyticModel"];
    _fieldMapping  = _rootData[@"FieldMapping"];
    _describe = _rootData[@"Describe"];
    _customPropertyMapper = _rootData[@"CustomPropertyMapper"];
    _customPropertyGenericClass = _rootData[@"CustomPropertyGenericClass"];
    
    //获取描述文件
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate new]];
    dateFormatter.dateFormat = @"yyyy";
    NSString *year = [dateFormatter stringFromDate:[NSDate new]];
    _describeString = [[NSMutableString alloc] init];
    for (NSString *item in _describe) {
        [_describeString appendFormat:@"%@\n",item];
    }
    NSRange range = [_describeString rangeOfString:@"[时间]"];
    if (range.length != 0) {
        [_describeString replaceCharactersInRange:range withString:dateString];
    }
    range = [_describeString rangeOfString:@"[year]"];
    if (range.length != 0) {
        [_describeString replaceCharactersInRange:range withString:year];
    }
    
    
    //获取所有支持模式名称,模式类型
    NSArray *allKey = _analyticModel.allKeys;
    allKey = [allKey sortedArrayUsingSelector:@selector(compare:)];

    NSMutableArray *allValues = @[].mutableCopy;
    for (NSString *key in allKey) {
        [allValues addObject:_analyticModel[key]];
    }
    _allSupportModeName = allValues.copy;
    _allSupportModeType = allKey.copy;
    
    //关键字映射
    _mappingkeys = _fieldMapping.allKeys;
    _mappingkeys = [_mappingkeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *mappingAllValues = @[].mutableCopy;
    for (NSString *key in _mappingkeys) {
        [mappingAllValues addObject:_fieldMapping[key]];
    }
    _mappingRenames = mappingAllValues.copy;
}


/** 根据模式类型获取对应模式名称 */
- (NSString *)getSupportModeNameWith:(NSInteger)type
{
    NSString *modelName = _allSupportModeName[type];
    return modelName;
}

/**
 根据解析模式类型获取序列化配置字符串
 */
- (NSString *)getSerializeCofingWith:(NSInteger)type
{
    NSString *modelName = _allSupportModeName[type];
    NSArray *serialize = _serializeConfig[modelName];
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSString *item in serialize) {
        [str appendFormat:@"%@\n",item];
    }
    return str.copy;
}


/**
 根据原始关键字获取映射后的关键字名称
 */
- (NSString *)getMappingRenameWithMappingKey:(NSString *)mappingKey
{
    if ([_mappingkeys containsObject:mappingKey]) {
        NSInteger index = [_mappingkeys indexOfObject:mappingKey];
        return _mappingRenames[index];
    }
    return mappingKey;
}

/** 根据被影射后的名称获取原始关键字 */
- (NSString *)getMappingKeyWithMappingRename:(NSString *)mappingRename
{
    if ([_mappingRenames containsObject:mappingRename]) {
        NSInteger index = [_mappingRenames indexOfObject:mappingRename];
        return _mappingkeys[index];
    }
    return mappingRename;
}

/**根据模型类型加载自定义属性模板 */
- (NSString *)getModelCustomPropertyMapperWithType:(NSInteger)type
{
    NSString *name = [self getSupportModeNameWith:type];
    NSArray *ary = _customPropertyMapper[name];
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *item in ary) {
        [mString appendFormat:@"%@\n",item];
    }
    return mString;
}

/** 根据模型类型加载自定义属性类型指定模板 */
- (NSString *)getModelCustomPropertyGenericClassWithType:(NSInteger)type
{
    NSString *name = [self getSupportModeNameWith:type];
    NSArray *ary = _customPropertyGenericClass[name];
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *item in ary) {
        [mString appendFormat:@"%@\n",item];
    }
    return mString;
}

@end
