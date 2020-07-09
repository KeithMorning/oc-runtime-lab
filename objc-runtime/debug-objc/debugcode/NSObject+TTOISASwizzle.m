//
//  NSObject+TTOISASwizzle.m
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import "NSObject+TTOISASwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (TTOISASwizzle)

- (void)setClass:(Class)aclass{
    object_setClass(self, aclass);
}

@end
