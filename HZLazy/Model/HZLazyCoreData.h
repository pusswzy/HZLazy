//
//  HZLazyCoreData.h
//  HZLazy
//
//  Created by lihaoze on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZLazyCoreData : NSObject
@property (nonatomic, strong) NSString *l_className;
@property (nonatomic, strong) NSString *l_propertyName;

- (BOOL)judgeIsValid;
@end

NS_ASSUME_NONNULL_END
