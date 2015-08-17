//
// Created by Thomas CASSANY on 05/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESTBeaconManager.h"


@class Beacon;

@interface TrackedBeacon : NSObject

@property (nonatomic, readonly) CLBeaconRegion *region;
@property (nonatomic, readonly) Beacon *beacon;
@property (nonatomic, getter=isUserInRegion) BOOL userInRegion;

- (instancetype)initWithBeacon:(Beacon *)beacon;
+ (instancetype)beaconWithBeacon:(Beacon *)beacon;


@end