//
//  TTObMainTransport.h
//  debug-objc
//
//  Created by KeithXi on 2020/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTObMainTransport : NSObject

@property (nonatomic,readwrite,strong) id target;

- (id) initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
