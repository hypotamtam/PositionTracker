//
//  BeaconPositionEvent.h
//  PositionTracker
//
//  Created by Thomas Cassany on 13/06/2015.
//  Copyright (c) 2015 Thomas Cassany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Beacon;

@interface BeaconPositionEvent : NSManagedObject

@property (nonatomic) NSTimeInterval eventDate;
@property (nonatomic) BOOL isEnter;
@property (nonatomic, retain) Beacon *beacon;

@end
