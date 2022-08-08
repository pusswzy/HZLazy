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

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
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
            
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
