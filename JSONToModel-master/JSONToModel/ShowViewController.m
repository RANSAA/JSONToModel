//
//  ShowViewController.m
//  JSONToModel
//
//  Created by PC on 2021/2/22.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ShowViewController.h"
#import "JSONToModel-Swift.h"

#import "AFNetClient.h"
#import "NSDictionary+JSON.h"
#import "MJExtension.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "HighlightingTextStorage.h"

#import "Config.h"
#import "JSONSerialize.h"
#import "ConvertCore.h"
#import "ConvertJSONToModel.h"
#import "ConvertResult.h"




#define RGB(a,b,c)  [NSColor colorWithRed:(a/255.0) green:(b/255.0) blue:(c/255.0) alpha:1.00]


@interface ShowViewController ()
//@property (nonatomic, )
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self config];
}

- (void)setupUI
{
    [self.inputTextView lnv_setUpLineNumberView];
    [self.outPutTextView lnv_setUpLineNumberView];
    
    self.inputTextView.font=[NSFont fontWithName:@"Menlo" size:13];
    self.inputTextView.backgroundColor=[NSColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.00];
    self.outPutTextView.backgroundColor=RGB(40, 43, 53);
    self.outPutTextView.font=[NSFont systemFontOfSize:14];
    
    self.outPutTextView.automaticDashSubstitutionEnabled = NO;
    self.outPutTextView.automaticTextReplacementEnabled = NO;
    self.outPutTextView.automaticQuoteSubstitutionEnabled = NO;
    self.outPutTextView.enabledTextCheckingTypes = 0;
    
    [self.outPutTextView setEnabledTextCheckingTypes:NSTextCheckingTypeLink];
    [self.outPutTextView setAutomaticLinkDetectionEnabled:YES];
    
    //光标颜色
    self.outPutTextView.insertionPointColor=[NSColor whiteColor];
    //Replace text storage
    HighlightingTextStorage *textStorage = [[HighlightingTextStorage alloc]init];
    textStorage.defaultTextColor=[NSColor whiteColor];
    [textStorage addLayoutManager:self.outPutTextView.layoutManager];
    
    
    HighlightingTextStorage *textStorage2 = [[HighlightingTextStorage alloc]init];
    textStorage2.language=@"json";
    [textStorage2 addLayoutManager:self.inputTextView.layoutManager];
}


