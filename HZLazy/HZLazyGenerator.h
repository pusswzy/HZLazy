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

extern NSString * const kObjectiveCGetterPragma;
extern NSString * const kSwiftGetterPragma;

NS_ASSUME_NONNULL_BEGIN

@interface HZLazyGenerator : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedGenerator;

/// 注册适配器类
/// @param adaptorClass 注册的类
- (void)registerLazyAdaptor:(Class<HZAdaptorProtocol>)adaptorClass;

- (HZLazyCoreData *)createLazySourceDataFromSourceLineString:(NSString *)sourceLineString sourceCodeType:(HZSourceCodeType)sourceCodeType;
- (NSString *)generateLazyCodeFromData:(HZLazyCoreData *)data;

#pragma mark - Tool
+ (HZSourceCodeType)fetchSourceCodeTypeFromContentUTI:(CFStringRef)contentUTI;

#pragma mark - regular
@property (nonatomic, strong, readonly) NSRegularExpression *OCClassNameRE;
@property (nonatomic, strong, readonly) NSRegularExpression *OCPropertyNameRE;
@property (nonatomic, strong, readonly) NSRegularExpression *swiftClassNameRE;
@property (nonatomic, strong, readonly) NSRegularExpression *swiftPropertyNameRE;


@end

NS_ASSUME_NONNULL_END
