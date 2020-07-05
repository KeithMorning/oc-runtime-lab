//
//  LabTestRuntime.m
//  debug-objc
//
//  Created by Keithxi on 2020/7/5.
//

#import "LabTestRuntime.h"
#import "objc-runtime.h"
#import "Testobject.h"

@implementation LabTestRuntime

+ (void)run{
    [self objcClassStructTest];
    [self classVarAndMeathod];
    [self dynamicCreateClass];
    [self dynamicCreateInstance];
    [self operateTheInstance];
    [self findAllClass];
}

#pragma mark - objc class struct

+ (void)objcClassStructTest{
    
    Testobject *obj = [Testobject new];
    obj.name = @"TEST";
    Class cls = obj.class;
    
    //验证OC 的类结构
    const char *name = class_getName(cls);
    NSLog(@"Classname is %s",name);
    makeLine();
    
    NSLog(@"super class name is %s",class_getName(class_getSuperclass(cls)));
    NSLog(@"super class's supper class name is %s",class_getName(class_getSuperclass(class_getSuperclass(cls))));
    makeLine();
    
    NSLog(@"class is %s a metaclass",class_isMetaClass(cls)?"":"not");
    
    Class metaClass = objc_getMetaClass(class_getName(cls));
    NSLog(@" %s class's meta class is %s",class_getName(cls),class_getName(metaClass));
    
    Class rootmetaclass = object_getClass(metaClass);
    NSLog(@"root metaclass is %s",class_getName(rootmetaclass));
    
    Class rootmetaclassclass = object_getClass(rootmetaclass);
    
    NSLog(@"root metaclass's meta class  is %s",class_getName(rootmetaclassclass));
    
    NSLog(@"root metaclass supper class is %s",class_getName(class_getSuperclass(rootmetaclassclass)));
    
    makeLine();

    NSLog(@"class size is %zu",class_getInstanceSize(cls));//由于内存对齐，iOS 中为8的倍数
    
    makeLine();
    
    NSLog(@"obj address is %p and it's first var address %p",obj, [obj numP]);
    
    makeLine();
}

+ (void)classVarAndMeathod{
    
    Testobject *obj = [Testobject new];
    obj.name = @"TEST";
    Class cls = obj.class;
    const char * classname = class_getName(cls);
    
    uint propertycount;
    objc_property_t *properties = class_copyPropertyList(cls, &propertycount);
    for(uint i =0; i< propertycount; i++){
       const char *propertyName = property_getName(properties[i]);
        NSLog(@"this class %s has property name is %s",class_getName(cls),propertyName);
    }
    free(properties);
    makeLine();
    
    unsigned int ivarcount = 0;
    Ivar *vars = class_copyIvarList(cls, &ivarcount);
    for(uint i = 0; i < ivarcount; i++){
        Ivar var = vars[i];
        const char *varname = ivar_getName(var);
        NSLog(@"this class %s has var name is %s,offset is %zu",class_getName(cls),varname,ivar_getOffset(var));
    }
    free(vars);
    
    makeLine();
    
    uint meathodscount = 0;
    Method *meathods =  class_copyMethodList(cls, &meathodscount);
    for(uint i = 0; i< meathodscount;i++){
        Method method = meathods[i];
        SEL methodname = method_getName(method);
        NSLog(@"this class %s has method name is %s",class_getName(cls),methodname);
    }
    free(meathods);
    makeLine();
    
    Method meathod1 = class_getInstanceMethod(cls, @selector(meathod1));
    if(meathod1 != nil){
        NSLog(@"instance method is %s",method_getName(meathod1));
    }
    
    Method methodinclass = class_getClassMethod(cls, @selector(classMeathod));
    if(methodinclass != nil){
        NSLog(@"class meathod is %s",method_getName(methodinclass));
    }
    
    NSLog(@"class %s response to select method3:arg2: is %s", classname,class_respondsToSelector(cls, @selector(method3:arg2:))?"yes":"no");//实例方法
    
     NSLog(@"class %s meta class response to select method4:arg2: is %s", classname,class_respondsToSelector(object_getClass(cls), @selector(method4:arg2:))?"yes":"no"); //类方法
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    makeLine();
    
    uint protocolcount = 0;
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &protocolcount);
    
    for(uint i = 0; i< protocolcount; i++){
        Protocol *protocol = protocols[i];
        NSLog(@"class %s has repond to protocol %s",classname,protocol_getName(protocol));
    }
    makeLine();
    
}

