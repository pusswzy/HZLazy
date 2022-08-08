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

+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName {
    NSString *originalLazyCode = @"\
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
            
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"ClassName" withString:className];
    originalLazyCode = [originalLazyCode stringByReplacingOccurrencesOfString:@"propertyName" withString:propertyName];
    return originalLazyCode;
}

@end
