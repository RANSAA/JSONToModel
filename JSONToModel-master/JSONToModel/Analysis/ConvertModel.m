//
//  ConvertModel.m
//  JSONToModel
//
//  Created by PC on 2021/2/24.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertModel.h"
#import "Config.h"
#import "ConvertResult.h"
#import "SettingManager.h"
#import "NSDictionary+JSON.h"


@interface ConvertModel ()
@end

@implementation ConvertModel


// 直接添加以下代码即可自动完成
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

- (instancetype)init
{
    if (self = [super init]) {
        _aryAttrName = @[].mutableCopy;
        _aryAttrType = @[].mutableCopy;
        _aryAttrValues = @[].mutableCopy;
        _hString = [[NSMutableString alloc] init];
        _mString = [[NSMutableString alloc] init];
        _childModelTypeDic = @{}.mutableCopy;
        _childModelTypeAry = @{}.mutableCopy;
        _mappingPorpertys  = @{}.mutableCopy;
    }
    return self;
}

- (void)analysisRootDict
{
    NSArray *allKeys = [_rootDict allKeys];
    if (Config.shared.isCompareKey) {
        allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    }
    [_aryAttrName addObjectsFromArray:allKeys];
    for (NSString * key in _aryAttrName) {
        [_aryAttrValues addObject:_rootDict[key]];
    }
    
    //关键字映射
    [self checkPorpertyMapping];
    
    
    //递归处理所有key，value
    for (NSInteger index=0; index<_aryAttrValues.count; index++) {
        NSString *key = _aryAttrName[index];
        id value = _aryAttrValues[index];
        NSString *type = [self attrTypeWithValue:value];//属性类型获取
        [_aryAttrType addObject:type];
        [self codeChildModeWithKey:key value:value type:type index:index model:self];
    }
    
    
    [self generateInterface];
    
    [self generateImplementation];
    
    [self saveJsonToModelPorperty];
    
//    NSLog(@"des:\n%@",self);
}

//检查关键字属性是否需要映射
- (void)checkPorpertyMapping
{
    for (NSInteger i =0; i<_aryAttrName.count; i++) {
        NSString *originalKey = _aryAttrName[i];
        if ([SettingManager.shared.mappingkeys containsObject:originalKey]) {//需要进行映射转换
            NSString *rename = [SettingManager.shared getMappingRenameWithMappingKey:originalKey];
            _aryAttrName[i] = rename;
            [_mappingPorpertys addEntriesFromDictionary:@{rename:originalKey}];
        }
    }

}


/**
 处理child model
 key：对应属性名称
 value：对应的值
 type：属性对应的类型
 index：该属性位于所有属性的位置
 */
- (void)codeChildModeWithKey:(NSString *)key value:(id)value type:(NSString *)type index:(NSInteger)index model:(ConvertModel *)node;
{
    NSString *dicChildKey = [NSString stringWithFormat:@"%ld",index];
    if ([type isEqualToString:@"NSArray"]) {
        if (Config.shared.supportType == SupportModeTypeYYModel) {
            NSString *modelName = [self pascalName:key];
            node.aryAttrType[index] = @"NSArray";
            NSArray *ary = (NSArray *)value;
            if (ary.count>0) {
                id item = ary[0];
                if ([item isKindOfClass:NSArray.class]) {//数组中的item依然是一个数组,这儿只能处理Array.Array中的item为同一种类型的数据结构
//                    [node.childModelTypeAry setValue:modelName forKey:dicChildKey];
//                    NSArray *itemAry = ary[0];
//                    NSLog(@"NSArray tmp:%@",itemAry);
                    
                    //目前这儿进行提示手动添加未转化成功的属性
                    NSLog(@"需要手动添加属性的字段:%@",key);
                    [ConvertResult.shared.aryManualHandKey addObject:key];
                    
                }else if ([item isKindOfClass:NSDictionary.class]){//数组的item是Dic
                    [node.childModelTypeAry setValue:modelName forKey:dicChildKey];
                    
                    item = [self maxItemWithArray:ary];
                    
                    //添加前后缀
                    modelName = [NSString stringWithFormat:@"%@%@%@",Config.shared.prefixName,modelName,Config.shared.suffixName];
                    //创建新的节点，进行递归
                    ConvertModel *childDode = [ConvertModel new];
                    childDode.isRoot = NO;
                    childDode.modelName = modelName;
                    childDode.baseModelName = Config.shared.baseChildName;
                    childDode.rootDict = item;
                    [childDode analysisRootDict];
                }
            }
        }
        
    }else if ([type isEqualToString:@"NSDictionary"]){
        if (Config.shared.supportType == SupportModeTypeYYModel) {
            NSString *modelName = [self pascalName:key];
            [node.childModelTypeDic setValue:modelName forKey:dicChildKey];
            node.aryAttrType[index] = modelName;
            
            //添加前后缀
            modelName = [NSString stringWithFormat:@"%@%@%@",Config.shared.prefixName,modelName,Config.shared.suffixName];
            //创建新的节点，进行递归
            ConvertModel *childDode = [ConvertModel new];
            childDode.isRoot = NO;
            childDode.modelName = modelName;
            childDode.baseModelName = Config.shared.baseChildName;
            childDode.rootDict = value;
            [childDode analysisRootDict];
            
        }
    }
}


