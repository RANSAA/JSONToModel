//
//  Config.h
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "ConvertCore.h"

NS_ASSUME_NONNULL_BEGIN


@interface Config : NSObject
@property(nonatomic, assign) BOOL isCompareKey;//是否对生成的model属性进行排序，默认YES
@property(nonatomic, copy)   NSString *supportMode;//模式name
@property(nonatomic, assign) SupportModeType supportType;//模式类型标号
@property(nonatomic, assign) CodeType codeType;//解析语言

@property(nonatomic, copy) NSString *rootName;//根model名称
@property(nonatomic, copy) NSString *prefixName;//前缀名称
@property(nonatomic, copy) NSString *suffixName;//后缀名称
@property(nonatomic, copy) NSString *baseRootName;//根继承对象名称
@property(nonatomic, copy) NSString *baseChildName;//子继承对象名称
@property(nonatomic, assign) BOOL isSerialize;//是否添加序列化, default YES
@property(nonatomic, assign) BOOL isPascal;//是否使用帕斯卡命名方式， default YES
@property(nonatomic, assign) BOOL isPreSuffixRootModel;//RootModel是否添加前后缀， default NO
@property(nonatomic, assign) BOOL isMultipleFile;//生成的model是否保存到多个文件， default NO

+ (instancetype)shared;

- (void)save;

@end

NS_ASSUME_NONNULL_END
