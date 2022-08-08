//
//  HZLazyCoreData.m
//  HZLazy
//
//  Created by lihaoze on 2021/3/18.
//

#import "HZLazyCoreData.h"

@implementation HZLazyCoreData

- (BOOL)judgeIsValid {
    return self.l_propertyName.length > 0 && self.l_className.length > 0;
}

@end
