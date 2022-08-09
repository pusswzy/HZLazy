//
//  HZLazyCollectionViewAdaptor.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import "HZLazyCollectionViewAdaptor.h"

@implementation HZLazyCollectionViewAdaptor

+ (void)load {
    HZRegister(self);
}

#pragma mark - HZAdaptorProtocol
+ (NSArray *)supportLazyTransferClassNameArray {
    return @[@"UICollectionView"];
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
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];\n\
        flowLayout.estimatedItemSize = <#(CGSize)#>;\n\
        flowLayout.itemSize = <#(CGSize)#>;\n\
        flowLayout.scrollDirection = <#(UICollectionViewScrollDirection)#>;\n\
        flowLayout.minimumLineSpacing = <#(CGFloat)#>;\n\
        flowLayout.minimumInteritemSpacing = <#(CGFloat)#>;\n\
        \
        _propertyName = [[ClassName alloc] initWithFrame:<#(CGRect)#> collectionViewLayout:<#(nonnull UICollectionViewLayout *)#>];\n\
        _propertyName.backgroundColor = <#(UIColor *)#>;\n\
        _propertyName.dataSource = <#(id <UICollectionViewDelegate>)#>;\n\
        _propertyName.delegate = <#(id <UICollectionViewDataSource>)#>;\n\
        [_propertyName registerClass:<#(nullable Class)#> forCellWithReuseIdentifier:<#(nonnull NSString *)#>];\n\
    }\n\
    return _propertyName;\n\
}";
    } else if (type == HZSourceCodeTypeSwift) {
        replacementSourceCode = @"\
    lazy var propertyName: ClassName = {\n\
        let flowLayout = UICollectionViewFlowLayout.init()\n\
        flowLayout.itemSize = <#CGSzie#>\n\
        flowLayout.scrollDirection = <#UICollectionView.ScrollDirection#>\n\
        flowLayout.minimumLineSpacing = <#CGFloat#>\n\
        flowLayout.minimumInteritemSpacing = <#CGFloat#>\n\
        flowLayout.sectionInset = <#UIEdgeInset#>\n\
        \n\
        var propertyName = UICollectionView.init(frame: <#T##CGRect#>, collectionViewLayout: flowLayout)\n\
        propertyName.backgroundColor = <#UIColor?#>\n\
        propertyName.dataSource = <#UICollectionViewDataSource#>\n\
        propertyName.delegate = <#UICollectionViewDelegate#>\n\
        propertyName.register(<#AnyClass?#>, forCellWithReuseIdentifier: <#String#>)\n\
        return propertyName\n\
    }()\
        ";
    }
    return replacementSourceCode;
}

@end
