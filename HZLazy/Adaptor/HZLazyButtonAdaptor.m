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

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
- (ClassName *)propertyName {\n\
    if (!_propertyName) {\n\
        _propertyName = [ClassName buttonWithType:UIButtonTypeCustom];\n\
        [_propertyName setTitle:<#(NSString *)#> forState:UIControlStateNormal];\n\
        [_propertyName setTitleColor:<#(UIColor *)#> forState:UIControlStateNormal];\n\
        _propertyName.titleLabel.font = <#(UIFont *)#>;\n\
        // [_propertyName setImage:<#(UIImage *)#> forState:UIControlStateNormal];\n\
        [_propertyName addTarget:self action:@selector(handlePropertyNameClickAction:) forControlEvents:UIControlEventTouchUpInside];\n\
    }\n\
    return _propertyName;\n\
}";
        
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"PropertyName" withString:[propertyName capitalizedString]];
    return originalLazyCode;
}

@end
