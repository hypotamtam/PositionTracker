//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import <Foundation/Foundation.h>


@class EventBus;
@class ESTBeaconManager;


@interface BeaconTrackerService : NSObject

@property(nonatomic, readonly) EventBus *beaconRegionBus;
@property(nonatomic, readonly) NSSet *monitoredRegions;

- (instancetype)initWithBeacons:(NSArray *)beacons;

@end