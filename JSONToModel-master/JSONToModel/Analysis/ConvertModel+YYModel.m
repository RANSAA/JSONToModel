//
//  ConvertModel+YYModel.m
//  JSONToModel
//
//  Created by PC on 2021/2/25.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertModel+YYModel.h"
#import "SettingManager.h"
#import "ConvertResult.h"
#import "Config.h"
#import "NSDictionary+JSON.h"


@implementation ConvertModel (YYModel)


#pragma mark @interface部分
- (void)generatedInterfaceYYModel
{
    [self yy_customHeaderString];
    
    [self yy_editArea];
    
    [self.hString appendFormat:@"\n@end \n\n"];
}

//属性编辑区域
- (void)yy_editArea
{
    for (NSInteger i=0; i<self.aryAttrName.count; i++) {
        NSString *key = self.aryAttrName[i];
        id type = self.aryAttrType[i];
        NSString *perStr = [self yy_generateAttrStringWithKey:key type:type index:i];
        [self.hString appendString:perStr];
    }
}

//自定义header提示区域
- (void)yy_customHeaderString
{
    NSString *mark = SettingManager.shared.describeString;
    NSString *markModelName = [NSString stringWithFormat:@"%@.%@",self.modelName,[ConvertCore.shared hPartSuffix]];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    if (Config.shared.isMultipleFile) {
        [self.hString appendString:mark];
        [self.hString appendString:@"#import <UIKit/UIKit.h>\n"];
        for (NSString *h in self.importClassSet) {
            [self.hString appendFormat:@"#import \"%@.%@\"\n",h,[ConvertCore.shared hPartSuffix]];
        }
        [self.hString appendString:@"\n\n"];
    }else{
        if (self.isRoot) {
            [self.hString appendString:mark];
            [self.hString appendString:@"#import <UIKit/UIKit.h>\n\n\n"];
            
            for (NSString *n in ConvertResult.shared.curImportClassAry) {
                [self.hString appendFormat:@"@class %@;\n",n];
            }
        }
    }
    
    [self.hString appendFormat:@"@interface %@ : %@\n\n",self.modelName,self.baseModelName];
}


/**
 生成属性描述字符串
 key:属性名称，对应key值
 type：属性对应的类型
 index:当前属性的位置
 */
- (NSString *)yy_generateAttrStringWithKey:(NSString *)key type:(NSString *)type index:(NSInteger)index
{
    NSString *str = @"";
    if ([type isEqualToString:kBool]) {
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;\n",key];
    }else if ([type isEqualToString:kFloat]){
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) CGFloat %@;\n",key];
    }else if ([type isEqualToString:kInt]) {
        str = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;\n",key];
    }else if ([type isEqualToString:kString]){
        str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;\n",key];
    }else if ([type isEqualToString:kAry]){
        //判断容器内的模型，进行标记
        NSString *row = [NSString stringWithFormat:@"%ld",index];
        if ([self.childModelTypeAry.allKeys containsObject:row]) {
            NSString *modelName = self.childModelTypeAry[row];
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
- (void)generatedImplementationYYModel
{
    [self yy_customImplementString];
    [self yy_customSerialize];
    [self yy_customPropertyMapper];
    [self yy_customPropertyGenericClass];
    
    [self.mString appendFormat:@"@end \n\n"];
}

//.m文件头部自定义
- (void)yy_customImplementString
{
    NSString *mark = SettingManager.shared.describeString;
    NSString *markModelName = [NSString stringWithFormat:@"%@.%@",self.modelName,[ConvertCore.shared mPartSuffix]];
    mark = [mark stringByReplacingOccurrencesOfString:@"ModelName" withString:markModelName];
    BOOL isImport = NO;
    if (Config.shared.isMultipleFile || self.isRoot) {
        isImport = YES;
    }
    if (isImport) {
        [self.mString appendString:mark];
        [self.mString appendFormat:@"#import \"%@.%@\" \n\n",self.modelName,[ConvertCore.shared hPartSuffix]];
    }
    [self.mString appendFormat:@"@implementation %@ \n\n",self.modelName];
}

//如果模板支持序列化，在此定制
- (void)yy_customSerialize
{
    if (Config.shared.isSerialize) {
        [self.mString appendFormat:@"%@\n",[SettingManager.shared getSerializeCofingWith:Config.shared.supportType]];
    }
}

//处理被重命名过的字段属性的映射说明
- (void)yy_customPropertyMapper
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
- (void)yy_customPropertyGenericClass
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
