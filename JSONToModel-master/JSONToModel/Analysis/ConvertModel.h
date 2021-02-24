//
//  ConvertModel.h
//  JSONToModel
//
//  Created by PC on 2021/2/24.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 json转model是的数据处理model

 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConvertModel : NSObject
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, copy) NSDictionary *rootDict;//传入的根dic数据

@property (nonatomic, copy) NSString *modelName;//该模型的名称
@property (nonatomic, copy) NSString *baseModelName;//继承模型的名称
@property (nonatomic, strong) NSMutableArray *aryAttrName;//所有属性的名称,allKeys
@property (nonatomic, strong) NSMutableArray *aryAttrType;//所有属性对应的类型名称,如@"NSString"，@"BOOL"，@"NSDictionary"

@property (nonatomic, strong) NSMutableDictionary *childModelTypeDic;//用于存放定制NSDictionary的类型的标记,属性类型名需要转化
@property (nonatomic, strong) NSMutableDictionary *childModelTypeAry;//用于存放定制NSArray类型的标记，属性类型名不需要转化

@property (nonatomic, strong) NSMutableDictionary *mappingPorpertys;//用于暂存需要映射重命名的关键字

@property (nonatomic, strong) NSMutableString *hString;//展示的.h中的字符串
@property (nonatomic, strong) NSMutableString *mString;//展示的.m中的字符串

//开始解析rootDict
- (void)analysisRootDict;
@end

NS_ASSUME_NONNULL_END
