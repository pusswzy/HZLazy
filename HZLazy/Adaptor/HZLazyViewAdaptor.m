//
//  HZLazyViewAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyViewAdaptor.h"

@implementation HZLazyViewAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UIView"];
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
        _propertyName.layer.cornerRadius = <#(CGFloat)#>;\n\
        _propertyName.layer.masksToBounds = YES;\n\
        _propertyName.layer.borderWidth = <#(CGFloat)#>;\n\
        _propertyName.layer.borderColor = <#(UIColor *)#>.CGColor;\n\
         \n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = ClassName.init()\n\
        propertyName.backgroundColor = <#UIColor?#>\n\
        propertyName.layer.cornerRadius = <#CGFloat#>\n\
        propertyName.layer.masksToBounds = <#bool#>\n\
        propertyName.layer.borderWidth = <#CGFloat#>\n\
        propertyName.layer.borderColor = <#CGColor?#>\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}

@end
