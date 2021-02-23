//
//  ConvertCore.h
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 Json转换数据暂存
 */
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(void);

//转换模式对应了类型标记
typedef NS_ENUM(NSInteger,SupportModeType){
    SupportModeTypeYYModel = 0,         //OC-YYModel
    SupportModeTypeJSONModel = 1,       //OC-JSONModel
    SupportModeTypeMJExtension = 2,     //OC-MJExtension
};


@interface ConvertCore : NSObject
@property (nonatomic, copy) NSString *json;//存储被校验过的Josn字符串
@property (nonatomic, assign) BOOL isVildJson;//json字符串是否正确
@property (nonatomic, copy, nullable) NSDictionary *jsonDict;//json to Dict

+ (instancetype)shared;

/**
 所有支持的解析类型:
 OC-YYModel
 OC-JSONModel
 OC-MJExtension
 */
- (NSArray<NSString *> *)allSupportMode;

@end






/**
 用于存储转换属性的model
 */
@interface ConvertModel : NSObject
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, copy) NSDictionary *rootDict;//传入的根dic数据

@property (nonatomic, copy) NSString *modelName;//该模型的名称
@property (nonatomic, copy) NSString *baseModelName;//继承模型的名称
@property (nonatomic, strong) NSMutableArray *aryAttrName;//所有属性的名称,allKeys
@property (nonatomic, strong) NSMutableArray *aryAttrType;//所有属性对应的类型名称,如@"NSString"，@"BOOL"，@"NSDictionary"

@property (nonatomic, strong) NSMutableDictionary *childModelTypeDic;//用于存放定制NSDictionary的类型的标记,属性类型名需要转化
@property (nonatomic, strong) NSMutableDictionary *childModelTypeAry;//用于存放定制NSArray类型的标记，属性类型名不需要转化

@property (nonatomic, strong) NSMutableString *hString;//展示的.h中的字符串
@property (nonatomic, strong) NSMutableString *mString;//展示的.m中的字符串

//开始解析rootDict
- (void)analysisRootDict;

@end




NS_ASSUME_NONNULL_END
