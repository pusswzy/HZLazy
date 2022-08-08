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


- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // 判断是否为支持的文件类型
    CFStringRef curUTI = (__bridge CFStringRef)invocation.buffer.contentUTI;
    if (UTTypeEqual(curUTI, kUTTypeObjectiveCSource) == NO) {
        completionHandler(generateCustomError(-1, @"只支持Objective-C的.m文件"));
        return;
    }
    
    XCSourceTextRange *selectRange = invocation.buffer.selections.firstObject;
    NSInteger startLine = selectRange.start.line;
    NSInteger endLine = selectRange.end.line;
    NSArray <NSString *> *selectCodeArray = [self fetchSelectCodeArrayFromStartLine:startLine toEndLine:endLine invocation:invocation];
    NSMutableString *resultLazyCode = [[NSMutableString alloc] init];
    NSMutableString *log = [[NSMutableString alloc] initWithString:@"✨Handle Success: "];
    [selectCodeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#warning TODO 处理泛型的类别
        HZLazyCoreData *coreData = [self fetchLazyCoreDataFromSoureLineString:obj];
        if ([coreData judgeIsValid] == NO) {
            return;
        }
        
        NSString *lazyString = [[HZLazyGenerator sharedGenerator] generateLazyCodeFromData:coreData];
        if (!lazyString) {
            return;
        }
        [resultLazyCode appendString:lazyString];
        [resultLazyCode appendString:@"\n\n"];
        
        [log appendFormat:@"%@", [NSString stringWithFormat:@"%@", coreData.l_propertyName]];
        if (idx != selectCodeArray.count - 1) {
            [log appendString:@", "];
        }
    }];
    
    // 找到插入的那行
    NSInteger findLine = NSNotFound;
    for (NSInteger i = invocation.buffer.lines.count - 1; i > selectRange.end.line; i--) {
        NSString *curLineString = invocation.buffer.lines[i];
        if ([curLineString containsString:@"@end"]) {
            findLine = i;
            break;
        }
    }
    if (resultLazyCode.length == 0) {
        completionHandler(generateCustomError(-2, @"选中区域没有合规的属性"));
        return;
    }
    [invocation.buffer.lines insertObject:resultLazyCode atIndex:findLine == NSNotFound ? invocation.buffer.lines.count - 1 : findLine];
    
    NSLog(@"%@", log);
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

- (HZLazyCoreData *)fetchLazyCoreDataFromSoureLineString:(NSString *)sourceLineString {
    if (sourceLineString == nil || sourceLineString.length == 0) {
        return nil;
    }
    sourceLineString = [sourceLineString stringByReplacingOccurrencesOfString:@" " withString:@""];
    HZLazyCoreData *lazyCoreData = [[HZLazyCoreData alloc] init];
    // class name
    NSRange classNameRange = [self.classNameRE rangeOfFirstMatchInString:sourceLineString options:NSMatchingReportCompletion range:NSMakeRange(0, sourceLineString.length)];
    if (classNameRange.location != NSNotFound) {
        lazyCoreData.l_className = [sourceLineString substringWithRange:classNameRange];
    }
    // property name
    NSRange propertyNameRange = [self.propertyNameRE rangeOfFirstMatchInString:sourceLineString options:NSMatchingReportCompletion range:NSMakeRange(0, sourceLineString.length)];
    if (propertyNameRange.location != NSNotFound) {
        lazyCoreData.l_propertyName = [sourceLineString substringWithRange:propertyNameRange];
    }
    return lazyCoreData;
}

#pragma mark - getter method
#warning 这些正则可以优化下
- (NSRegularExpression *)classNameRE {
    if (!_classNameRE) {
        NSString *classNamePattern = @"(?<=\\))\\w*(?=\\*)";
        _classNameRE= [NSRegularExpression regularExpressionWithPattern:classNamePattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    }
    return _classNameRE;
}

- (NSRegularExpression *)propertyNameRE {
    if (!_propertyNameRE) {
        NSString *propertyNamePattern = @"(?<=\\*)\\w*(?=;)";
        _propertyNameRE = [NSRegularExpression regularExpressionWithPattern:propertyNamePattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    }
    return _propertyNameRE;
}


@end
