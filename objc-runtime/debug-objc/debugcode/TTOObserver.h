//
//  TTOObserver.h
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import <Foundation/Foundation.h>

@interface TTOObserverExample : NSObject

+ (void)run;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTOObserver : NSObject

- (instancetype)initWithProtocol:(Protocol *)protocol;

- (void)addObserver:(id)obj;

- (void)addObservers:(NSArray *)objs;

- (void)removeObserver:(id)obj;

@end

NS_ASSUME_NONNULL_END
