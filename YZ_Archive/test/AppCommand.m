//
//  AppCommand.m
//  test
//
//  Created by yanzhen on 16/9/29.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "AppCommand.h"

@implementation AppCommand
- (BOOL)executeCommand:(NSString*)command
{
    if (0 == system(command.UTF8String)) {
        NSLog(@"---- Done ----");
        return true;
    }
    NSLog(@"%@ exit",command);
    exit(0);
    return false;
}
@end
