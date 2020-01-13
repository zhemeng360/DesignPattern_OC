//
//  NSObject+MZPerformSelector.m
//  设计模式
//
//  Created by A5 on 2020/1/9.
//  Copyright © 2020 孟哲. All rights reserved.
//

#import "NSObject+MZPerformSelector.h"

@implementation NSObject (MZPerformSelector)

- (id)performClass:(id)aClass selector:(NSString *)aSEL objects:(NSArray <id> *)objects type:(RequestMethodType)type
{
    return [self performTarget:aClass selector:aSEL objects:objects type:type singletonType:YES];
}

- (id)performClassName:(NSString *)className selector:(NSString *)aSEL objects:(NSArray <id> *)objects type:(RequestMethodType)type
{
    Class aClass = NSClassFromString(className);
    
    return [self performTarget:aClass selector:aSEL objects:objects type:type singletonType:NO];
}

- (id)performTarget:(Class)aClass selector:(NSString *)aSEL objects:(NSArray <id> *)objects type:(RequestMethodType)type singletonType:(BOOL)isYes
{
    
    SEL aSelector = NSSelectorFromString(aSEL);
    
    NSMethodSignature *signature = nil;
    if (type == kInstanceMethod) {
        signature = [[aClass class] instanceMethodSignatureForSelector:aSelector];
    }else if (type == kClassMethod){
        signature = [[aClass class] methodSignatureForSelector:aSelector];
    }
    
    if (!signature) {
        NSString *info = [NSString stringWithFormat:@"-[%@ %@]:unrecognized selector sent to instance",[aClass class],NSStringFromSelector(aSelector)];
        @throw [[NSException alloc] initWithName:@"MZ崩溃错误提示:" reason:info userInfo:nil];
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    id target = nil;
    if (isYes) {
        target = aClass;
    }else{
        if (type == kInstanceMethod) {
            target = [[aClass alloc] init];
        }else if (type == kClassMethod){
            target = aClass;
        }
    }
    invocation.target = target;
    invocation.selector = aSelector;
    
    NSInteger arguments = signature.numberOfArguments - 2;
    
    NSUInteger objectsCount = objects.count;
    NSInteger count = MIN(arguments, objectsCount);
    for (int i = 0; i < count; i++) {
        id obj = objects[i];
        if ([obj isKindOfClass:[NSNull class]]) {obj = nil;}
        [invocation setArgument:&obj atIndex:i+2];
    }
    
    [invocation invoke];
    
    id returnValue = nil;
    const char *returnType = signature.methodReturnType;
    if(!strcmp(returnType, @encode(void))){
        returnValue = nil;
    }else if(!strcmp(returnType, @encode(id))){
        [invocation getReturnValue:&returnValue];//returnValue = 返回值
    }else{//类型并不全，需要的话需要扩展
        NSUInteger length = [signature methodReturnLength];
        void *buffer = (void *)malloc(length);
        [invocation getReturnValue:buffer];
        if(!strcmp(returnType,@encode(BOOL))){
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }else if(!strcmp(returnType,@encode(NSInteger))){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }else if(!strcmp(returnType,@encode(float))){
            returnValue = [NSNumber numberWithFloat:*((float *)buffer)];
        } else{
            NSValue *value = [NSValue value:&buffer withObjCType:returnType];
            returnValue = value;
        }
        free(buffer);
    }
    return returnValue;
}

+ (id)objectForClassName:(NSString *)className{
    Class aClass = NSClassFromString(className);
    return [[aClass alloc] init];
}

@end
