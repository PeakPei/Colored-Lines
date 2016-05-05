//
//  MulticastDelegate.m
//  Lines
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import "MulticastDelegate.h"

@implementation MulticastDelegate
{
    // the array of observing delegates
    NSMutableArray* _delegates;
}

- (id)init
{
    if (self = [super init])
    {
        _delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addDelegate:(id)delegate
{
    [_delegates addObject:delegate];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return YES;
    
    // if any of the delegates respond to this selector, return YES
    for(id delegate in _delegates)
    {
        if ([delegate respondsToSelector:aSelector])
        {
            return YES;
        }
    }
    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // can this class create the sinature?
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    
    // if not, try our delegates
    if (!signature)
    {
        for(id delegate in _delegates)
        {
            if ([delegate respondsToSelector:aSelector])
            {
                return [delegate methodSignatureForSelector:aSelector];
            }
        }
    }
    return signature;
} 

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // forward the invocation to every delegate
    for(id delegate in _delegates)
    {
        if ([delegate respondsToSelector:[anInvocation selector]])
        {
            [anInvocation invokeWithTarget:delegate];
        }
    }
}
@end
