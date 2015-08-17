#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface CoreDataObject : NSObject

@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSManagedObjectModel* model;

-(id)createEntityWithClass:(Class)objClass;
-(void)deleteEntity:(NSManagedObject*)obj;
-(void)save;

-(NSArray*)selectAllFrom:(Class)objClass where:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors;
-(NSArray*)executeFetchRequestWithName:(NSString*)requestName;
-(NSArray*)executeFetchRequestWithName:(NSString*)requestName withParameters:(NSDictionary*)params;

-(NSFetchedResultsController*)selectAllFrom:(Class)objClass where:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors onField:(NSString*)field;
-(NSFetchedResultsController*)getFetchResultControllerWith:(NSString*)requestName withParameters:(NSDictionary*)params sortedBy:(NSArray*)sortDescriptors onField:(NSString*)field;

-(NSUInteger)countOfEntity:(Class)objClass where:(NSPredicate*)predicate;

@end
