//
//  HZLazyTextFieldAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyTextFieldAdaptor.h"

@implementation HZLazyTextFieldAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UITextField"];
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
        // _propertyName.delegate = <#(id<UITextFieldDelegate>)#>;\n\
        // _propertyName.text = <#(NSString)#>;\n\
        _propertyName.font = <#(UIFont *)#>;\n\
        _propertyName.textColor = <#(UIColor *)#>;\n\
        _propertyName.placeholder = <#(NSString)#>;\n\
        _propertyName.textAlignment = NSTextAlignmentLeft;\n\
        // _propertyName.clearButtonMode = <#(UITextFieldViewMode)#>;\n\
        // _propertyName.clearsOnBeginEditing = <#(BOOL)#>;\n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = ClassName.init()\n\
        propertyName.delegate = <#UITextFieldDelegate?#>\n\
        propertyName.text = <#String?#>\n\
        propertyName.font = <#UIFont?#>\n\
        propertyName.textColor = <#UIColor?#>\n\
        propertyName.placeholder = <#String?#>\n\
        propertyName.textAlignment = <#NSTextAlignment#>\n\
        propertyName.clearButtonMode = <#UITextField.ViewMode#>\n\
        propertyName.clearsOnBeginEditing = <#Bool#>\n\
        return propertyName\n\
    }()\
";
    }
    return replacementSourceCode;
}

@end
