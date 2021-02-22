//
//  ShowViewController.h
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowViewController : NSViewController
@property (strong) IBOutlet NSBox *boxConfig;
@property (strong) IBOutlet NSBox *boxUrl;
@property (strong) IBOutlet NSBox *boxSave;
@property (strong) IBOutlet NSSplitView *splitView;

@property (strong) IBOutlet NSTextField *textFieldUrl;//URL输入框
@property (strong) IBOutlet NSButton *btnGoHTTP;//url请求解析按钮

@property (strong) IBOutlet NSTextView *inputTextView;//JSON输入显示框
@property (strong) IBOutlet NSTextView *outPutTextView;//转换好的Model属性展示框
@property (strong) IBOutlet NSTextField *textFieldVildTips;//状态校验显示

//配置
@property (strong) IBOutlet NSPopUpButton *itemBtnPattern;//解析模式选择器
@property (strong) IBOutlet NSButton *btnSerialize;//是否序列化
@property (strong) IBOutlet NSButton *btnPascal;//帕斯卡命名
@property (strong) IBOutlet NSButton *btnPreSuffixRootModel;//RootModel是否添加前后缀
@property (strong) IBOutlet NSButton *btnMultipleFile;//是否保存到多个文件


@property (strong) IBOutlet NSTextField *textFieldRootName;//根model名称
@property (strong) IBOutlet NSTextField *textFieldPrefixName;//前缀名称
@property (strong) IBOutlet NSTextField *textFieldSuffixName;//后缀名称
@property (strong) IBOutlet NSTextField *textFieldBaseRootName;//根Model继承对象名称
@property (strong) IBOutlet NSTextField *textFieldBaseChildName;//子Model继承对象名称

@end

NS_ASSUME_NONNULL_END
