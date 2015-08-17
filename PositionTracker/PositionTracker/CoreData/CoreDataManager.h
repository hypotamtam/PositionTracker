#import <Foundation/Foundation.h>
#import "CoreDataObject.h"

@protocol CoreDataManagerListener
-(void)onDataDeleted;
@end

@interface CoreDataManager : NSObject
-(id)initWithDBName:(NSString*)dbName;
-(void)deleteAll;
-(void)performOperation:(void (^)(CoreDataObject* object))block;

-(void)addListener:(id<CoreDataManagerListener>)listener;
-(void)removeListener:(id<CoreDataManagerListener>)listener;

@end
