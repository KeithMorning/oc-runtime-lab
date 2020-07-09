//
//  TTOQuickForward.h
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTOQuickForward : NSProxy

- (instancetype) initwithObject:(id) object properties:(NSArray *)properties;

@end

NS_ASSUME_NONNULL_END
