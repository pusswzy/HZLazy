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

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
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
            
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
