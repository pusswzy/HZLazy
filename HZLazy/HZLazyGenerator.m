//
//  HZLazyGenerator.m
//  HZLazy
//
//  Created by zhongyi wang on 2021/3/18.
//

#import "HZLazyGenerator.h"
#import "HZLazyCoreData.h"
#import "HZLazyAbstractAdaptor.h"
@interface HZLazyGenerator ()
@property (nonatomic, strong) NSMutableArray <Class<HZAdaptorProtocol>>*adaptorArray;
@end

@implementation HZLazyGenerator
static HZLazyGenerator *lazyGenerator;
+ (instancetype)sharedGenerator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lazyGenerator = [[self alloc] init];
    });
    return lazyGenerator;
}

- (void)registerLazyAdaptor:(Class<HZAdaptorProtocol>)adaptorClass {
    if (!adaptorClass) {
        return;
    }
    @synchronized ([self class]) {
        if (self.adaptorArray == nil) {
            self.adaptorArray = [NSMutableArray arrayWithCapacity:10];
        }
        [self.adaptorArray addObject:adaptorClass];
    }
}

- (NSString *)generateLazyCodeFromData:(HZLazyCoreData *)data {
    if (!data || [data judgeIsValid] == NO) {
        NSAssert(NO, @"%s", __func__);
        return nil;
    }
    
    __block Class adaptorClass = [HZLazyAbstractAdaptor class];
    [self.adaptorArray enumerateObjectsUsingBlock:^(Class<HZAdaptorProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *supportClassNameArray = [obj supportLazyTransferClassNameArray];
        if ([supportClassNameArray containsObject:data.l_className]) {
            adaptorClass = obj;
            *stop = YES;
        }
    }];
    
    NSString *lazyCode = [adaptorClass generateLazyCodeFromClassName:data.l_className propertyName:data.l_propertyName];
    return lazyCode;
}
@end
