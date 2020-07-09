//
//  TTPTestISA.m
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import "TTPTestISA.h"
#import "NSObject+TTOISASwizzle.h"

@interface MyNotification : NSNotificationCenter

@end

@implementation MyNotification

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSNotificationName)aName object:(id)anObject{
    [super addObserver:observer selector:aSelector name:aName object:anObject];
    NSLog(@"add observer for %@",aName);
}

@end

@implementation TTPTestISA

+ (void)run{
    id nc = [NSNotificationCenter defaultCenter];
    [nc setClass:MyNotification.class];
    
    NSObject *obj = [NSObject new];
    
    [nc addObserver:obj selector:@selector(description) name:@"testISASwizzle" object:nil];
}

@end