///**
// 递归处理数组中嵌套数组的模式
// ps:目前未使用，留到以后更新
// */
//- (void)loopArrayToArrayWithKey:(NSString *)key value:(id)value index:(NSInteger)index model:(ConvertModel *)node;
//{
//    NSString *dicChildKey = [NSString stringWithFormat:@"%ld",index];
//    NSString *modelName = [self pascalName:key];
//
//    node.aryAttrType[index] = @"NSArray";
//    //
//    NSArray *ary = (NSArray *)value;
//    if (ary.count>0) {
//        id item = ary[0];
//        if ([item isKindOfClass:NSArray.class]) {//数组中的item依然是一个数组,这儿只能处理Array.Array中的item为同一种类型的数据结构
//            //这儿需要
//            [node.childModelTypeAry setValue:modelName forKey:dicChildKey];
//            //
//            NSArray *itemAry = ary[0];
//            NSLog(@"NSArray tmp:%@",itemAry);
//
//
//        }else if ([item isKindOfClass:NSDictionary.class]){//数组的item是Dic
//            [node.childModelTypeAry setValue:modelName forKey:dicChildKey];
//            item = [self maxItemWithArray:ary];
//            //创建新的节点，进行递归
//            ConvertModel *childDode = [ConvertModel new];
//            childDode.isRoot = NO;
//            childDode.modelName = modelName;
//            childDode.baseModelName = Config.shared.baseChildName;
//            childDode.rootDict = item;
//            [childDode analysisRootDict];
//        }
//    }
//}

/**
 获取数组中最大的item，数组的类型为NSDictionary
 */
- (id)maxItemWithArray:(NSArray *)ary
{
    id item = nil;
    NSInteger index = 0;
    NSInteger count = 0;
    NSInteger i=0;
    for (NSDictionary *node in ary) {
        if (node.allKeys.count>count) {
            count = node.allKeys.count;
            index = i;
        }
        i++;
    }
    item = ary[index];
    return item;
}

//帕斯卡命名
- (NSString *)pascalName:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *tmpName = [[NSMutableString alloc] initWithString:name];
    if (Config.shared.isPascal) {
        // "_"处首字母大写
        NSRange range = [tmpName rangeOfString:@"_"];
        while (range.length>0) {
            [tmpName replaceCharactersInRange:range withString:@""];
            NSString *upperStr = [tmpName substringWithRange:range];
            upperStr = upperStr.uppercaseString;
            [tmpName replaceCharactersInRange:range withString:upperStr];
            range = [tmpName rangeOfString:@"_"];
        }
        //首字母大写
        range = NSMakeRange(0, 1);
        NSString *upperStr = [tmpName substringWithRange:range];
        upperStr = upperStr.uppercaseString;
        [tmpName replaceCharactersInRange:range withString:upperStr];
    }
    return tmpName;
}

