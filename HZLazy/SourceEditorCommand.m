//
//  SourceEditorCommand.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/18.
//

#import "SourceEditorCommand.h"
#import "HZLazyCoreData.h"
#import "HZLazyGenerator.h"

@interface SourceEditorCommand ()
@property (nonatomic, strong) NSRegularExpression *classNameRE;
@property (nonatomic, strong) NSRegularExpression *propertyNameRE;
@end

@implementation SourceEditorCommand

static NSErrorDomain const HZLazyErrorDomain = @"HZLazyErrorDomain";

NSError *generateCustomError (int code, NSString *localizedErrorDescription) {
    if (!localizedErrorDescription || localizedErrorDescription.length == 0) {
        localizedErrorDescription = @"出错了~";
    }
    return [NSError errorWithDomain:HZLazyErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : localizedErrorDescription}];
}

#define kLogResult 1
- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // 判断是否为支持的文件类型
    CFStringRef curUTI = (__bridge CFStringRef)invocation.buffer.contentUTI;
    HZSourceCodeType sourceCodeType = [HZLazyGenerator fetchSourceCodeTypeFromContentUTI:curUTI];
    if (sourceCodeType == HZSourceCodeTypeUnknown) {
        NSString *errorReason = [NSString stringWithFormat:@"当前文件类型为:%@, 工具只支持Objective-C的.m文件和Swift的.swift文件", (__bridge NSString *)curUTI];
        completionHandler(generateCustomError(-1, errorReason));
        return;
    }
    
    XCSourceTextRange *selectRange = invocation.buffer.selections.firstObject;
    NSInteger startLine = selectRange.start.line;
    NSInteger endLine = selectRange.end.line;
    NSArray <NSString *> *selectCodeArray = [self fetchSelectCodeArrayFromStartLine:startLine toEndLine:endLine invocation:invocation];
    NSMutableString *resultLazyCode = [[NSMutableString alloc] init];
    NSMutableString *log = [[NSMutableString alloc] initWithString:@"✨Handle Success: "];
    NSMutableArray <HZLazyCoreData *>*validDataArray = [NSMutableArray array];
    [selectCodeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull lineSource, NSUInteger idx, BOOL * _Nonnull stop) {
#warning TODO 处理泛型的类别
        HZLazyCoreData *coreData = [[HZLazyGenerator sharedGenerator] createLazySourceDataFromSourceLineString:lineSource sourceCodeType:sourceCodeType];
        if ([coreData judgeIsValid] == NO) {
            return;
        }
        
        NSString *lazyString = [[HZLazyGenerator sharedGenerator] generateLazyCodeFromData:coreData];
        if (!lazyString) {
            return;
        }
        coreData.sourceLine = startLine + idx;
        [resultLazyCode appendString:lazyString];
        [resultLazyCode appendString:@"\n\n"];
        
        [log appendFormat:@"%@", [NSString stringWithFormat:@"%@", coreData.l_propertyName]];
        if (idx != selectCodeArray.count - 1) {
            [log appendString:@", "];
        }
        [validDataArray addObject:coreData];
    }];
    
    // 找到插入的那行
    NSInteger findLine = NSNotFound;
    if (sourceCodeType == HZSourceCodeTypeObjectiveC) {
        for (NSInteger i = invocation.buffer.lines.count - 1; i > selectRange.end.line; i--) {
            NSString *curLineString = invocation.buffer.lines[i];
            if ([curLineString containsString:@"@end"]) {
                findLine = i;
                break;
            }
        }
    } else if (sourceCodeType == HZSourceCodeTypeSwift) {
        findLine = endLine + 1;
    }
    
    if (resultLazyCode.length == 0) {
        completionHandler(generateCustomError(-2, @"选中区域没有合规的属性"));
        return;
    }
    
    //
    [self recombinateResultCode:resultLazyCode sourceCodeType:sourceCodeType invocation:invocation];
    // ✨
    [invocation.buffer.lines insertObject:resultLazyCode atIndex:findLine == NSNotFound ? invocation.buffer.lines.count - 1 : findLine];
    
    // swift特殊处理 需要将之前声明的属性移除掉
    if (sourceCodeType == HZSourceCodeTypeSwift) {
        for (HZLazyCoreData *coreData in validDataArray.reverseObjectEnumerator) {
            [invocation.buffer.lines removeObjectAtIndex:coreData.sourceLine];
        }
    }
    
    
#if kLogResult
    NSLog(@"%@", log);
#endif
    completionHandler(nil);
}

#pragma data
/// 获取选中范围内的文本数组 用行数来分割
- (NSArray <NSString *> *)fetchSelectCodeArrayFromStartLine:(NSInteger)startLine toEndLine:(NSInteger)endLine invocation:(XCSourceEditorCommandInvocation *)invocation {
    NSMutableArray *selectCodeArray = [NSMutableArray arrayWithCapacity:endLine - startLine];
    for (NSInteger i = startLine; i <= endLine; i++) {
        [selectCodeArray addObject:invocation.buffer.lines[i]];
    }
    return [selectCodeArray copy];
}

- (BOOL)judgeValidPropertyString:(NSString *)sourceString {
    // 格式
    if (sourceString == nil || sourceString.length == 0) {
        return NO;
    }
    // 不支持
    if ([sourceString containsString:@"IBOutlet"]) {
        return NO;
    }
    
    if ([sourceString containsString:@"@property"] == NO) {
        return NO;
    }
    
    return YES;
}

- (void)recombinateResultCode:(NSMutableString *)resultCode sourceCodeType:(HZSourceCodeType)sourceCodeType invocation:(XCSourceEditorCommandInvocation *)invocation {
    // 判断是否添加pragma objective环境下
    if (sourceCodeType == HZSourceCodeTypeObjectiveC) {
        BOOL needInsert = YES;
        for (int i = 0; i < invocation.buffer.lines.count; i++) {
            NSString *curLineString = invocation.buffer.lines[i];
            if ([curLineString containsString:kObjectiveCGetterPragma]) {
                needInsert = NO;
                break;
            }
        }
        if (needInsert == YES) {
            [resultCode insertString:kObjectiveCGetterPragma atIndex:0];
        }
    } else if (sourceCodeType == HZSourceCodeTypeSwift) {
        BOOL needInsert = YES;
        for (int i = 0; i < invocation.buffer.lines.count; i++) {
            NSString *curLineString = invocation.buffer.lines[i];
            if ([curLineString containsString:kSwiftGetterPragma]) {
                needInsert = NO;
                break;
            }
        }
        if (needInsert == YES) {
            [resultCode insertString:kSwiftGetterPragma atIndex:0];
        }
    }
}

@end
