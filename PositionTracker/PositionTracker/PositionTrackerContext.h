//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BeaconTrackerService;
@class BeaconIOService;
@class CoreDataManager;


@interface PositionTrackerContext : NSObject
@property(nonatomic, readonly) BeaconTrackerService *beaconTrackerService;
@property(nonatomic, readonly) BeaconIOService *beaconIOService;

+ (PositionTrackerContext *)instance;

@end