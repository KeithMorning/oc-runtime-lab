//
//  TTObMainTransport.m
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import "TTObMainTransport.h"

@implementation TTObMainTransport

- (id)initWithTarget:(id)target{
    if(self = [super init]){
        _target = target;
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [self.target methodSignatureForSelector:aSelector];
}

- (void) forwardInvocation:(NSInvocation *)anInvocation{
    [anInvocation setTarget:self.target];
    [anInvocation retainArguments];
    [anInvocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:NO];
    
}



@end
