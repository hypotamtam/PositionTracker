#import <Foundation/Foundation.h>

@protocol EventHandler<NSObject>
@end

@protocol Event<NSObject>
-(Protocol*)eventHandler;
-(void)dispatch:(id<EventHandler>)handler;
@end


@interface EventBus : NSObject

-(void)addHandler:(NSObject<EventHandler>*)handler;
-(void)removeHandler:(NSObject<EventHandler>*)handler;

-(void)fire:(id<Event>)event;
@end