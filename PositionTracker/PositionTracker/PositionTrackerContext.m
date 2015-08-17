//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import "PositionTrackerContext.h"
#import "BeaconTrackerService.h"
#import "BeaconIOService.h"
#import "CoreDataManager.h"
#import "Beacon.h"

@interface PositionTrackerContext ()
@property(nonatomic, readwrite) BeaconTrackerService *beaconTrackerService;
@property(nonatomic, readwrite) BeaconIOService *beaconIOService;
@property(nonatomic, strong) CoreDataManager *coreDataManager;
@end

@implementation PositionTrackerContext

+ (PositionTrackerContext *)instance {
    static PositionTrackerContext *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.coreDataManager = [[CoreDataManager alloc] initWithDBName:@"PositionTarker.sqlite"];
        self.beaconIOService = [[BeaconIOService alloc] init];
        self.beaconIOService.coreDataManager = self.coreDataManager;

        self.beaconTrackerService = [[BeaconTrackerService alloc] initWithBeacons:[self beacons]];
        [self.beaconTrackerService.beaconRegionBus addHandler:self.beaconIOService];
    }

    return self;
}

- (NSArray *)beacons {
    NSArray *beacons = [self.beaconIOService beacons];
    if (beacons.count != 0) {
        return beacons;
    }
    __block NSMutableArray *ret = [NSMutableArray array];
    [self.coreDataManager performOperation:^(CoreDataObject *object) {
        Beacon *blueberryBeacon = [object createEntityWithClass:[Beacon class]];
        blueberryBeacon.name = @"blueberry";
        blueberryBeacon.proximityUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
        blueberryBeacon.major = 62204;
        blueberryBeacon.minor = 54139;
        [ret addObject:blueberryBeacon];
        Beacon *iceBeacon = [object createEntityWithClass:[Beacon class]];
        iceBeacon.name = @"ice";
        iceBeacon.proximityUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
        iceBeacon.major = 24506;
        iceBeacon.minor = 60141;
        [ret addObject:iceBeacon];
        Beacon *mintBeacon = [object createEntityWithClass:[Beacon class]];
        mintBeacon.name = @"mint";
        mintBeacon.proximityUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
        mintBeacon.major = 24736;
        mintBeacon.minor = 52745;
        [ret addObject:mintBeacon];
        [object save];
    }];
    return ret;
}

@end