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
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = ClassName.init(frame: <#CGRect#>)\n\
        propertyName.dataSource = <#UITableViewDataSource?#>\n\
        propertyName.delegate = <#UITableViewDelegate?#>\n\
        propertyName.rowHeight = <#CGFloat#>\n\
        propertyName.separatorStyle = <#UITableViewCellSeparatorStyle#>\n\
        propertyName.register(<#AnyClass?#>, forCellReuseIdentifier: <#String#>)\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}

@end
