//
//  main.m
//  test
//
//  Created by yanzhen on 16/9/29.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppCommand.h"

void parameterError()
{
    NSLog(@"\nYZ Error:\nyou should do like this: ./YZ -D $Path$\nYZ Error");
    exit(0);
}

void iPhoneClean()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"xcodebuild clean -project YZUIKit/YZUIKit.xcodeproj -sdk iphoneos -configuration Debug"];
    [command executeCommand:mand];
}

void iPhoneBuild()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"xcodebuild -project YZUIKit/YZUIKit.xcodeproj -sdk iphoneos -configuration Debug"];
    [command executeCommand:mand];
}

void iPhonesimulatorClean()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"xcodebuild clean -project YZUIKit/YZUIKit.xcodeproj -sdk iphonesimulator -configuration Debug"];
    [command executeCommand:mand];
}

void iPhonesimulatorBuild()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"xcodebuild -project YZUIKit/YZUIKit.xcodeproj -sdk iphonesimulator -configuration Debug"];
    [command executeCommand:mand];
}

void createYZUIKit()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"lipo -create library/framework-iphoneos/YZUIKit.framework/YZUIKit library/framework-iphonesimulator/YZUIKit.framework/YZUIKit -output library/YZUIKit"];
    [command executeCommand:mand];
}

void moveYZUIKit()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"mv ./library/YZUIKit ./library/framework-iphoneos/YZUIKit.framework/"];
    [command executeCommand:mand];
}

void copyYZUIKit()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"cp -rf ./library/framework-iphoneos/* ./"];
    [command executeCommand:mand];
}

void chmodYZUIKit()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"chmod u-w YZUIKit.framework/Headers/*"];
    [command executeCommand:mand];
}

void removeYZUIKit()
{
    AppCommand *command = [[AppCommand alloc] init];
    NSString *mand = [NSString stringWithFormat:@"rm -rf ./library/"];
    [command executeCommand:mand];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        iPhoneClean();
        iPhoneBuild();
        iPhonesimulatorClean();
        iPhonesimulatorBuild();
        
        createYZUIKit();
        moveYZUIKit();
        copyYZUIKit();
        chmodYZUIKit();
        removeYZUIKit();
        
    }
    return 0;
}

