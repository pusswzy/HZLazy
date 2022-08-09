//
//  HZLazyGenerator.m
//  HZLazy
//
//  Created by zhongyi wang on 2021/3/18.
//

#import "HZLazyGenerator.h"
#import "HZLazyCoreData.h"
#import "HZLazyAbstractAdaptor.h"

NSString *const kObjectiveCGetterPragma = @"#pragma mark - getter method\n";
NSString *const kSwiftGetterPragma = @"    //MARK: lazy method\n";

@interface HZLazyGenerator ()
@property (nonatomic, strong) NSMutableArray <Class<HZAdaptorProtocol>>*adaptorArray;

@property (nonatomic, strong) NSRegularExpression *OCClassNameRE;
@property (nonatomic, strong) NSRegularExpression *OCPropertyNameRE;
@property (nonatomic, strong) NSRegularExpression *swiftClassNameRE;
@property (nonatomic, strong) NSRegularExpression *swiftPropertyNameRE;
@end

@implementation HZLazyGenerator
static HZLazyGenerator *lazyGenerator;
+ (instancetype)sharedGenerator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lazyGenerator = [[self alloc] init];
    });
    return lazyGenerator;
}

- (void)registerLazyAdaptor:(Class<HZAdaptorProtocol>)adaptorClass {
    if (!adaptorClass) {
        return;
    }
    @synchronized ([self class]) {
        if (self.adaptorArray == nil) {
            self.adaptorArray = [NSMutableArray arrayWithCapacity:10];
        }
        [self.adaptorArray addObject:adaptorClass];
    }
}

- (HZLazyCoreData *)createLazySourceDataFromSourceLineString:(NSString *)sourceLineString sourceCodeType:(HZSourceCodeType)sourceCodeType {
    if (sourceCodeType == HZSourceCodeTypeUnknown) {
        return nil;
    }
    if (sourceLineString == nil || sourceLineString.length == 0) {
        return nil;
    }
    #warning TODO _这里这步是否多余?
    sourceLineString = [sourceLineString stringByReplacingOccurrencesOfString:@" " withString:@""];
    HZLazyCoreData *lazyCoreData = [[HZLazyCoreData alloc] init];
    lazyCoreData.sourceCodeType = sourceCodeType;
    // class name
    NSRegularExpression *suitableClassExpression = [self __fetchClassNameExpressionFromSourceCodeType:sourceCodeType];
    NSRange classNameRange = [suitableClassExpression rangeOfFirstMatchInString:sourceLineString options:NSMatchingReportCompletion range:NSMakeRange(0, sourceLineString.length)];
    if (classNameRange.location != NSNotFound) {
        lazyCoreData.l_className = [sourceLineString substringWithRange:classNameRange];
    }
    // property name
    NSRegularExpression *suitablePropertyExpression = [self __fetchProperyNameExpressionFromSourceCodeType:sourceCodeType];
    NSRange propertyNameRange = [suitablePropertyExpression rangeOfFirstMatchInString:sourceLineString options:NSMatchingReportCompletion range:NSMakeRange(0, sourceLineString.length)];
    if (propertyNameRange.location != NSNotFound) {
        lazyCoreData.l_propertyName = [sourceLineString substringWithRange:propertyNameRange];
    }
    return lazyCoreData;
}

- (NSString *)generateLazyCodeFromData:(HZLazyCoreData *)data {
    if (!data || [data judgeIsValid] == NO) {
        NSAssert(NO, @"%s", __func__);
        return nil;
    }
    
    __block Class adaptorClass = [HZLazyAbstractAdaptor class];
    [self.adaptorArray enumerateObjectsUsingBlock:^(Class<HZAdaptorProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *supportClassNameArray = [obj supportLazyTransferClassNameArray];
        if ([supportClassNameArray containsObject:data.l_className]) {
            adaptorClass = obj;
            *stop = YES;
        }
    }];
    
    NSString *lazyCode = [adaptorClass generateLazyCodeFromLazySouceData:data];
    return lazyCode;
}

#pragma mark - Tool
+ (HZSourceCodeType)fetchSourceCodeTypeFromContentUTI:(CFStringRef)contentUTI {
    if (UTTypeEqual(contentUTI, kUTTypeObjectiveCSource)) {
        return HZSourceCodeTypeObjectiveC;
    } else if (UTTypeEqual(contentUTI, kUTTypeSwiftSource)) {
        return HZSourceCodeTypeSwift;
    } else {
        return HZSourceCodeTypeUnknown;
    }
}

#pragma mark - private method
- (NSRegularExpression *)__fetchClassNameExpressionFromSourceCodeType:(HZSourceCodeType)codeType {
    if (codeType == HZSourceCodeTypeObjectiveC) {
        return self.OCClassNameRE;
    } else if (codeType == HZSourceCodeTypeSwift) {
        return self.swiftClassNameRE;
    } else {
        return nil;
    }
}

- (NSRegularExpression *)__fetchProperyNameExpressionFromSourceCodeType:(HZSourceCodeType)codeType {
    if (codeType == HZSourceCodeTypeObjectiveC) {
        return self.OCPropertyNameRE;
    } else if (codeType == HZSourceCodeTypeSwift) {
        return self.swiftPropertyNameRE;
    } else {
        return nil;
    }
}

#pragma mark - regular expression
- (NSRegularExpression *)OCClassNameRE {
    if (!_OCClassNameRE) {
        NSString *classNamePattern = @"(?<=\\))\\w*(?=\\*)";
        _OCClassNameRE = [NSRegularExpression regularExpressionWithPattern:classNamePattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    }
    return _OCClassNameRE;
}

- (NSRegularExpression *)OCPropertyNameRE {
    if (!_OCPropertyNameRE) {
        NSString *propertyNamePattern = @"(?<=\\*)\\w*(?=;)";
        _OCPropertyNameRE = [NSRegularExpression regularExpressionWithPattern:propertyNamePattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    }
    return _OCPropertyNameRE;
}

- (NSRegularExpression *)swiftClassNameRE {
    if (!_swiftClassNameRE) {
        // ?<=里面的\\s?优先级非常低 导致必须加一个\\S才能匹配到 不知道为什么
        NSString *classNamePattern = @"(?<=\\:\\s?)\\S\\w*(?=(\\!|\\?|\\??))";
        _swiftClassNameRE = [NSRegularExpression regularExpressionWithPattern:classNamePattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    }
    return _swiftClassNameRE;
}

- (NSRegularExpression *)swiftPropertyNameRE {
    if (!_swiftPropertyNameRE) {
        NSString *propertyNamePattern = @"(?<=(var|let)\\s?)\\w*(?=\\s?\\:)";
        _swiftPropertyNameRE = [NSRegularExpression regularExpressionWithPattern:propertyNamePattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    }
    return _swiftPropertyNameRE;
}

@end
