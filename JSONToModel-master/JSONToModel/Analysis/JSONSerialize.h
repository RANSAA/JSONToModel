//
//  JSONSerialize.h
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 json 获取及其处理工具
 */
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Config.h"



NS_ASSUME_NONNULL_BEGIN

@interface JSONSerialize : NSObject
@property (nonatomic, assign) BOOL isVildJson;
@property (nonatomic, strong) NSString *vildStr;
@property (nonatomic, strong) NSColor  *vildColor;
@property (nonatomic, strong) NSString *showStr;//被显示在输入框中的字符串

@property (nonatomic, copy) Block updateInputView;//回调-更新输入
//@property (nonatomic, copy) Block updateOutputView;//回调-更新输出

+ (instancetype)shared;

//通过网络获取并验证是否时json
- (void)getJsonFromUrl:(NSString *)url;
//直接获取并验证输入框的字符串是否是JSON
- (void)getJsonFromInput:(NSString *)inputStr;

@end

NS_ASSUME_NONNULL_END
