//
//  Testobject.m
//  debug-objc
//
//  Created by Keithxi on 2020/7/4.
//

#import "Testobject.h"

@interface Testobject()<TestProtocol1,TestProtocol2>



@end

@implementation Testobject
{

    
    @private
    NSInteger privatenum;
    NSString *objname;
}

- (void)method1{
    NSLog(@"hello world");
}

- (void)method2:(NSString *)name{
    NSLog(@"hello the meathod %@",name);
}

- (void)method3:(NSString *)name arg2:(NSString *)arg2{
    NSLog(@"test the meathod %@ with arg: %@",name,arg2);
}

+ (void)method4:(NSString *)name arg2:(NSString *)arg2{
    NSLog(@"test the meathod %@ with arg: %@",name,arg2);
}



+ (void)classMeathod{
    NSLog(@"this is a Class Meathod");
}

- (void)protoltest{
    NSLog(@"this is protol test");
}

- (NSInteger)num{
    return _num;
}

- (void)setNum:(NSInteger)num{
    _num = num;
}

- (NSInteger *)numP{
    return &_num;
}

@end
