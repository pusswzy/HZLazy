//
//  HZLazyButtonAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyButtonAdaptor.h"

@implementation HZLazyButtonAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UIButton"];
}

+ (NSString *)generateLazyCodeFromLazySouceData:(HZLazyCoreData *)sourceData {
    NSString *originalLazyCode = [self __fetchOriginalReplacementSourceCodeFromType:sourceData.sourceCodeType];
        
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:kReplaceClassName withString:sourceData.l_className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:kReplacePropertyName withString:sourceData.l_propertyName];
    NSString *firstLetter = [sourceData.l_propertyName substringWithRange:NSMakeRange(0, 1)];
    NSString *actionPropertyName = [sourceData.l_propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[firstLetter lowercaseString]];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"PropertyName" withString:actionPropertyName];
    return originalLazyCode;
}

#pragma mark - private method
+ (NSString *)__fetchOriginalReplacementSourceCodeFromType:(HZSourceCodeType)type {
    NSString *replacementSourceCode;
    if (type == HZSourceCodeTypeObjectiveC) {
        replacementSourceCode = @"\
- (ClassName *)propertyName {\n\
    if (!_propertyName) {\n\
        _propertyName = [ClassName buttonWithType:UIButtonTypeCustom];\n\
        [_propertyName setTitle:<#(NSString *)#> forState:UIControlStateNormal];\n\
        [_propertyName setTitleColor:<#(UIColor *)#> forState:UIControlStateNormal];\n\
        _propertyName.titleLabel.font = <#(UIFont *)#>;\n\
        [_propertyName setImage:<#(UIImage *)#> forState:UIControlStateNormal];\n\
        [_propertyName addTarget:self action:@selector(handlePropertyNameClickAction:) forControlEvents:UIControlEventTouchUpInside];\n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = UIButton.init(type: .custom)\n\
        propertyName.setTitle(<#String?#>, for: .normal)\n\
        propertyName.setTitleColor(<#UIColor?#>, for: .normal)\n\
        propertyName.titleLabel?.font = <#UIFont!#>\n\
        propertyName.setImage(<#UIImage?#>, for: .normal)\n\
        propertyName.addTarget(self, action: <#Selector#>, for: .touchUpInside)\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}
@end
