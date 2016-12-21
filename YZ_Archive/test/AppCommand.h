//
//  AppCommand.h
//  test
//
//  Created by yanzhen on 16/9/29.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCommand : NSObject
- (BOOL)executeCommand:(NSString*)command;
@end
