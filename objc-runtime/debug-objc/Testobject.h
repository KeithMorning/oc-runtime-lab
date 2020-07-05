//
//  Testobject.h
//  debug-objc
//
//  Created by Keithxi on 2020/7/4.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol1 <NSObject>
- (void)protoltest;
@end

@protocol TestProtocol2 <NSObject>
@end


NS_ASSUME_NONNULL_BEGIN

@interface Testobject : NSObject
{
    @public
    NSInteger _num;
}

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSObject *objc;

@property (nonatomic,assign) NSInteger num;

- (void)method1;

+ (void)method1;

- (void)method3:(NSString *)name arg2:(NSString *)arg2;

+ (void)method4:(NSString *)name arg2:(NSString *)arg2;

- (NSInteger *)numP;
@end

NS_ASSUME_NONNULL_END
