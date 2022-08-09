//
//  HZLazyImageViewAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyImageViewAdaptor.h"

@implementation HZLazyImageViewAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UIImageView"];
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
        _propertyName.image = <#(UIImage *)#>;\n\
        // _propertyName.userInteractionEnabled = YES;\n\
        // _propertyName.contentMode = UIViewContentModeScaleAspectFit;\n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        var propertyName = ClassName.init()\n\
        propertyName.image = <#UIImage?#>\n\
        /*\n\
         propertyName.isUserInteractionEnabled = true\n\
         propertyName.contentMode = .scaleAspectFill\n\
         propertyName.layer.masksToBounds = true\n\
         */\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}

@end
