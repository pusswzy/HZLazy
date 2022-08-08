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

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
- (ClassName *)propertyName {\n\
    if (!_propertyName) {\n\
        _propertyName = [[ClassName alloc] init];\n\
        _propertyName.text = <#(NSString *)#>;\n\
        _propertyName.font = [UIFont systemFontOfSize:<#(CGFloat)#> weight:UIFontWeightRegular];\n\
        _propertyName.textColor = <#(UIColor *)#>;\n\
        _propertyName.backgroundColor = <#(UIColor *)#>;\n\
        _propertyName.numberOfLines = 1;\n\
        _propertyName.textAlignment = NSTextAlignmentLeft;\n\
    }\n\
    return _propertyName;\n\
}";
            
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
