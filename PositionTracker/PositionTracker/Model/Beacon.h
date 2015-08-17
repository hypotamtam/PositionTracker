//
//  Beacon.h
//  PositionTracker
//
//  Created by Thomas Cassany on 13/06/2015.
//  Copyright (c) 2015 Thomas Cassany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeaconPositionEvent;

@interface Beacon : NSManagedObject

@property (nonatomic) int32_t major;
@property (nonatomic) int32_t minor;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * proximityUUID;
@property (nonatomic, retain) NSOrderedSet *beaconPosition;
@end

@interface Beacon (CoreDataGeneratedAccessors)

- (void)insertObject:(BeaconPositionEvent *)value inBeaconPositionAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBeaconPositionAtIndex:(NSUInteger)idx;
- (void)insertBeaconPosition:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBeaconPositionAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBeaconPositionAtIndex:(NSUInteger)idx withObject:(BeaconPositionEvent *)value;
- (void)replaceBeaconPositionAtIndexes:(NSIndexSet *)indexes withBeaconPosition:(NSArray *)values;
- (void)addBeaconPositionObject:(BeaconPositionEvent *)value;
- (void)removeBeaconPositionObject:(BeaconPositionEvent *)value;
- (void)addBeaconPosition:(NSOrderedSet *)values;
- (void)removeBeaconPosition:(NSOrderedSet *)values;
@end
