//
//  SourceEditorCommand.h
//  HZLazy
//
//  Created by lihaoze on 2021/3/18.
//

#import <XcodeKit/XcodeKit.h>

NSError *generateCustomError (int code, NSString *localizedErrorDescription);

@interface SourceEditorCommand : NSObject <XCSourceEditorCommand>

@end
