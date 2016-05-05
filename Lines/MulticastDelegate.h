//
//  MulticastDelegate.h
//  Lines
//
//  Created by Admin on 27.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>

/** handles messages sent to delegates, multicasting these messages to multiple observers. */
@interface MulticastDelegate : NSObject

// Adds the given delegate implementation to the list of observers
- (void)addDelegate:(id)delegate;

@end

