//
//  ConvertModel.h
//  JSONToModel
//
//  Created by PC on 2021/2/24.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 json转model是的数据处理model
 PS:
    1.目前还有模型中嵌套相同的模型未处理
    2.数组中嵌套数组
    3.json的最外层是数组(item是dic),结构还没有解析。 思路循环解析
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConvertModel : NSObject
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, copy) NSDictionary *rootDict;//传入的根dic数据
@property (nonatomic, copy) NSString *modelName;//该模型的名称
@property (nonatomic, copy) NSString *baseModelName;//继承模型的名称
@property (nonatomic, strong) NSMutableArray *aryAttrName;//所有属性的名称,allKeys
@property (nonatomic, strong) NSMutableArray *aryAttrValues;//所有属性对应的值,allValues
@property (nonatomic, strong) NSMutableArray *aryAttrType;//所有属性对应的类型名称,如@"NSString"，@"BOOL"，@"NSDictionary"

@property (nonatomic, strong) NSMutableDictionary *childModelTypeDic;//用于存放定制NSDictionary的类型的标记,属性类型名需要转化 俺位置存储 1:ModelName
@property (nonatomic, strong) NSMutableDictionary *childModelTypeAry;//用于存放定制NSArray类型的标记，属性类型名不需要转化

@property (nonatomic, strong) NSMutableDictionary *mappingPorpertys;//用于暂存需要映射重命名的关键字,与进行过hump命名的属性

@property (nonatomic, strong) NSMutableSet *importClassSet;//记录当前模型需要导入的自定义model

@property (nonatomic, strong) NSMutableString *hString;//展示的.h中的字符串
@property (nonatomic, strong) NSMutableString *mString;//展示的.m中的字符串

//开始解析rootDict
- (void)analysisRootDict;


//检查关键字属性是否需要映射
- (void)checkPorpertyMapping;
/**
 返回需要对自定义属性申明类型的字符串
 return @{@"key":Type.class};
 */
- (NSString *)toGenericClassString;



@end

NS_ASSUME_NONNULL_END
