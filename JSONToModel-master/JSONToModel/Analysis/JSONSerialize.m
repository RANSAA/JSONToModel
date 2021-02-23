//
//  JSONSerialize.m
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "JSONSerialize.h"
#import "AFNetClient.h"
#import "NSDictionary+JSON.h"
#import "MJExtension.h"

#import "ConvertCore.h"
#import "ConvertJson.h"


@implementation JSONSerialize

+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

- (NSColor *)vildColor
{
    if (_isVildJson) {
        return NSColor.purpleColor;
    }
    return NSColor.redColor;
}

- (NSString *)vildStr
{
    if (_vildStr) {
        return _vildStr;
    }
    return @"";
}

- (NSString *)showStr
{
    if (_showStr) {
        return _showStr;
    }
    return @"";
}

//通过网络获取并验证是否时json
- (void)getJsonFromUrl:(NSString *)url
{
    if (url.length<7) {
        _isVildJson = NO;
        _vildStr = @"请输入有效的url地址";
        return;
    }
    __weak typeof(self)weakSelf = self;
    [AFNetClient GET_Path:url completed:^(NSHTTPURLResponse *response, id JSONDict, NSData *data) {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *json=[JSONDict toReadableJSONString];
            [weakSelf getJsonFromInput:json];
        });
    } failed:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}

//直接获取并验证输入框的字符串是否是JSON
- (void)getJsonFromInput:(NSString *)inputStr
{
    _showStr = inputStr;
    ConvertCore.shared.isVildJson = NO;
    ConvertCore.shared.jsonDict = nil;
    NSData *data = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        _isVildJson = NO;
        _vildStr = @"JSON格式不正确";
    }else{
        NSError *err = nil;
        NSDictionary *JSONDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if (err) {
            _isVildJson = NO;
            _vildStr = @"JSON格式不正确";
        }else{
            if (!JSONDict) {
                _isVildJson = NO;
                _vildStr = @"JSON格式不正确";
            }else{//校验成功
                _isVildJson = YES;
                _vildStr = @"校验成功";

                //暂存有效的jsonDict数据
                if (JSONDict.allKeys.count>0) {
                    ConvertCore.shared.isVildJson = YES;
                    ConvertCore.shared.jsonDict = JSONDict;
                }
            }
        }
    }
    
    //更新输入框
    if (self.updateInputView) {
        self.updateInputView();
    }
}



@end
