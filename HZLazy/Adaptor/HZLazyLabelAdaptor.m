//
//  HZLazyLabelAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyLabelAdaptor.h"

@implementation HZLazyLabelAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UILabel"];
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
        _propertyName.text = <#(NSString *)#>;\n\
        _propertyName.font = [UIFont systemFontOfSize:<#(CGFloat)#> weight:UIFontWeightRegular];\n\
        _propertyName.textColor = <#(UIColor *)#>;\n\
        _propertyName.numberOfLines = 1;\n\
        _propertyName.textAlignment = NSTextAlignmentLeft;\n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = ClassName.init()\n\
        propertyName.text = <#Stirng?#>\n\
        propertyName.font = UIFont.systemFont(ofSize: <#CGFloat#>, weight: .regular)\n\
        propertyName.textColor = <#UIColor!#>\n\
        propertyName.numberOfLines = 1\n\
        propertyName.textAlignment = .left\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}

@end
