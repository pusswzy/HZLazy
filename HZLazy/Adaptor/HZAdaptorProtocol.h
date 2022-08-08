//
//  HZAdaptorProtocol.h
//  HZLazy
//
//  Created by lihaoze on 2021/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZAdaptorProtocol <NSObject>
/// 支持懒加载转换的类数组
+ (NSArray <NSString *>*)supportLazyTransferClassNameArray;
/// 生成懒加载code
+ (NSString *)generateLazyCodeFromClassName:(NSString *)className propertyName:(NSString *)propertyName;
@end

NS_ASSUME_NONNULL_END
