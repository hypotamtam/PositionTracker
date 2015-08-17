//
// Created by Thomas CASSANY on 13/06/15.
// Copyright (c) 2015 Ocado. All rights reserved.
//

#import "BeaconIOService.h"
#import "CoreDataManager.h"
#import "TrackedBeacon.h"
#import "Beacon.h"
#import "BeaconPositionEvent.h"

@implementation BeaconIOService

- (NSArray *)beacons {
    if (!self.coreDataManager) {
        return nil;
    }

    __block NSArray *ret;
    [self.coreDataManager performOperation:^(CoreDataObject *object) {
        ret = [object selectAllFrom:[Beacon class] where:[NSPredicate predicateWithValue:YES] sortedBy:nil];
    }];
    return ret;
}

- (NSArray *)beaconPositionEvents {
    if (!self.coreDataManager) {
        return nil;
    }

    __block NSArray *ret;
    [self.coreDataManager performOperation:^(CoreDataObject *object) {
        ret = [object selectAllFrom:[BeaconPositionEvent class] where:[NSPredicate predicateWithValue:YES] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"eventDate" ascending:YES]]];
    }];
    return ret;

}

- (NSData *)csvData {
    NSMutableData *csvData = [NSMutableData data];
    NSMutableString *csvRow = [@"," mutableCopy];
    NSArray *beacons = [self beacons];
    [beacons enumerateObjectsUsingBlock:^(Beacon *beacon, NSUInteger idx, BOOL *stop) {
        [csvRow appendFormat:@"\"Beacon %@\n"
                                     "            %d\",,", beacon.name, idx];
    }];
    [csvRow appendString:@"\n"];
    [csvData appendData:[csvRow dataUsingEncoding:NSUTF8StringEncoding]];

    NSArray *beaconsPositionsEvents = [self beaconPositionEvents];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [beaconsPositionsEvents enumerateObjectsUsingBlock:^(BeaconPositionEvent *event, NSUInteger idx, BOOL *stop) {
        [csvRow setString:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:event.eventDate]]];
        [csvRow appendString:@","];
        [beacons enumerateObjectsUsingBlock:^(Beacon *beacon, NSUInteger beaconIdx, BOOL *stop2) {
            if (beacon.major == event.beacon.major) {
                [csvRow appendString:event.isEnter ? @"1" : @"0"];
            } else {
                [csvRow appendString:@"0"];
            }
            [csvRow appendString:@","];
            [csvRow appendString:@","];
        }];
        [csvRow appendString:@"\n"];
        [csvData appendData:[csvRow dataUsingEncoding:NSUTF8StringEncoding]];
    }];

    return csvData;
}


- (void)didTrackedBeaconStateChange:(TrackedBeacon *)trackedBeacon {
    [self.coreDataManager performOperation:^(CoreDataObject *object) {
        BeaconPositionEvent *beaconPositionEvent = [object createEntityWithClass:[BeaconPositionEvent class]];
        beaconPositionEvent.beacon = trackedBeacon.beacon;
        beaconPositionEvent.eventDate = [NSDate date].timeIntervalSince1970;
        beaconPositionEvent.isEnter = trackedBeacon.isUserInRegion;
        [object save];
    }];
}


@end