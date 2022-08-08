//
//  HZLazyGenerator.h
//  HZLazy
//
//  Created by zhongyi wang on 2021/3/18.
//

#import <Foundation/Foundation.h>
#import "HZAdaptorProtocol.h"
@class HZLazyCoreData;

#define HZRegister(Class) [[HZLazyGenerator sharedGenerator] registerLazyAdaptor:Class];

NS_ASSUME_NONNULL_BEGIN

@interface HZLazyGenerator : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedGenerator;

/// 注册适配器类
/// @param adaptorClass 注册的类
- (void)registerLazyAdaptor:(Class<HZAdaptorProtocol>)adaptorClass;

- (NSString *)generateLazyCodeFromData:(HZLazyCoreData *)data;
@end

NS_ASSUME_NONNULL_END
