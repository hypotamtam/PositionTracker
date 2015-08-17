#import "CoreDataManager.h"

#import <CoreData/CoreData.h>

@interface CoreDataManager ()

@property (nonatomic, strong) NSString* dbName;
@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@property (nonatomic, strong) CoreDataObject* mainCoreDataObject;
@property (nonatomic, strong) CoreDataObject* bgCoreDataObject;

@property (nonatomic, strong) NSMutableSet* listener;

@end


@implementation CoreDataManager

-(id)init {
    self = [super init];
    if (self) {
        self.listener = [NSMutableSet set];
        self.dbName = @"defaultBDName.sqlite";
    }
    return self;
}

-(id)initWithDBName:(NSString*)adbName {
    self = [self init];
    if (self) {
        self.dbName = adbName;
    }
    return self;
}

-(void)deleteAll {
    NSError* error = nil;
    NSURL* storeURL = [[self applicationCachesDirectory] URLByAppendingPathComponent:self.dbName];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    if (error) {
        NSLog(@"error deleting DB %@", [error description]);
    }
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
    self.mainCoreDataObject = nil;
    self.bgCoreDataObject = nil;
    [self.listener enumerateObjectsUsingBlock:^(id obj, BOOL* stop) {
        [((id <CoreDataManagerListener>)obj) onDataDeleted];
    }];
}


-(CoreDataObject*)mainCoreDataObject {
    if (_mainCoreDataObject == nil) {
        NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        _mainCoreDataObject = [[CoreDataObject alloc] init];
        _mainCoreDataObject.context = context;
        _mainCoreDataObject.model = self.managedObjectModel;
    }

    return _mainCoreDataObject;
}


-(CoreDataObject*)bgCoreDataObject {
    if (_bgCoreDataObject == nil) {
        NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setParentContext:self.mainCoreDataObject.context];
        _bgCoreDataObject = [[CoreDataObject alloc] init];
        _bgCoreDataObject.context = context;
        _bgCoreDataObject.model = self.managedObjectModel;
    }

    return _bgCoreDataObject;
}

-(void)performOperation:(void (^)(CoreDataObject* object))block {
    if ([NSThread isMainThread]) {
        block(self.mainCoreDataObject);
    } else {
        [self.bgCoreDataObject.context performBlockAndWait:^{
            @try {
                block(self.bgCoreDataObject);
            } @catch (NSException* exception) {
                NSLog(@"%@", [exception description]);
            }
        }];
    }
}

-(void)addListener:(id <CoreDataManagerListener>)listener {
    [self.listener addObject:listener];
}

-(void)removeListener:(id <CoreDataManagerListener>)listener {
    [self.listener removeObject:listener];
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in
 application bundle.
 */
-(NSManagedObjectModel*)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

-(NSURL*)applicationCachesDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator {

    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL* storeURL = [[self applicationCachesDirectory] URLByAppendingPathComponent:self.dbName];

    NSError* error = nil;
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should
         not use this function in a shipping application, although it may be useful during
         development. If it is not possible to recover from the error, display an alert panel that
         instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object
         model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}

@end




