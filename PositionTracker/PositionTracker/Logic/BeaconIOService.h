//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconRegionEventHandler.h"

@class CoreDataManager;

@class Beacon;
@class TrackedBeacon;

@interface BeaconIOService : NSObject <BeaconRegionEventHandler>

@property(nonatomic, readonly) NSArray *beacons;
@property(nonatomic, strong) CoreDataManager *coreDataManager;

- (NSData *)csvData;

@end