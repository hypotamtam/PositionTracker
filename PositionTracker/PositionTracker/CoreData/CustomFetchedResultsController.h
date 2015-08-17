#import <CoreData/CoreData.h>

@interface CustomFetchedResultsController : NSFetchedResultsController

@property (nonatomic, strong) NSString* requestName;
@property (nonatomic, strong) NSDictionary* requestParams;
@property (nonatomic, strong) NSArray* sortArray;
@property (nonatomic, strong) NSString* field;

@end