//根据value的值获取key的类型
- (NSString *)attrTypeWithValue:(id)value
{
    NSString *type = @"NSString";
    if ([value isKindOfClass:NSString.class]) {
        type = @"NSString";
    }else if ([value isKindOfClass:NSNumber.class]){
        if ((strcmp([value objCType], @encode(float)) == 0) || (strcmp([value objCType], @encode(double)) == 0)){
            type = @"CGFloat";
        }else if (strcmp([value objCType], @encode(BOOL)) == 0){
            type = @"BOOL";
        }else{
            type = @"NSInteger";
        }
    }else if ([value isKindOfClass:NSArray.class]){
        type = @"NSArray";
    }else if ([value isKindOfClass:NSDictionary.class]){
        type = @"NSDictionary";
    }
    return type;
}

/**
 生成属性描述字符串
 key:属性名称，对应key值
 type：属性对应的类型
 */
- (NSString *)generateAttrStringWithKey:(NSString *)key type:(NSString *)type
{
    NSString *str = @"";
    if ([type isEqualToString:@"BOOL"]) {
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;\n",key];
    }else if ([type isEqualToString:@"CGFloat"]){
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) CGFloat %@;\n",key];
    }else if ([type isEqualToString:@"NSInteger"]) {
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;\n",key];
    }else if ([type isEqualToString:@"NSString"]){
        str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;\n",key];
    }else if ([type isEqualToString:@"NSArray"]){
        //判断容器内的模型，进行标记
        NSString *modelName = [self pascalName:key];
        if ([_childModelTypeAry.allValues containsObject:modelName]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;//%@ \n",key,modelName];
        }else{
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n",key];
        }
    }else{//NSDictionary to child Model
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;\n",type,key];
    }
    return str;
}

#pragma mark 合成interface部分,即 .h文件部分
- (void)generateInterface
{
    switch (Config.shared.supportType) {
        case SupportModeTypeYYModel:{
            [self interfaceYYModel];
        }
            break;
            
        default:
            break;
    }
    //暂存
    [ConvertResult.shared addHString:_hString name:_modelName];
}

#pragma mark 合成Implementation部分,即 .m文件部分
- (void)generateImplementation
{
    switch (Config.shared.supportType) {
        case SupportModeTypeYYModel:{
            [self implementationYYModel];
        }
            break;
            
        default:
            break;
    }
    //暂存
    [ConvertResult.shared addMString:_mString];
}

#pragma mark 保存json转换结果
- (void)saveJsonToModelPorperty
{
    
}


- (void)interfaceYYModel
{
    [self customHeaderString];
    
    //属性编辑区域
    for (NSInteger i=0; i<_aryAttrName.count; i++) {
        NSString *key = _aryAttrName[i];
        id type = _aryAttrType[i];
        NSString *perStr = [self generateAttrStringWithKey:key type:type];
        [_hString appendString:perStr];
    }
    
    [_hString appendFormat:@"\n@end \n\n"];
}


- (void)implementationYYModel
{
    [self customImplementString];


    [self customSerialize];

    [self customPropertyMapper];
    
    [self customPropertyGenericClass];

    [_mString appendFormat:@"@end \n\n"];
}



#pragma mark 自定义设置区域
//自定义header提示区域
- (void)customHeaderString
{
    NSString *mark = SettingManager.shared.describeString;
    NSString *markModelName = [NSString stringWithFormat:@"%@.h",_modelName];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    NSMutableArray *aryCustomModel = @[].mutableCopy;
    [aryCustomModel addObjectsFromArray:_childModelTypeDic.allValues];
    [aryCustomModel addObjectsFromArray:_childModelTypeAry.allValues];
    [ConvertResult.shared.aryCustomModelNames addObjectsFromArray:aryCustomModel];
    if (Config.shared.isMultipleFile) {
        [_hString appendString:mark];
        [_hString appendString:@"#import <UIKit/UIKit.h>\n"];
        for (NSString *h in aryCustomModel) {
            [_hString appendFormat:@"#import \"%@.h\"\n",h];
        }
        [_hString appendString:@"\n\n"];
    }else{
        if (_isRoot) {
           [_hString appendString:mark];
            [_hString appendString:@"#import <UIKit/UIKit.h>\n\n"];
            
            if (ConvertResult.shared.aryCustomModelNames.count>0) {
                NSMutableString *exClass = [[NSMutableString alloc] initWithString:@"@class "];
                NSInteger i = 0;
                for (NSString *n in ConvertResult.shared.aryCustomModelNames) {
                    if (i==ConvertResult.shared.aryCustomModelNames.count-1) {
                        [exClass appendFormat:@"%@;",n];
                    }else{
                        [exClass appendFormat:@"%@,",n];
                    }
                    i++;
                }
                [_hString appendFormat:@"\n%@\n",exClass];
            }
        }
    }
    
    [_hString appendFormat:@"@interface %@ : %@\n\n",_modelName,_baseModelName];

}

