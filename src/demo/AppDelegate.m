//
//  AppDelegate.m
//  Demo
//
//  Created by Todd Reed on 2015-09-25.
//  Copyright © 2015 Reaction Software Inc. All rights reserved.
//

#import <UITheme/RSUITheme.h>

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RSDefaultUITheme *theme = [[RSDefaultUITheme alloc] init];
    [RSUITheme setCurrentTheme:theme window:_window];
    return YES;
}

@end
