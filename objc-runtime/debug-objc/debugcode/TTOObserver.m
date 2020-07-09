//
//  TTOObserver.m
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import "TTOObserver.h"
#import <objc/runtime.h>


@protocol TTOTestProtocl <NSObject>

- (void)helloworld;

@optional
- (void)printname;

@end

@protocol TTOTestProtocl;

@interface TTOTestobj : NSObject<TTOTestProtocl>
@end

@implementation TTOTestobj

- (void)helloworld{
    NSLog(@"hello world your name is what?");
}

- (void)printname{
    NSLog(@"my name is testobjet");
}

@end

@interface TTOTestobj2 : NSObject<TTOTestProtocl>
@end

@implementation TTOTestobj2

- (void)helloworld{
    NSLog(@"my name is tt obj2");
}

@end

@interface TTOObserverExample ()

@end

@implementation TTOObserverExample

+ (void)run{
    id observer = [[TTOObserver alloc] initWithProtocol:@protocol(TTOTestProtocl)];
    TTOTestobj *obj1 = [TTOTestobj new];
    TTOTestobj2 *obj2 = [TTOTestobj2 new];
    
    [observer addObserver:obj1];
    [observer addObserver:obj2];
    
    [observer helloworld];
    [observer printname];
    
}



@end


@interface TTOObserver()

@property (nonatomic,strong) Protocol *protocol;

@property (nonatomic,strong) NSMutableSet *sets;

@end

@implementation TTOObserver

- (instancetype)initWithProtocol:(Protocol *)protocol{
    if (self  = [super init]) {
        _protocol = protocol;
        _sets = [NSMutableSet new];
    }
    
    return self;
}

- (void)addObservers:(NSArray *)objs{
    
}

- (void)addObserver:(id)obj{
    
    NSAssert([obj conformsToProtocol:self.protocol], @"observer must comform the procol");
    
    [self.sets addObject:obj];
    
}

- (void)removeObserver:(id)obj{
    [self.sets removeObject:obj];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature * result = [super methodSignatureForSelector:aSelector];
    if(result){
        return result;
    }
    
    struct objc_method_description desc = protocol_getMethodDescription(self.protocol, aSelector, YES, YES);
    if(desc.name == NULL){//也可能是非必选方法
        desc = protocol_getMethodDescription(self.protocol, aSelector, NO, YES);
    }
    if(desc.name == NULL){
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void) forwardInvocation:(NSInvocation *)anInvocation{
    SEL selector = [anInvocation selector];
    
    for(id responser in self.sets){
        if([responser respondsToSelector:selector]){
            [anInvocation setTarget:responser];
            [anInvocation invoke];
        }
    }
}

@end
