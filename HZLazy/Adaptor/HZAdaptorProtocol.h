//
//  HZAdaptorProtocol.h
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import "HZLazyCoreData.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kReplaceClassName;
extern NSString *const kReplacePropertyName;

@protocol HZAdaptorProtocol <NSObject>
/// 支持懒加载转换的类数组
+ (NSArray <NSString *>*)supportLazyTransferClassNameArray;
/// 生成懒加载code
+ (NSString *)generateLazyCodeFromLazySouceData:(HZLazyCoreData *)sourceData;
@end

NS_ASSUME_NONNULL_END
