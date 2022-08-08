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

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
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
            
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
