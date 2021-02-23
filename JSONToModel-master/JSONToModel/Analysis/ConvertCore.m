//
//  ConvertCore.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertCore.h"
#import "Config.h"
#import "ConvertResult.h"
#import "ReadFile.h"



@implementation ConvertCore

+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

/**
 所有支持的解析类型:
 OC-YYModel
 OC-JSONModel
 OC-MJExtension
 */
- (NSArray<NSString *> *)allSupportMode
{
    return @[@"OC-YYModel",
             @"OC-JSONModel",
             @"OC-MJExtension"
    ];
}

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
        _hString = [[NSMutableString alloc] init];
        _mString = [[NSMutableString alloc] init];
        _childModelTypeDic = @{}.mutableCopy;
        _childModelTypeAry = @{}.mutableCopy;
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
    
    NSMutableArray *allValue = @[].mutableCopy;
    for (NSString *key in allKeys) {
        id value = _rootDict[key];
        [allValue addObject:value];
    }
    
    //递归处理所有key，value
    for (NSInteger index=0; index<allValue.count; index++) {
        NSString *key = allKeys[index];
        id value = allValue[index];
        //属性类型获取
        NSString *type = [self attrTypeWithValue:value];
        [_aryAttrType addObject:type];
        [self codeChildModeWithKey:key value:value type:type index:index model:self];
    }
    
    [self generateInterface];
    
    [self generateImplementation];
    
    NSLog(@"des:\n%@",self);
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


- (NSString *)pascalName:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *tmpName = [[NSMutableString alloc] initWithString:name];
    NSLog(@"tmpName:%@",tmpName);

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
    NSLog(@"tmpName-upperStr:%@",tmpName);
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
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL\t\t%@; \n",key];
    }else if ([type isEqualToString:@"CGFloat"]){
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) CGFloat\t%@; \n",key];
    }else if ([type isEqualToString:@"NSInteger"]) {
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger\t%@; \n",key];
    }else if ([type isEqualToString:@"NSString"]){
        str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString*\t%@; \n",key];
    }else if ([type isEqualToString:@"NSArray"]){
        str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray*\t%@; \n",key];
    }else{//NSDictionary to child Model
        str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@*\t%@; \n",type,key];

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
}

- (void)interfaceYYModel
{
    NSString *mark = [ReadFile.shared getUserInfo];
    NSString *markModelName = [NSString stringWithFormat:@"%@.h",_modelName];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    [_hString appendString:mark];
    [_hString appendString:@"#import <UIKit/UIKit.h>\n\n"];
    [_hString appendFormat:@"@interface %@ : %@\n\n",_modelName,_baseModelName];
    for (NSInteger i=0; i<_aryAttrName.count; i++) {
        NSString *key = _aryAttrName[i];
        id type = _aryAttrType[i];
        NSString *perStr = [self generateAttrStringWithKey:key type:type];
        [_hString appendString:perStr];
    }
    [_hString appendFormat:@"\n@end \n\n"];
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
}

- (void)implementationYYModel
{
    NSString *mark = [ReadFile.shared getUserInfo];
    NSString *markModelName = [NSString stringWithFormat:@"%@.m",_modelName];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    [_mString appendString:mark];
    [_mString appendFormat:@"#import \"%@.h\" \n\n",_modelName];
    [_mString appendFormat:@"@implementation %@ \n",_modelName];
    if (Config.shared.isSerialize) {
        [_mString appendFormat:@"%@",[ReadFile.shared getYYModelSerialize]];
    }
    //映射如字段 default， switch等关键字作为字段
    
    //自定义数据类型
    
    [_mString appendFormat:@"\n@end \n\n"];
}

@end
