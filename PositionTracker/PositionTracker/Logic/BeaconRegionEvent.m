//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import "BeaconRegionEvent.h"
#import "TrackedBeacon.h"
#import "BeaconRegionEventHandler.h"

@interface BeaconRegionEvent ()
@property(nonatomic, strong) TrackedBeacon *trackedBeacon;
@end

@implementation BeaconRegionEvent

- (instancetype)initWithTrackedBeacon:(TrackedBeacon *)trackedBeacon {
    self = [super init];
    if (self) {
        self.trackedBeacon = trackedBeacon;
    }

    return self;
}

+ (instancetype)eventWithTrackedBeacon:(TrackedBeacon *)trackedBeacon {
    return [[self alloc] initWithTrackedBeacon:trackedBeacon];
}


- (Protocol *)eventHandler {
    return @protocol(BeaconRegionEventHandler);
}

- (void)dispatch:(id <EventHandler>)handler {
    id <BeaconRegionEventHandler> beaconRegionEventHandler = (id <BeaconRegionEventHandler>) handler;
    [beaconRegionEventHandler didTrackedBeaconStateChange:self.trackedBeacon];
}


@end