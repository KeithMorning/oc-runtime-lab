//
//  NSObject+TTOISASwizzle.h
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TTOISASwizzle)

- (void)setClass:(Class)aclass;

@end

NS_ASSUME_NONNULL_END
