#import "CoreDataObject.h"

#import "CustomFetchedResultsController.h"

@implementation CoreDataObject

-(id)createEntityWithClass:(Class)objClass {
    NSString* className = NSStringFromClass(objClass);
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:self.context];
}

-(void)deleteEntity:(NSManagedObject*)obj {
    [self.context deleteObject:[self.context objectWithID:[obj objectID]]];
}


-(void)save {
    NSError* error = nil;
    [self.context save:&error];
    if (error) {
        NSLog(@"error saving context %@", [error description]);
    }
}


-(NSArray*)executeFetchRequest:(NSFetchRequest*)fetchRequest {
    NSError* error = nil;
    NSArray* requestResult = [self.context executeFetchRequest:fetchRequest error:&error];
    if (error) {
            NSLog(@"%@", error);
    }
    return requestResult;
}

-(NSArray*)executeFetchRequestWithName:(NSString*)requestName {
    NSFetchRequest* rq = [self.model fetchRequestTemplateForName:requestName];
    return [self executeFetchRequest:rq];
}

-(NSArray*)executeFetchRequestWithName:(NSString*)requestName withParameters:(NSDictionary*)params {
    NSFetchRequest* rq = [self.model fetchRequestFromTemplateWithName:requestName substitutionVariables:params];
    return [self executeFetchRequest:rq];
}

-(NSFetchRequest*)requestToSelectAllFrom:(Class)objClass where:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors {
    NSString* className = NSStringFromClass(objClass);
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:className];
    request.predicate = predicate;

    if (sortDescriptors) {
       request.sortDescriptors = sortDescriptors;
    }
    return request;
}

-(NSArray*)selectAllFrom:(Class)objClass where:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors  {
    return [self executeFetchRequest:[self requestToSelectAllFrom:objClass where:predicate sortedBy:sortDescriptors]];
}

-(NSFetchedResultsController*)selectAllFrom:(Class)objClass where:(NSPredicate*)predicate sortedBy:(NSArray*)sortDescriptors onField:(NSString*)field {
    NSFetchRequest* request = [self requestToSelectAllFrom:objClass where:predicate sortedBy:sortDescriptors];

    NSError* error = nil;
    NSFetchedResultsController* ret = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:self.context
                                                                            sectionNameKeyPath:field
                                                                                     cacheName:@"MyFRCCache"];

    if (![ret performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        ret = nil;
    }

    return ret;
}

-(NSFetchedResultsController*)getFetchResultControllerWith:(NSString*)requestName withParameters:(NSDictionary*)params sortedBy:(NSArray*)sortDescriptors onField:(NSString*)field {
    if (!sortDescriptors) {
        return nil;
    }
    NSFetchRequest* rq = [self.model fetchRequestFromTemplateWithName:requestName substitutionVariables:params];
    rq.sortDescriptors = sortDescriptors;

    NSError* error = nil;
    CustomFetchedResultsController* ret = [[CustomFetchedResultsController alloc] initWithFetchRequest:rq
                                                                                  managedObjectContext:self.context
                                                                                    sectionNameKeyPath:field
                                                                                             cacheName:@"MyFRCCache"];

    if (![ret performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        ret = nil;
    }

    return ret;
}


-(NSUInteger)countOfEntity:(Class)objClass where:(NSPredicate*)predicate {
    NSFetchRequest* request = [self requestToSelectAllFrom:objClass where:predicate sortedBy:nil];
    NSError* error;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error getting entity count %@", [error description]);
        count = 0;
    }
    return count;
}

@end
