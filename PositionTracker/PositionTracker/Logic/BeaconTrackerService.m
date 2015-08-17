//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import "BeaconTrackerService.h"
#import "BeaconRegionEventHandler.h"
#import "ESTBeaconManager.h"
#import "TrackedBeacon.h"
#import "BeaconRegionEvent.h"
#import "Beacon.h"


@interface BeaconTrackerService () <ESTBeaconManagerDelegate>
@property(nonatomic, readwrite) EventBus *beaconRegionBus;
@property(nonatomic, strong) ESTBeaconManager *beaconManager;
@property(nonatomic, strong) NSArray *trackedBeacons;
@end

@implementation BeaconTrackerService


- (instancetype)initWithBeacons:(NSArray *)beacons {
    self = [super init];
    if (self) {
        self.beaconRegionBus = [[EventBus alloc] init];
        self.beaconManager = [[ESTBeaconManager alloc] init];
        [self.beaconManager.monitoredRegions enumerateObjectsUsingBlock:^(CLBeaconRegion *region, BOOL *stop) {
            [self.beaconManager stopMonitoringForRegion:region];
        }];
        self.beaconManager.delegate = self;

        if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.beaconManager requestAlwaysAuthorization];
        }

        NSMutableArray *trackedBeacons = [NSMutableArray array];
        [beacons enumerateObjectsUsingBlock:^(Beacon *beacon, NSUInteger idx, BOOL *stop) {
            [trackedBeacons addObject:[TrackedBeacon beaconWithBeacon:beacon]];
        }];
        self.trackedBeacons = trackedBeacons;

        [self.trackedBeacons enumerateObjectsUsingBlock:^(TrackedBeacon *trackedBeacon, NSUInteger idx, BOOL *stop) {
            [self.beaconManager startMonitoringForRegion:trackedBeacon.region];
        }];
    }

    return self;
}

- (TrackedBeacon *)trackedBeaconsWithRegion:(CLBeaconRegion *)region {
    __block TrackedBeacon *ret;
    [self.trackedBeacons enumerateObjectsUsingBlock:^(TrackedBeacon *trackedBeacon, NSUInteger idx, BOOL *stop) {
        if ([region.identifier isEqualToString:trackedBeacon.region.identifier]) {
            ret = trackedBeacon;
            *stop = YES;
        }
    }];
    return ret;
}

- (NSSet *)monitoredRegions {
    return self.beaconManager.monitoredRegions;
}

- (void)beaconManager:(id)manager didEnterRegion:(CLBeaconRegion *)region {
    TrackedBeacon *trackedBeacon = [self trackedBeaconsWithRegion:region];
    [self updateTrackedBeacon:trackedBeacon userInRegion:YES];
}

- (void)beaconManager:(id)manager didExitRegion:(CLBeaconRegion *)region {
    TrackedBeacon *trackedBeacon = [self trackedBeaconsWithRegion:region];
    [self updateTrackedBeacon:trackedBeacon userInRegion:NO];
}

- (void)updateTrackedBeacon:(TrackedBeacon *)trackedBeacon userInRegion:(BOOL)userInRegion {
    trackedBeacon.userInRegion = userInRegion;
    [self.beaconRegionBus fire:[BeaconRegionEvent eventWithTrackedBeacon:trackedBeacon]];
}


@end