//
//  AppDelegate.m
//  PositionTracker
//
//  Created by Thomas Cassany on 05/06/2015.
//  Copyright (c) 2015 Thomas Cassany. All rights reserved.
//

#import "AppDelegate.h"
#import "PositionTrackerContext.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PositionTrackerContext instance];
    return YES;
}

@end