- (void)customImplementString
{
    NSString *mark = SettingManager.shared.describeString;
    NSString *markModelName = [NSString stringWithFormat:@"%@.m",_modelName];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    if (Config.shared.isMultipleFile) {
        [_mString appendString:mark];
        [_mString appendFormat:@"#import \"%@.h\" \n\n",_modelName];
    }else{
        if (_isRoot) {
           [_mString appendString:mark];
            [_mString appendFormat:@"#import \"%@.h\" \n\n",_modelName];

        }
    }
    [_mString appendFormat:@"@implementation %@ \n\n",_modelName];
}

//处理序列化设置
- (void)customSerialize
{
    if (Config.shared.isSerialize) {
        SupportModeType type = Config.shared.supportType;
        switch (type) {
            case SupportModeTypeYYModel:{
                [_mString appendFormat:@"%@\n",[SettingManager.shared getSerializeCofingWith:Config.shared.supportType]];
            }
                break;
                
            default:
                break;
        }
    }
}

//处理映射如字段 default， switch等关键字作为字段
- (void)customPropertyMapper
{
    if (_mappingPorpertys.allKeys.count>0) {
        SupportModeType type = Config.shared.supportType;
        switch (type) {
            case SupportModeTypeYYModel:{
                NSString *dicStr = [_mappingPorpertys toPorpertyString];
                NSString *mappingStr = [SettingManager.shared getModelCustomPropertyMapperWithType:type];
                mappingStr = [mappingStr stringByReplacingOccurrencesOfString:@"[dicString]" withString:dicStr];
                [_mString appendFormat:@"%@\n",mappingStr];
            }
                break;
                
            default:
                break;
        }
    }
}

//处理属性对应类型申明
- (void)customPropertyGenericClass
{
    if (_childModelTypeAry.allKeys.count>0) {
        SupportModeType type = Config.shared.supportType;
        switch (type) {
            case SupportModeTypeYYModel:{
                NSString *dicStr = [self toGenericClassString];
                NSString *mappingStr = [SettingManager.shared getModelCustomPropertyGenericClassWithType:type];
                mappingStr = [mappingStr stringByReplacingOccurrencesOfString:@"[dicString]" withString:dicStr];
                [_mString appendFormat:@"%@\n",mappingStr];
            }
                break;
                
            default:
                break;
        }
    }
}

- (NSString *)toGenericClassString
{
    NSMutableString *classStr = [[NSMutableString alloc] init];
    BOOL insert = NO;
    for (NSString *key in _childModelTypeAry.allKeys) {
        insert = YES;
        NSString *attrName = _aryAttrName[key.integerValue];
        NSString *attrClass = _childModelTypeAry[key];
        [classStr appendFormat:@"@\"%@\" : %@.class,\n",attrName,attrClass];
    }
//    for (NSString *key in _childModelTypeDic.allKeys) {
//        insert = YES;
//        NSString *attrName = _aryAttrName[key.integerValue];
//        NSString *attrClass = _childModelTypeDic[key];
//        [classStr appendFormat:@"@\"%@\" : %@.class,\n",attrName,attrClass];
//    }
    if (insert) {
        NSRange range = NSMakeRange(classStr.length-2, 2);
        NSString *endString = [classStr substringWithRange:range];
        NSLog(@"endString:%@",endString);
        if ([endString isEqualToString:@",\n"]) {
            [classStr deleteCharactersInRange:range];
        }
        [classStr insertString:@"@{" atIndex:0];
        [classStr appendString:@"}"];
    }
    return classStr;
}

@end