#pragma mark - dynamic create class
+ (void)dynamicCreateClass{
    //动态创建类
    
    Class newClass = objc_allocateClassPair([Testobject class], "DynamicClass", 0);
    class_addMethod(newClass, @selector(hello:), (IMP)helloFucntion, "v@:@");
    class_replaceMethod(newClass, @selector(method1), (IMP)helloFuction2, @"v@:");
    BOOL result1  =class_addIvar(newClass, "_ivar", sizeof(NSString *), log(sizeof(NSString *)), "@");
    BOOL result2 = class_addIvar(Testobject.class, "_ivars", sizeof(NSString *), log(sizeof(NSString *)), "@"); //已存在的class不支持添加，已经存在的class内存是已经分配好的，无法进行修改
    NSLog(@"add var to a in contruct class is %d and a exist class is %d",result1,result2);
    
    objc_property_attribute_t type = {"T","@"};
    objc_property_attribute_t owership = {"C",""};//copy
    objc_property_attribute_t rwflag = {"R",""};
    objc_property_attribute_t backingvar = {"V","_ivar"}; //实际的变量
    
    objc_property_attribute_t attris[] ={type,owership,rwflag,backingvar};
    class_addProperty(newClass, "myVar", attris, 3);
    class_addMethod(newClass, @selector(myVar), (IMP)myVar, "@@:");
    class_addMethod(newClass, @selector(setMyVar:), (IMP)setMyVar, @"v@:@");
    
    objc_registerClassPair(newClass);
    
    
    uint propertycount;
    objc_property_t *properties = class_copyPropertyList(newClass, &propertycount);
    for(uint i =0; i< propertycount; i++){
       const char *propertyName = property_getName(properties[i]);
        NSLog(@"this class %s has property name is %s",class_getName(newClass),propertyName);
    }
    free(properties);

    
    id dynamicObjc = [[newClass alloc] init];
    [dynamicObjc performSelector:@selector(setName:) withObject:@"dynamicSetName"];
    [dynamicObjc performSelector:@selector(setMyVar:) withObject:@"dynamic var"];
    [dynamicObjc performSelector:@selector(hello:) withObject:@"dynamic class"];
    [dynamicObjc performSelector:@selector(method1) withObject:@"dynamic class"];
    
    //读取属性
    NSLog(@"new class %s property %s value is %@ ",class_getName(newClass),"myVar",[dynamicObjc performSelector:@selector(myVar)]);
    makeLine();

    
}

#pragma mark -- dynamic create instace

+ (void)dynamicCreateInstance{
    id theobjct = class_createInstance(NSObject.class, 0);
    id objc = [theobjct init];
    NSLog(@"%@",[objc class]);
    makeLine();
}

#pragma mark -- oprator the instance

+ (void)operateTheInstance{
    NSObject *obj = [NSObject new];
   // id newB = object_copy(obj,class_getInstanceSize(Testobject.class));
    
    object_setClass(obj, Testobject.class);
    NSLog(@"obj now is a %@ class",object_getClass(obj));
    
    object_setClass(obj, NSObject.class);
    //object_dispose(obj); //onlu no-arc
    makeLine();
    
}

#pragma mark -- class list

+ (void)findAllClass{
    int numClasses;
    Class *classes = NULL;

    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    NSLog(@"Number of classes: %d", numClasses);

    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            NSLog(@"Class name: %s", class_getName(classes[i]));
        }
        free(classes);
    }
    makeLine();
    

}






#pragma mark - private c function

void setMyVar(id target,SEL sel, NSString *value){
    Ivar var = class_getInstanceVariable([target class], "_ivar");
    object_setIvar(target,var, value);
}

NSString *myVar(id target,SEL sel){
    Ivar var = class_getInstanceVariable([target class], "_ivar");
   return object_getIvar(target, var);
}


void helloFucntion(id target,SEL sel,NSString *name){
    NSLog(@"hello %@",name);
}

void helloFuction2(id target, SEL sel){
    NSLog(@"hello from %@",NSStringFromSelector(sel));
}

void makeLine(){
    NSLog(@"************************************************************************");
}

@end
