//
//  HZLazyScrollViewAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyScrollViewAdaptor.h"

@implementation HZLazyScrollViewAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UIScrollView"];
}

+ (NSString *)generateLazyCodeFromLazySouceData:(HZLazyCoreData *)sourceData {
    NSString *originalLazyCode = [self __fetchOriginalReplacementSourceCodeFromType:sourceData.sourceCodeType];
    
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:kReplaceClassName withString:sourceData.l_className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:kReplacePropertyName withString:sourceData.l_propertyName];
    return originalLazyCode;
}

#pragma mark - private method
+ (NSString *)__fetchOriginalReplacementSourceCodeFromType:(HZSourceCodeType)type {
    NSString *replacementSourceCode;
    if (type == HZSourceCodeTypeObjectiveC) {
        replacementSourceCode = @"\
- (ClassName *)propertyName {\n\
    if (!_propertyName) {\n\
        _propertyName = [[ClassName alloc] init];\n\
        _propertyName.backgroundColor = <#(UIColor *)#>;\n\
        // _propertyName.delegate = <#(id<UIScrollViewDelegate>)#>;\n\
        // _propertyName.contentSize = <#(CGSize)#>;\n\
        // _propertyName.contentInset = <#(UIEdgeInsets)#>;\n\
        // _propertyName.showsHorizontalScrollIndicator = <#(BOOL)#>;\n\
        // _propertyName.showsVerticalScrollIndicator = <#(BOOL)#>;\n\
        // _propertyName.pagingEnabled = <#(BOOL)#>;\n\
        //_propertyName.bounces = <#(BOOL)#>;\n\
        // _propertyName.scrollEnabled = <#(BOOL)#>;\n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = ClassName.init()\n\
        propertyName.backgroundColor = <#UIColor?#>\n\
        propertyName.delegate = <#UIScrollViewDelegate?#>\n\
        propertyName.contentSize = <#CGSize#>\n\
        propertyName.contentInset = <#UIEdgeInset#>\n\
        propertyName.showsHorizontalScrollIndicator = <#Bool#>\n\
        propertyName.showsVerticalScrollIndicator = <#Bool#>\n\
        propertyName.isPagingEnabled = <#Bool#>\n\
        propertyName.bounces = <#Bool#>\n\
        propertyName.isScrollEnabled = <#Bool#>\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}

@end
