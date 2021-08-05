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

#import "ConvertModel+YYModel.h"
#import "ConvertModel+MJExtension.h"


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
        
        _importClassSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)analysisRootDict
{
    if (![_rootDict isKindOfClass:NSDictionary.class]) {
        NSLog(@"_rootDict class :%@     value:%@",[_rootDict class],_rootDict);
        return;
    }
    
    //获取有序的allKeys,allValues
    [_aryAttrName addObjectsFromArray:[_rootDict allSortedKeys]];
    [_aryAttrValues addObjectsFromArray:[_rootDict allSortedValues]];
    
    
    //先检查是否hump命名
    [self checkHumpPorpertyMapping];
    
    //关键字映射
    [self checkPorpertyMapping];
    
    
    //json节点结构存储
    [ConvertResult.shared addModelName:_modelName rootDic:_rootDict];
    
    
    //递归处理所有key，value
    for (NSInteger index=0; index<_aryAttrValues.count; index++) {
        NSString *porpertyName = _aryAttrName[index];
        id value = _aryAttrValues[index];
        NSString *type = [ConvertCore attrTypeWithValue:value];//属性类型获取
        [_aryAttrType addObject:type];
        [self codeChildModeWithPorpertyName:porpertyName value:value type:type index:index model:self];

    }
    
    
    [self interface];

    
    [self implementation];
    
    
//    NSLog(@"des:\n%@",self);
}

//是否对属性进行hump命名
- (void)checkHumpPorpertyMapping
{
    if (Config.shared.isHump) {
        for (NSInteger i =0; i<_aryAttrName.count; i++) {
            NSString *originalKey = _aryAttrName[i];
            NSString *humpName = [ConvertCore humpName:originalKey];
            if (![originalKey isEqualToString:humpName]) {
                _aryAttrName[i] = humpName;
                [_mappingPorpertys addEntriesFromDictionary:@{humpName:originalKey}];
            }
         }
    }
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
- (void)codeChildModeWithPorpertyName:(NSString *)porpertyName value:(id)value type:(NSString *)type index:(NSInteger)index model:(ConvertModel *)node
{
    NSString *chlidDicKey = [NSString stringWithFormat:@"%ld",index];
    if ([value isKindOfClass:NSDictionary.class]) {
        BOOL isJsonModel = NO;
        if (Config.shared.duplicateType == DuplicateModeStandard) {//标准
            isJsonModel = [ConvertResult.shared isMemberToJsonNode:value];
        }else if (Config.shared.duplicateType == DuplicateModeLeast){//最少
            isJsonModel = [ConvertResult.shared isSubsetOfJsonNode:value];
        }else{//全部
            isJsonModel = NO;
        }
        NSString *modelName = [ConvertCore pascalName:porpertyName];
        if (isJsonModel) {
            modelName = [ConvertResult.shared quearyModelNameWithNode:value];
        }else{
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
        node.aryAttrType[index] = modelName;//修改对应属性类型
        [self.importClassSet addObject:modelName];
        [ConvertResult.shared.curImportClassAry addObject:modelName];
        
    }else if ([value isKindOfClass:NSArray.class]){
        node.aryAttrType[index] = kAry;
        NSArray *aryNode = (NSArray *)value;
        if (aryNode.count > 0) {
            id item = aryNode[0];
            if ([item isKindOfClass:NSDictionary.class]) {
                id maxDic = [self maxItemWithArray:value];
                BOOL isJsonModel = NO;
                if (Config.shared.duplicateType == DuplicateModeStandard) {//标准
                    isJsonModel = [ConvertResult.shared isMemberToJsonNode:maxDic];
                }else if (Config.shared.duplicateType == DuplicateModeLeast){//最少
                    isJsonModel = [ConvertResult.shared isSubsetOfJsonNode:maxDic];
                }else{//全部
                    isJsonModel = NO;
                }
                
                NSString *modelName = [ConvertCore pascalName:porpertyName];
                if (isJsonModel) {
                    modelName = [ConvertResult.shared quearyModelNameWithNode:maxDic];
                }else{
                    //添加前后缀
                    modelName = [NSString stringWithFormat:@"%@%@%@",Config.shared.prefixName,modelName,Config.shared.suffixName];
                    //创建新的节点，进行递归
                    ConvertModel *childDode = [ConvertModel new];
                    childDode.isRoot = NO;
                    childDode.modelName = modelName;
                    childDode.baseModelName = Config.shared.baseChildName;
                    childDode.rootDict = maxDic;
                    [childDode analysisRootDict];
                }
                
                [self.importClassSet addObject:modelName];
                [ConvertResult.shared.curImportClassAry addObject:modelName];
                [node.childModelTypeAry setValue:modelName forKey:chlidDicKey];                
            }else{
                
                NSLog(@"⚠️⚠️需要手动添加属性的字段:%@",porpertyName);
                [ConvertResult.shared.aryManualHandKey addObject:porpertyName];
                
                
            }
        }
        
    }
}


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



#pragma mark 合成interface部分,即 .h文件部分
- (void)interface
{
    switch (Config.shared.supportType) {
        case SupportModeTypeYYModel:{
            [self generatedInterfaceYYModel];
        }
            break;
        case SupportModeTypeMJExtension:{
            [self generatedInterfaceMJExtension];
        }
            break;
            
        default:
            break;
    }
    //暂存
    [ConvertResult.shared addHString:_hString name:_modelName];

}

#pragma mark 合成Implementation部分,即 .m文件部分
- (void)implementation
{
    switch (Config.shared.supportType) {
        case SupportModeTypeYYModel:{
            [self generatedImplementationYYModel];
        }
            break;
        case SupportModeTypeMJExtension:{
            [self generatedImplementationMJExtension];
        }
            break;
            
        default:
            break;
    }
    
    //暂存
    [ConvertResult.shared addMString:_mString];
}




#pragma mark 额外的数据处理

/**
 返回需要对自定义属性申明类型的字符串
 return @{@"key":Type.class};
 */
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

#pragma mark 判断两个数组中的数据元素是否相同
- (BOOL)isEqual:(NSArray *)aryA compare:(NSArray *)aryB
{
    BOOL equal = YES;
    if (aryA.count == aryB.count) {
        static NSMutableArray *tmpA = nil;
        static NSMutableArray *tmpB = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            tmpA = @[].mutableCopy;
            tmpB = @[].mutableCopy;
        });
        [tmpA addObjectsFromArray:aryA];
        [tmpB addObjectsFromArray:aryB];
        NSInteger index = 0;
        for (NSString *a in tmpA) {
            NSString *b = tmpB[index];
            if (![a isEqualToString:b]) {
                equal = NO;
                break;
            }
            index++;
        }
        [tmpA removeAllObjects];
        [tmpB removeAllObjects];
    }else{
        equal = NO;
    }
    return equal;
}

//数组转字符串
- (NSString *)stringWithArray:(NSArray *)ary
{
    NSMutableString *mStr = [[NSMutableString alloc] init];
    ary = [ary sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *str  in ary) {
        [mStr appendString:str];
    }
    return mStr;
}

//字典所有key转字符串
- (NSString *)stringWithDictAllKey:(NSDictionary *)dict
{
    NSMutableString *mStr = [[NSMutableString alloc] init];
    NSArray *ary = dict.allKeys;
    ary = [ary sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *str  in ary) {
        [mStr appendString:str];
    }
    return mStr;
}




@end