//初始化
- (void)config
{
    //Pattern
    [self.itemBtnPattern removeAllItems];
    [self.itemBtnPattern addItemsWithTitles:ConvertCore.shared.allSupportMode];
    [self.itemBtnPattern setTarget:self];
    [self.itemBtnPattern setAction:@selector(handlePatternAction:)];
    [self.itemBtnPattern selectItemWithTitle:Config.shared.supportMode];
    
    
    //Model JSON
    [self.popBtnModel removeAllItems];
    [self.popBtnModel addItemsWithTitles:ConvertCore.shared.allDuplicateMode];
    [self.popBtnModel setTarget:self];
    [self.popBtnModel setAction:@selector(handleModelAction:)];
    [self.popBtnModel selectItemAtIndex:Config.shared.duplicateType];
    
    
    //btn
    self.btnSerialize.tag = 20;
    self.btnSerialize.state = Config.shared.isSerialize;
    [self.btnSerialize setTarget:self];
    [self.btnSerialize setAction:@selector(btnClickAction:)];
    self.btnPascal.tag = 21;
    self.btnPascal.state = Config.shared.isPascal;
    [self.btnPascal setTarget:self];
    [self.btnPascal setAction:@selector(btnClickAction:)];
    self.btnPreSuffixRootModel.tag = 22;
    self.btnPreSuffixRootModel.state = Config.shared.isPreSuffixRootModel;
    [self.btnPreSuffixRootModel setTarget:self];
    [self.btnPreSuffixRootModel setAction:@selector(btnClickAction:)];
    self.btnMultipleFile.tag = 23;
    self.btnMultipleFile.state = Config.shared.isMultipleFile;
    [self.btnMultipleFile setTarget:self];
    [self.btnMultipleFile setAction:@selector(btnClickAction:)];
    
//    self.btnMinModel.tag = 24;
//    [self.btnMinModel setTarget:self];
//    [self.btnMinModel setAction:@selector(btnClickAction:)];
    
    self.btnHump.tag = 25;
    self.btnHump.state = Config.shared.isHump;
    [self.btnHump setTarget:self];
    [self.btnHump setAction:@selector(btnClickAction:)];

    
    //输入框
    if (Config.shared.rootName) {
        self.textFieldRootName.stringValue   = Config.shared.rootName;
    }else{
        self.textFieldRootName.stringValue   = @"";
    }
    if (Config.shared.prefixName) {
        self.textFieldPrefixName.stringValue   = Config.shared.prefixName;
    }else{
        self.textFieldPrefixName.stringValue   = @"";
    }
    if (Config.shared.suffixName) {
        self.textFieldSuffixName.stringValue   = Config.shared.suffixName;
    }else{
        self.textFieldSuffixName.stringValue   = @"";
    }
    if (Config.shared.baseRootName) {
        self.textFieldBaseRootName.stringValue   = Config.shared.baseRootName;
    }else{
        self.textFieldBaseRootName.stringValue   = @"";
    }
    if (Config.shared.baseChildName) {
        self.textFieldBaseChildName.stringValue   = Config.shared.baseChildName;
    }else{
        self.textFieldBaseChildName.stringValue   = @"";
    }

    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldNameDidChange:) name:NSControlTextDidChangeNotification object:self.textFieldRootName];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldNameDidChange:) name:NSControlTextDidChangeNotification object:self.textFieldPrefixName];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldNameDidChange:) name:NSControlTextDidChangeNotification object:self.textFieldSuffixName];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldNameDidChange:) name:NSControlTextDidChangeNotification object:self.textFieldBaseRootName];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldNameDidChange:) name:NSControlTextDidChangeNotification object:self.textFieldBaseChildName];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textFieldNameDidChange:(NSTextField *)textField
{
    [self saveTextFieldName];
    
    //开始解析json
    if (self.inputTextView.string.length > 0) {
        [self analysisJsonFromInputString];
    }
}

//模式选择action
- (void)handlePatternAction:(NSPopUpButton *)popBtn
{
    self.outPutTextView.string = @"";
    Config.shared.supportMode = popBtn.selectedItem.title;
    Config.shared.supportType = popBtn.indexOfSelectedItem;//选中item 的索引
    [Config.shared save];
    
    //开始解析json
    if (self.inputTextView.string.length > 0) {
        [self analysisJsonFromInputString];
    }
}

//model选择action
- (void)handleModelAction:(NSPopUpButton *)popBtn
{
    Config.shared.duplicateType = popBtn.indexOfSelectedItem;
    [Config.shared save];
    
    //开始解析json
    if (self.inputTextView.string.length > 0) {
        [self analysisJsonFromInputString];
    }
}


//是否序列化设置相关点击事件
- (void)btnClickAction:(NSButton *)btn
{
    NSControlStateValue state = btn.state;
    switch (btn.tag) {
        case 20://是否序列化
        {
            Config.shared.isSerialize = state;
            [Config.shared save];
        }
            break;
            
        case 21://帕斯卡命名
        {
            Config.shared.isPascal = state;
            [Config.shared save];
        }
            break;
        
        case 22://RootModel是否添加前后缀
        {
            Config.shared.isPreSuffixRootModel = state;
            [Config.shared save];
        }
            break;
        case 23://是否保存到多个文件
        {
            Config.shared.isMultipleFile = state;
            [Config.shared save];
        }
            break;
        case 24:{

        }
            break;
        case 25:{//属性是否驼峰命名
            Config.shared.isHump = state;
            [Config.shared save];
        }
            break;
        default:
            break;
    }
    
    [self saveTextFieldName];
    
    //开始解析json
    if (self.inputTextView.string.length > 0) {
        [self analysisJsonFromInputString];
    }
    
}

