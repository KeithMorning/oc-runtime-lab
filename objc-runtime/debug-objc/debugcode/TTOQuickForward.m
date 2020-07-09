//
//  TTOQuickForward.m
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import "TTOQuickForward.h"
#import <objc/runtime.h>

//实现一个缓存对象，取值的时候先从 proxy取，如果没有会向object 对象取值

@interface TTOQuickForward()

@property (nonatomic,strong) id object;

@property (nonatomic,strong) NSMutableDictionary *valueforProperty;

@end

@implementation TTOQuickForward

- (instancetype)initwithObject:(id)object properties:(NSArray *)properties{
    
    _object = object;
    _valueforProperty = [NSMutableDictionary new];
    
    for(NSString *property in properties){
        class_addMethod([self class], NSSelectorFromString(property), (IMP)propertyIMP, "@@:");
        class_addMethod([self class], selectorFromPropertyname(property), (IMP)setPropertyIMP, "v@:@");
    }
    
    return self;
}

//setFoo: => foo
static NSString *propertyNameForSelector(SEL selector){
    NSMutableString *name = NSStringFromSelector(selector).mutableCopy;
    [name deleteCharactersInRange:NSMakeRange(0, 3)];
    [name deleteCharactersInRange:NSMakeRange(name.length-1, 1)];
    NSString *firstChar = [name substringToIndex:1];
    [name replaceCharactersInRange:NSMakeRange(0, 1) withString:firstChar.lowercaseString];
    return [name copy];
    
}

//foo => setFoo:
static SEL selectorFromPropertyname(NSString *property){
    NSMutableString *name = [property mutableCopy];
    NSString *firstChar = [name substringToIndex:1];
    [name replaceCharactersInRange:NSMakeRange(0, 1) withString:firstChar.uppercaseString];
    [name insertString:@"set" atIndex:0];
    [name appendString:@":"];
    return NSSelectorFromString(name);
}

static id propertyIMP(id self, SEL _cmd){
    NSString *propertyname = NSStringFromSelector(_cmd);
    id value = [[self valueforProperty] objectForKey:propertyname];
    if(value == [NSNull null]){
        return  nil;
    }
    if(value){
        return value;
    }
    
    value = [[self object] valueForKey:propertyname];
    
    //添加缓存
    [[self valueforProperty] setObject:value forKey:propertyname];
    
    return value;;
}

static void setPropertyIMP(id self, SEL _cmd, id avalue){
    id value = [avalue copy];
    
    NSString *propertyname = propertyNameForSelector(_cmd);
    [[self valueforProperty] setObject:(value != nil? value:[NSNull null]) forKey:propertyname];
    [[self object] setValue:value forKey:propertyname];
}

#pragma mark - 覆盖默认方法实现

- (NSString *)description{
    return [NSString stringWithFormat:@"%@(%@)",[super description],self.object];
}

- (BOOL)isEqual:(id)object{
    return [self.object isEqual:object];
}

- (NSUInteger)hash{
    return [self.object hash];
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.object respondsToSelector:aSelector];
}

- (BOOL) isKindOfClass:(Class)aClass{
    return [self.object isKindOfClass:aClass];
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    return self.object;
}

- (void) forwardInvocation:(NSInvocation *)invocation{
    [invocation setTarget:self.object];
    [invocation invoke];
}


@end
