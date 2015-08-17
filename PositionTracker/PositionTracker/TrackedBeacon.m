//
// Created by Thomas CASSANY on 05/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import "TrackedBeacon.h"
#import "Beacon.h"

@interface TrackedBeacon ()
@property (nonatomic, readwrite) CLBeaconRegion *region;
@property (nonatomic, readwrite) Beacon *beacon;
@end

@implementation TrackedBeacon
- (instancetype)initWithBeacon:(Beacon *)beacon {
    self = [super init];
    if (self) {
        NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:beacon.proximityUUID];
        self.region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:beacon.major minor:beacon.minor identifier:beacon.name];
        self.beacon = beacon;
        self.userInRegion = NO;
    }
    return self;
}

+ (instancetype)beaconWithBeacon:(Beacon *)beacon {
    return [[self alloc] initWithBeacon:beacon];
}

@end