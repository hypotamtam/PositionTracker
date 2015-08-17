//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventBus.h"

@class TrackedBeacon;


@interface BeaconRegionEvent : NSObject <Event>

- (instancetype)initWithTrackedBeacon:(TrackedBeacon *)trackedBeacon;

+ (instancetype)eventWithTrackedBeacon:(TrackedBeacon *)trackedBeacon;

@end