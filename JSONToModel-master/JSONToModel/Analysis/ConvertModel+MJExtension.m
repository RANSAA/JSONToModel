//
//  ConvertModel+MJExtension.m
//  JSONToModel
//
//  Created by PC on 2021/2/25.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertModel+MJExtension.h"
#import "SettingManager.h"
#import "ConvertResult.h"
#import "Config.h"
#import "NSDictionary+JSON.h"

@implementation ConvertModel (MJExtension)


#pragma mark @interface部分
- (void)generatedInterfaceMJExtension
{
    [self customHeaderString];
    
    //属性编辑区域
    for (NSInteger i=0; i<self.aryAttrName.count; i++) {
        NSString *key = self.aryAttrName[i];
        id type = self.aryAttrType[i];
        NSString *perStr = [self generateAttrStringWithKey:key type:type];
        [self.hString appendString:perStr];
    }
    
    [self.hString appendFormat:@"\n@end \n\n"];
}

//自定义header提示区域
- (void)customHeaderString
{
    NSString *mark = SettingManager.shared.describeString;
    NSString *markModelName = [NSString stringWithFormat:@"%@.h",self.modelName];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    NSMutableArray *aryCustomModel = @[].mutableCopy;
    [aryCustomModel addObjectsFromArray:self.childModelTypeDic.allValues];
    [aryCustomModel addObjectsFromArray:self.childModelTypeAry.allValues];
    //
    [ConvertResult.shared.aryCustomModelNames addObjectsFromArray:aryCustomModel];
    if (Config.shared.isMultipleFile) {
        [self.hString appendString:mark];
        [self.hString appendString:@"#import <UIKit/UIKit.h>\n"];
        for (NSString *h in aryCustomModel) {
            [self.hString appendFormat:@"#import \"%@.h\"\n",h];
        }
        [self.hString appendString:@"\n\n"];
    }else{
        if (self.isRoot) {
            [self.hString appendString:mark];
            [self.hString appendString:@"#import <UIKit/UIKit.h>\n\n"];
            
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
                [self.hString appendFormat:@"\n%@\n",exClass];
            }
        }
    }
    
    [self.hString appendFormat:@"@interface %@ : %@\n\n",self.modelName,self.baseModelName];
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
        if ([self.childModelTypeAry.allValues containsObject:modelName]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;//%@ \n",key,modelName];
        }else{
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n",key];
        }
    }else{//NSDictionary to child Model
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;\n",type,key];
    }
    return str;
}


#pragma mark @implementation部分
- (void)generatedImplementationMJExtension
{
    [self customImplementString];
    [self customSerialize];
    [self customPropertyMapper];
    [self customPropertyGenericClass];

    [self.mString appendFormat:@"@end \n\n"];
}

//.m文件头部自定义
- (void)customImplementString
{
    NSString *mark = SettingManager.shared.describeString;
    NSString *markModelName = [NSString stringWithFormat:@"%@.m",self.modelName];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    if (Config.shared.isMultipleFile) {
        [self.mString appendString:mark];
        [self.mString appendFormat:@"#import \"%@.h\" \n\n",self.modelName];
    }else{
        if (self.isRoot) {
            [self.mString appendString:mark];
            [self.mString appendFormat:@"#import \"%@.h\" \n\n",self.modelName];

        }
    }
    [self.mString appendFormat:@"@implementation %@ \n\n",self.modelName];
}

//如果模板支持序列化，在此定制
- (void)customSerialize
{
    if (Config.shared.isSerialize) {
        [self.mString appendFormat:@"%@\n",[SettingManager.shared getSerializeCofingWith:Config.shared.supportType]];
    }
}

//处理被重命名过的字段属性的映射说明
- (void)customPropertyMapper
{
    if (self.mappingPorpertys.allKeys.count>0) {
        SupportModeType type = Config.shared.supportType;
        NSString *dicStr = [self.mappingPorpertys toPorpertyString];
        NSString *mappingStr = [SettingManager.shared getModelCustomPropertyMapperWithType:type];
        mappingStr = [mappingStr stringByReplacingOccurrencesOfString:@"[dicString]" withString:dicStr];
        [self.mString appendFormat:@"%@\n",mappingStr];
    }
}

//处理属性对应类型申明
- (void)customPropertyGenericClass
{
    if (self.childModelTypeAry.allKeys.count>0) {
        SupportModeType type = Config.shared.supportType;
        NSString *dicStr = [self toGenericClassString];
        NSString *mappingStr = [SettingManager.shared getModelCustomPropertyGenericClassWithType:type];
        mappingStr = [mappingStr stringByReplacingOccurrencesOfString:@"[dicString]" withString:dicStr];
        [self.mString appendFormat:@"%@\n",mappingStr];
    }
}

@end
