#import <objc/runtime.h>
#import "EventBus.h"

@interface EventBus ()
@property (nonatomic, strong) NSMutableDictionary* handlersByEvent;
@end

@implementation EventBus

-(id)init {
    self = [super init];
    if (self) {
        self.handlersByEvent = [NSMutableDictionary dictionary];
    }
    return self;
}


-(void)addHandler:(NSObject<EventHandler>*)handler {
    unsigned int protocolCount = 0;
    Protocol * const* protocolList = class_copyProtocolList(handler.class, &protocolCount);
    for (NSUInteger i = 0; i < protocolCount; i++) {
        Protocol*  handlerProtocol = protocolList[i];
        if (protocol_conformsToProtocol(handlerProtocol, @protocol(EventHandler))) {
            NSString* handlerProtocolName = NSStringFromProtocol(handlerProtocol);
            NSMutableSet* handlers = self.handlersByEvent[handlerProtocolName];
            if (handlers == nil) {
                handlers = [NSMutableSet set];
                self.handlersByEvent[handlerProtocolName] = handlers;
            }
            [handlers addObject:[NSValue valueWithNonretainedObject:handler]];
        }
    }
}

-(void)removeHandler:(NSObject<EventHandler>*)handler {
    unsigned int protocolCount = 0;
    Protocol * const* protocolList = class_copyProtocolList(handler.class, &protocolCount);
    for (NSUInteger i = 0; i < protocolCount; i++) {
        Protocol*  handlerProtocol = protocolList[i];
        if (protocol_conformsToProtocol(handlerProtocol, @protocol(EventHandler))) {
            NSMutableSet* handlers = self.handlersByEvent[NSStringFromProtocol(handlerProtocol)];
            [handlers removeObject:[NSValue valueWithNonretainedObject:handler]];
        }
    }
}


-(void)fire:(id<Event>)event {
    NSMutableSet* handlers = self.handlersByEvent[NSStringFromProtocol([event eventHandler])];
    [handlers enumerateObjectsUsingBlock:^(NSValue* handler, BOOL* stop) {
        [event dispatch:[handler nonretainedObjectValue]];
    }];
}

@end