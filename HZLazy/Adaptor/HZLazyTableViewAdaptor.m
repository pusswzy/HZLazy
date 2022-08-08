//
//  HZLazyTableViewAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyTableViewAdaptor.h"

@implementation HZLazyTableViewAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UITableView"];
}

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
- (ClassName *)propertyName {\n\
    if (!_propertyName) {\n\
        _propertyName = [[ClassName alloc] init];\n\
        _propertyName.dataSource = <#(id <UITableViewDataSource>)#>;\n\
        _propertyName.delegate = <#(id <UITableViewDelegate>)#>;\n\
    \
        _propertyName.rowHeight = <#(CGFloat)#>;\n\
        // _propertyName.estimatedRowHeight = UITableViewAutomaticDimension;\n\
        _propertyName.separatorStyle = <#(UITableViewCellSeparatorStyle)#>;\n\
        [_propertyName registerClass:<#(Class)#> forCellReuseIdentifier:<#(NSString *)#>];\n\
    }\n\
    return _propertyName;\n\
}";
            
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