//保存model自定义相关名称
- (void)saveTextFieldName
{
    Config.shared.rootName = self.textFieldRootName.stringValue;
    Config.shared.prefixName = self.textFieldPrefixName.stringValue;
    Config.shared.suffixName = self.textFieldSuffixName.stringValue;
    Config.shared.baseRootName = self.textFieldBaseRootName.stringValue;
    Config.shared.baseChildName = self.textFieldBaseChildName.stringValue;
    [Config.shared save];
}

#pragma mark json 转化区域
//更新显示文字
- (void)updateShowText
{
    self.textFieldVildTips.textColor   = JSONSerialize.shared.vildColor;
    self.textFieldVildTips.stringValue = JSONSerialize.shared.vildStr;
    self.inputTextView.string = JSONSerialize.shared.showStr;

    if (!JSONSerialize.shared.isVildJson) {
        self.outPutTextView.string = @"";
    }
}


//粘贴action
- (IBAction)btnPasteboardAction:(NSButton *)sender {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    if ([[pasteboard types] containsObject:NSPasteboardTypeString]) {
        NSString *str = [pasteboard stringForType:NSPasteboardTypeString];

        [self analysisFileWithString:str];
    }
}


//清除输入框数据
- (IBAction)btnClearAction:(NSButton *)sender {
    self.inputTextView.string = @"";
    self.textFieldVildTips.stringValue = @"";
    self.outPutTextView.string = @"";
    NSLog(@"这儿还需要清除输入框的数据与缓存的json解析数据");
}

//选择文件
- (IBAction)btnChoiceAction:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowsOtherFileTypes = false;
    openPanel.treatsFilePackagesAsDirectories = false;
    openPanel.canChooseFiles = true;
    openPanel.canChooseDirectories = false;
    openPanel.canCreateDirectories = false;
    openPanel.prompt = @"选择";
    [openPanel beginSheetModalForWindow:NSApplication.sharedApplication.keyWindow completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            NSLog(@"path:%@",openPanel.URL.path);
            NSError *err = nil;
            NSString *fileString = [NSString stringWithContentsOfURL:openPanel.URL encoding:NSUTF8StringEncoding error:&err];
            [self analysisFileWithString:fileString];
        }
    }];
}

- (void)analysisFileWithString:(NSString *)inputStr
{
    JSONSerialize.shared.updateInputView = ^{
        [self updateShowText];
        [self saveTextFieldName];
        
        [self convert];
    };
    [JSONSerialize.shared getJsonFromInput:inputStr];
}

//从url获取数据并解析--> Go
- (IBAction)btnGoHTTPAction:(NSButton *)sender {
    NSString *inputStr = self.textFieldUrl.stringValue;
    JSONSerialize.shared.updateInputView = ^{
        [self updateShowText];
        [self saveTextFieldName];
        
        [self convert];
    };
    [JSONSerialize.shared getJsonFromUrl:inputStr];
}

//直接解析左边输入框的string--> Model
- (IBAction)btnGenerateAction:(NSButton *)sender {
    [self analysisJsonFromInputString];
}

//从左边输入框获取数据解析
- (void)analysisJsonFromInputString
{
    NSString *inputStr = self.inputTextView.textStorage.string;
    JSONSerialize.shared.updateInputView = ^{
        [self updateShowText];
        [self saveTextFieldName];
        
        [self convert];
    };
    [JSONSerialize.shared getJsonFromInput:inputStr];
}

//开始转化json数据
- (void)convert
{
    ConvertJSONToModel.shared.completed = ^(NSString * _Nonnull str) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.outPutTextView.string = str;
        });
    };
    [ConvertJSONToModel.shared convert];
}

//保存到文件
- (IBAction)btnSaveToFileAction:(NSButton *)sender {
    [ConvertResult.shared saveAs];
}

@end
