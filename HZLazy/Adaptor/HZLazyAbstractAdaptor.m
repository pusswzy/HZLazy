//
//  HZLazyAbstractAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyAbstractAdaptor.h"

@implementation HZLazyAbstractAdaptor

#pragma mark - HZAdaptorProtocol
+ (NSArray<NSString *> *)supportLazyTransferClassNameArray {
    return nil;
}

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
- (ClassName *)propertyName {\n\
    if (!_propertyName) {\n\
        _propertyName = [[ClassName alloc] init];\n\
    }\n\
    return _propertyName;\n\
}";
    
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
